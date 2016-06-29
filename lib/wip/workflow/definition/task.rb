module WIP::Workflow
  module Definition
    class Task < Component
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
