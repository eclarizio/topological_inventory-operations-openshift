require "topological_inventory/operations/openshift/core/retriever"

module TopologicalInventory
  module Operations
    module Openshift
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
