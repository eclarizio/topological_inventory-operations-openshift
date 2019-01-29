module TopologicalInventory
  module Operations
    module Openshift
      class << self
        attr_writer :logger
      end

      def self.logger
        @logger ||= Logger.new(STDOUT, :level => Logger::INFO)
      end

      module Logging
        def logger
          TopologicalInventory::Operations::Openshift.logger
        end
      end
    end
  end
end
