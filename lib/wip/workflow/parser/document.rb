module WIP::Workflow
  module Parser
    class Document < Beckett::Document
      def initialize(content)
        super
      end

      def build(workflow)
        workflow.heading = heading
        workflow
      end

      protected

      def heading
        article.heading
      end

      private

      def article
        Article.new(self.to_hash[:root][:children][0])
      end
    end
  end
end
