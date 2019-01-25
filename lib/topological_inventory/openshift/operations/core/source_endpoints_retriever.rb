require "topological_inventory/openshift/operations/core/retriever"

module TopologicalInventory
  module Openshift
    module Operations
      module Core
        class SourceEndpointsRetriever < Retriever
          private

          def url_path
            "sources/#{@id}/endpoints"
          end
        end
      end
    end
  end
end
