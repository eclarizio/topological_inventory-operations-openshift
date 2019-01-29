require "topological_inventory/operations/openshift/core/service_plan_retriever"

module TopologicalInventory
  module Operations
    module Openshift
      module Core
        describe ServicePlanRetriever do
          let(:subject) { described_class.new(123) }

          describe "#process" do
            let(:url) { "http://localhost:3000/api/v0.0/service_plans/123" }
            let(:headers) { {"Content-Type" => "application/json"} }
            let(:dummy_response) { {"dummy" => "response"} }

            before do
              stub_request(:get, url).with(:headers => headers).to_return(:body => dummy_response.to_json)
            end

            it "returns the service plan response" do
              expect(subject.process).to eq(dummy_response)
            end
          end
        end
      end
    end
  end
end
