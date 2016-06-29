module WIP::Workflow
  module Definition
    class Task < Component
      # attr_reader :heading, :prologue, :tasks

      def initialize(node)
        @node = node
      end

      def heading
        @node.heading
      end

      def prologue
        @node.prologue
      end

      def tasks
        @node.tasks.map { |task| Definition::Task.new(task) }
      end
    end
  end
end
