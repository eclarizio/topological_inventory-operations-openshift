require "topological_inventory/openshift/operations/core/source_endpoints_retriever"

module TopologicalInventory
  module Openshift
    module Operations
      module Core
        describe SourceEndpointsRetriever do
          let(:subject) { described_class.new(123) }

          describe "#process" do
            let(:url) { "http://localhost:3000/api/v0.0/sources/123/endpoints" }
            let(:headers) { {"Content-Type" => "application/json"} }
            let(:dummy_response) { {"dummy" => "response"} }

            before do
              stub_request(:get, url).with(:headers => headers).to_return(:body => dummy_response.to_json)
            end

            it "returns the service plan response" do
              expect(subject.process).to eq(dummy_response.to_json)
            end
          end
        end
      end
    end
  end
end
