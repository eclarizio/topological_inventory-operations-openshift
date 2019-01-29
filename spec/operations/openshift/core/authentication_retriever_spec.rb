require "topological_inventory/operations/openshift/core/authentication_retriever"

module TopologicalInventory
  module Operations
    module Openshift
      module Core
        describe AuthenticationRetriever do
          let(:tenant) { Tenant.create! }
          let(:endpoint) { Endpoint.create!(:tenant => tenant) }
          let(:subject) { described_class.new(endpoint.id) }

          describe "#process" do
            let!(:unexpected_authenticaiton) { Authentication.create!(:tenant => tenant) }
            let!(:expected_authentication) do
              Authentication.create!(:resource_type => "Endpoint", :resource_id => endpoint.id, :tenant => tenant)
            end

            it "returns the relevant authentication" do
              expect(subject.process).to eq(expected_authentication)
            end
          end
        end
      end
    end
  end
end
