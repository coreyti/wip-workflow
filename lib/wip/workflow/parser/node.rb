module WIP::Workflow
  module Parser
    class Node
      class << self
        def build(data, depth)
          name = data[:node_name].to_s

          case name
          when '#text'
            Parser::Text.new(data)
          when 'SMART_QUOTE'
            "'"
          when 'TYPOGRAPHIC_SYM'
            Parser::Symbol.new(data)
          else
            Parser.const_get(name.capitalize).new(data, depth)
          end
        rescue NameError #UnknownMethodError
          puts "FAILED to build: #{name}"
        end
      end

      attr_reader :depth

      def initialize(data, depth = 0)
        @data  = data
        @depth = depth
      end

      def to_s
        render
      end

      def name
        self.class.name
      end

      protected

      def children
        @data[:children]
      end

      def nodes
        children.map do |child|
          Node.build(child, @depth + 1)
        end
      end

      def render
        nodes.join
      end

      private
    end

    # TODO: get 'language' set on CODEBLOCK
    # TODO: if type == 'yaml', and it's meta, don't render (but use it)
    class Codeblock < Node
      def render
        ['```', @data[:node_text], '```', nil, nil].join("\n")
      end
    end

    class Codespan < Node
      def render
        ['`', @data[:node_text], '`'].join('')
      end
    end

    class P < Node
      def render
        super + "\n\n"
      end
    end

    class Ul < Node
      def render
        "#{nodes.map(&:render).join}\n"
      end
    end

    class Li < Node
      def render
        "- #{nodes.map(&:render).join.strip}\n"
      end
    end

    # TODO: capture target "HREF", to get (potential) metadata
    class A < Node ; end

    class Br < Node
      def render
        "\n"
      end
    end

    class Text < Node
      def render
        @data[:node_text]
      end
    end

    # TODO: get the symbol (in Beckett)
    class Symbol < Node
      def render
        '<symbol>'
      end
    end
  end
end
