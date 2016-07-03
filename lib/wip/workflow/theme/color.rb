require 'rouge'

module WIP::Workflow
  module Theme
    class Color
      extend Base

      def self.stylize(content)
        theme  = Rouge::Themes::Monokai
        output = Rouge::Formatters::Terminal256.new(theme)
        # lexer  = Rouge::Lexers::Shell.new
        lexer  = Rouge::Lexers::Markdown.new

        output.format(lexer.lex(content))
      end
    end
  end
end
