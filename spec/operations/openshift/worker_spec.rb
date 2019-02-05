require "topological_inventory/operations/openshift/worker"

describe TopologicalInventory::Operations::Openshift::Worker do
  let(:client) { double(:client) }

  describe "#run" do
    let(:messages) { [ManageIQ::Messaging::ReceivedMessage.new(nil, nil, payload, nil)] }
    let(:task) { Task.create!(:tenant => tenant) }
    let(:tenant) { Tenant.create! }
    let(:service_plan) do
      ServicePlan.create!(:source           => source,
                          :source_ref      => SecureRandom.uuid,
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
    let(:source_region) { SourceRegion.create!(:tenant => tenant, :source => source, :source_ref => SecureRandom.uuid) }
    let(:subscription) { Subscription.create!(:tenant => tenant, :source => source, :source_ref => SecureRandom.uuid) }
    let(:service_offering) do
      ServiceOffering.create!(:source        => source,
                              :source_ref    => SecureRandom.uuid,
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
    let(:task_url) { URI.join(base_url_path, "tasks/#{task.id}").to_s }
    let(:headers) { {"Content-Type" => "application/json"} }

    before do
      allow(ManageIQ::Messaging::Client).to receive(:open).and_return(client)
      allow(client).to receive(:close)
      allow(client).to receive(:subscribe_messages).and_yield(messages)

      stub_request(:get, service_plan_url).with(:headers => headers).to_return(:body => service_plan.to_json)
      stub_request(:get, source_url).with(:headers => headers).to_return(:body => source.to_json)
      stub_request(:get, service_offering_url).with(:headers => headers).to_return(:body => service_offering.to_json)
      stub_request(:post, task_url)

      allow(
        TopologicalInventory::Operations::Openshift::Core::ServiceCatalogClient
      ).to receive(:new).with(source.id).and_return(service_catalog_client)
      allow(service_catalog_client).to receive(:order_service_plan).and_return({'metadata' => {'selfLink' => 'source_ref'}})

      stub_request(:post, task_url).with(:headers => headers)
    end

    it "orders the service via the service catalog client" do
      expect(service_catalog_client).to receive(:order_service_plan).with("plan_name", "service_offering", "order_params")
      described_class.new.run
    end

    it "posts to the update task endpoint with the status and context" do
      context = {
        :service_instance => {
          :source_id  => source.id,
          :source_ref => "source_ref"
        }
      }
      described_class.new.run
      expect(
        a_request(:post, task_url).with(:body => {"status" => "completed", "context" => context})
      ).to have_been_made
    end
  end
end
