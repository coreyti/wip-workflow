require 'wip/workflow/format/markdown'

module WIP::Workflow
  module Format
    class Formatter
      def initialize(format, theme)
        @format = format
        @theme  = theme
      end

      def apply(fragment)
        @theme.apply(@format.apply(fragment))
      end
    end
  end
end
