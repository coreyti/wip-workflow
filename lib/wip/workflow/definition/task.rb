module WIP::Workflow
  module Definition
    class Task < Component
      def heading
        @node.heading
      end

      def prologue
        @node.prologue
      end

      def details
        # all parts, less heading and prologue
        # and with sub-tasks summarized
        body
      end

      def tasks
        @node.tasks.map { |task| Definition::Task.new(task) }
      end

      def code
        @node.code
      end
    end
  end
end
