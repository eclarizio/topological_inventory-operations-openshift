require "topological_inventory/operations/openshift/core/retriever"

module TopologicalInventory
  module Operations
    module Openshift
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
