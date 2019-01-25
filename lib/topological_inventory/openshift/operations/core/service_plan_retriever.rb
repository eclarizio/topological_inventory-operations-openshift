require "topological_inventory/openshift/operations/core/retriever"

module TopologicalInventory
  module Openshift
    module Operations
      module Core
        class ServicePlanRetriever < Retriever
          private

          def url_path
            "service_plans/#{@id}"
          end
        end
      end
    end
  end
end
