module TopologicalInventory
  module Openshift
    module Operations
      class << self
        attr_writer :logger
      end

      def self.logger
        @logger ||= Logger.new(STDOUT, :level => Logger::INFO)
      end

      module Logging
        def logger
          TopologicalInventory::OperationsOpenshift.logger
        end
      end
    end
  end
end
