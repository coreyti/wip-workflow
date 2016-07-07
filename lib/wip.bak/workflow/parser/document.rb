require 'beckett'

module WIP::Workflow
  module Parser
    class Document < Beckett::Document
      def initialize(content)
        super
      end

      def article
        Article.new(self.to_hash[:root][:children][0], self)
      end
    end
  end
end
