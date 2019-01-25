require "topological_inventory/openshift/operations/worker"

describe TopologicalInventory::Openshift::Operations::Worker do
  let(:client) { double(:client) }

  describe "#run" do
    let(:messages) { [ManageIQ::Messaging::ReceivedMessage.new(nil, nil, payload, nil)] }
    let(:task) { Task.create!(:tenant => tenant) }
    let(:tenant) { Tenant.create! }
    let(:service_plan) do
      ServicePlan.create!(:source           => source,
                          :tenant           => tenant,
                          :name             => "plan_name",
                          :service_offering => service_offering)
    end
    let(:source_type) { SourceType.create!(:name => "test", :product_name => "test", :vendor => "test") }
    let(:source) do
      Source.create!(:tenant      => tenant,
                     :uid         => SecureRandom.uuid,
                     :name        => "source",
                     :source_type => source_type)
    end
    let(:source_region) { SourceRegion.create!(:tenant => tenant, :source => source) }
    let(:subscription) { Subscription.create!(:tenant => tenant, :source => source) }
    let(:service_offering) do
      ServiceOffering.create!(:source        => source,
                              :tenant        => tenant,
                              :source_region => source_region,
                              :subscription  => subscription,
                              :name          => "service_offering")
    end
    let(:payload) { {:service_plan_id => service_plan.id, :order_params => "order_params", :task_id => task.id} }

    let(:service_catalog_client) { instance_double("ServiceCatalogClient") }
    let(:base_url_path) { "http://localhost:3000/api/v0.0/" }
    let(:service_plan_url) { URI.join(base_url_path, "service_plans/#{service_plan.id}").to_s }
    let(:source_url) { URI.join(base_url_path, "sources/#{source.id}").to_s }
    let(:service_offering_url) { URI.join(base_url_path, "service_offerings/#{service_offering.id}").to_s }
    let(:headers) { {"Content-Type" => "application/json"} }

    before do
      allow(ManageIQ::Messaging::Client).to receive(:open).and_return(client)
      allow(client).to receive(:close)
      allow(client).to receive(:subscribe_messages).and_yield(messages)

      stub_request(:get, service_plan_url).with(:headers => headers).to_return(:body => service_plan.to_json)
      stub_request(:get, source_url).with(:headers => headers).to_return(:body => source.to_json)
      stub_request(:get, service_offering_url).with(:headers => headers).to_return(:body => service_offering.to_json)

      allow(
        TopologicalInventory::Openshift::Operations::Core::ServiceCatalogClient
      ).to receive(:new).with(source.id).and_return(service_catalog_client)
      allow(service_catalog_client).to receive(:order_service_plan).and_return({'metadata' => {'selfLink' => 'source_ref'}})
    end

    it "orders the service via the service catalog client" do
      expect(service_catalog_client).to receive(:order_service_plan).with("plan_name", "service_offering", "order_params")
      described_class.new.run
    end

    it "updates the task with the status 'completed'" do
      described_class.new.run
      task.reload
      expect(task.status).to eq("completed")
    end

    it "updates the task with the context from the ordered service plan" do
      described_class.new.run
      task.reload
      expect(task.context).to eq({
        "service_instance" => {
          "source_id"  => source.id,
          "source_ref" => "source_ref"
        }
      })
    end
  end
end
