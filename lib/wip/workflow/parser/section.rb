module WIP::Workflow
  module Parser
    class Section < Node
      def heading
        @data[:children][0][:children][0][:node_text]
      end
    end
  end
end
