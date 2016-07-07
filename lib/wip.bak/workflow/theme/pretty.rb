module WIP::Workflow
  module Theme
    module Pretty
      extend Base

      def self.stylize(content)
        # content.gsub(/^/, '    ')
        content
      end
    end
  end
end
