module Firstep
  module Java
    module DefaultConfigurations
      def configurations
        [checkstyle, cobertura]
      end

      def checkstyle
        @checkstyle ||= Configuration.new('checkstyle') do |config|
          config.items << checkstyle_configuration
        end
      end

      def cobertura
        @cobertura ||= Configuration.new('cobertura')
      end

      def checkstyle_configuration
        @checkstyle_configuration ||= ConfigItem.new(File.join(File.dirname(__FILE__), 'checkstyle', 'checkstyle.xml'), File.join('config', 'checkstyle'))
      end
    end

    class ConfigItem
      attr_reader :file, :target_directory

      def initialize(file, target_directory)
        @file = file
        @target_directory = target_directory
      end
    end

    class Configuration
      attr_reader :name
      attr_accessor :items

      def initialize(name)
        @name = name
        @items = []
        yield self if block_given?
      end
    end
  end
end