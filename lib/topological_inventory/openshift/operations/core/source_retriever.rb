require "topological_inventory/openshift/operations/core/retriever"

module TopologicalInventory
  module Openshift
    module Operations
      module Core
        class SourceRetriever < Retriever
          private

          def url_path
            "sources/#{@id}"
          end
        end
      end
    end
  end
end
