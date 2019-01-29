require "topological_inventory/operations/openshift/core/retriever"

module TopologicalInventory
  module Operations
    module Openshift
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
