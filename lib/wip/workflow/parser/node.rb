module WIP::Workflow
  module Parser
    class Node
      def initialize(data, depth = 0)
        @data  = data
        @depth = depth
      end
    end
  end
end
