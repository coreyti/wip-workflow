module WIP::Workflow
  module Definition
    class Workflow < Component
      def initialize(command, article)
        @command = command
        @article = article
      end

      # def parts ; end

      def heading
        @article.heading
      end

      def prologue
        @article.prologue
      end

      def tasks
        @article.tasks.map { |task| Definition::Task.new(task) }
      end
    end
  end
end
