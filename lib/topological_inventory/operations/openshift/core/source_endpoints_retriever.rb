require "topological_inventory/operations/openshift/core/retriever"

module TopologicalInventory
  module Operations
    module Openshift
      module Core
        class SourceEndpointsRetriever < Retriever
          def process
            @api_instance.list_source_endpoints(@id.to_s)
          end
        end
      end
    end
  end
end
