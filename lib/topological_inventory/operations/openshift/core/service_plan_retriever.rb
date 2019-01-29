require "topological_inventory/operations/openshift/core/retriever"

module TopologicalInventory
  module Operations
    module Openshift
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
