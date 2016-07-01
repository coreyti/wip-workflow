module WIP::Workflow
  module Definition
    class Component
      def initialize(node)
        @node = node
      end

      def depth
        @node.depth
      end

      def body
        @node.body
      end
    end
  end
end
