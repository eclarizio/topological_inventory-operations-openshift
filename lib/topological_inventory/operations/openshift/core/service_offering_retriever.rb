require "topological_inventory/operations/openshift/core/retriever"

module TopologicalInventory
  module Operations
    module Openshift
      module Core
        class ServiceOfferingRetriever < Retriever
          def process
            @api_instance.show_service_offering(@id.to_s)
          end
        end
      end
    end
  end
end
