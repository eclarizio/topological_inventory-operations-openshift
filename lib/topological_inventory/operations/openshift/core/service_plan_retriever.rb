require "topological_inventory/operations/openshift/core/retriever"

module TopologicalInventory
  module Operations
    module Openshift
      module Core
        class ServicePlanRetriever < Retriever
          def process
            @api_instance.show_service_plan(@id.to_s)
          end
        end
      end
    end
  end
end
