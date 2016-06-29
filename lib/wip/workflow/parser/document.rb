module WIP::Workflow
  module Parser
    class Document < Beckett::Document
      def initialize(content)
        super
      end

      def build(workflow)
        workflow.heading  = heading
        workflow.prologue = prologue

        workflow
      end

      protected

      def heading
        article.heading
      end

      def prologue
        article.prologue
      end

      private

      def article
        Article.new(self.to_hash[:root][:children][0])
      end
    end
  end
end
