module WIP::Workflow
  module Definition
    class Task < Component
      def tasks
        @tasks ||= begin
          @node.nodes.select { |node| node.is_a?(Parser::Section) }
            .map { |task| Task.new(task) }
        end
      end
    end
  end
end
