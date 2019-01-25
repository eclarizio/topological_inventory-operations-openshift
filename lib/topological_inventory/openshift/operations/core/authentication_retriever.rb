module TopologicalInventory
  module Openshift
    module Operations
      module Core
        class AuthenticationRetriever
          def initialize(endpoint_id)
            @endpoint_id = endpoint_id
          end

          def process
            Authentication.where(:resource_type => "Endpoint", :resource_id => @endpoint_id).first
          end
        end
      end
    end
  end
end
