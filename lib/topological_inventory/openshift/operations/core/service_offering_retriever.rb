require "topological_inventory/openshift/operations/core/retriever"

module TopologicalInventory
  module Openshift
    module Operations
      module Core
        class ServiceOfferingRetriever < Retriever
          private

          def url_path
            "service_offerings/#{@id}"
          end
        end
      end
    end
  end
end
