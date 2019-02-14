require "topological_inventory/operations/openshift/core/retriever"

module TopologicalInventory
  module Operations
    module Openshift
      module Core
        class SourceRetriever < Retriever
          def process
            @api_instance.show_source(@id.to_s)
          end
        end
      end
    end
  end
end
