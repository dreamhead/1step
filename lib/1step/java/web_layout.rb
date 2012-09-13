require 'fileutils'

module Firstep
  module Java
    class WebLayout
      include FileUtils

      def self.create project_layout
        web_config_dir = File.join(project_layout.source_base, 'webapp', 'WEB-INF')
        WebLayout.new(web_config_dir)
      end

      attr_reader :web_config_dir

      def initialize(web_config_dir)
        @web_config_dir = web_config_dir
      end

      def create
        mkdir_p(@web_config_dir)
      end
    end
  end
end