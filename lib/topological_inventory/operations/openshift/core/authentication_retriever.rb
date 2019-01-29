module TopologicalInventory
  module Operations
    module Openshift
      module Core
        class AuthenticationRetriever
          def initialize(endpoint_id)
            @endpoint_id = endpoint_id
          end

          def process
            # Without using Rails example:
            # https://github.com/ManageIQ/topological_inventory-orchestrator/pull/1/files#diff-4743ee12ee7e621468f2e6590de994efR97
            Authentication.where(:resource_type => "Endpoint", :resource_id => @endpoint_id).first
          end
        end
      end
    end
  end
end
