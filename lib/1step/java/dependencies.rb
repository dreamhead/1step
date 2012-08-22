module Firstep
  module Java
    class Dependeny
      attr_reader :group_id, :artifact_id, :version

      def initialize group_id, artifact_id, version
        @group_id = group_id
        @artifact_id = artifact_id
        @version = version
      end
    end

    module DefaultDependencies
      def compile_dependencies
        [guava, joda_time]
      end

      def test_compile_dependencies
        [junit, mockito]
      end

      def junit
        Dependeny.new('junit', 'junit', '4.10')
      end

      def joda_time
        Dependeny.new('joda-time', 'joda-time', '2.1')
      end

      def guava
        Dependeny.new('com.google.guava', 'guava', '13.0')
      end

      def mockito
        Dependeny.new('org.mockito', 'mockito-all', '1.9.0')
      end
    end
  end
end