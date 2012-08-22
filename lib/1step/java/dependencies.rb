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
        [guava]
      end

      def test_compile_dependencies
        [junit]
      end

      def junit
        Dependeny.new('junit', 'junit', '4.10')
      end

      def guava
        Dependeny.new('com.google.guava', 'guava', '13.0')
      end
    end
  end
end