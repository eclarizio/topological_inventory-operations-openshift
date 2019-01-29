module TopologicalInventory
  module Operations
    module Openshift
      module Core
        class Retriever
          def initialize(id)
            @id = id
          end

          def process
            JSON.parse(RestClient::Request.new(request_options).execute)
          end

          private

          def headers
            {"Content-Type" => "application/json"}
          end

          def request_options
            {
              :method  => :get,
              :url     => base_url + url_path,
              :headers => headers
            }
          end

          def base_url
            # "http://#{ENV["TOPOLOGICAL_INVENTORY_API_SERVICE_HOST"]}:#{ENV["TOPOLOGICAL_INVENTORY_API_SERVICE_PORT"]}/#{ENV["PATH_PREFIX"]}/topological-inventory/v0.0/"
            "http://localhost:3000/api/v0.0/"
          end

          def url_path
            nil #Override in subclasses
          end
        end
      end
    end
  end
end
