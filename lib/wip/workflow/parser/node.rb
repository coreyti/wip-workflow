require 'rouge'

module WIP::Workflow
  module Parser
    class Node
      class << self
        def build(data, parent)
          name = data[:node_name].to_s

          case name
          when '#text'
            Parser::Text.new(data, parent)
          when 'SMART_QUOTE'
            data[:node_text] = "'"
            Parser::Text.new(data, parent)
          when 'TYPOGRAPHIC_SYM'
            Parser::Symbol.new(data, parent)
          else
            Parser.const_get(name.capitalize).new(data, parent)
          end
        rescue NameError #UnknownMethodError
          puts "FAILED to build: #{name}"
        end
      end

      attr_reader :data, :parent

      def initialize(data, parent)
        @data   = data
        @parent = parent
      end

      def inspect
        "<#{name} @data=#{@data.inspect}>"
      end

      def to_s
        raise NotImplementedError
      end

      def name
        self.class.name.split('::').last
      end

      def depth
        @data[:depth]
      end

      def index(child)
        compare = child.node.instance_variable_get(:'@data')
        @data[:children].index(compare)
      end

      def nodes
        children.map do |child|
          Node.build(child, self)
        end
      end

      protected

      def children
        @data[:children] || []
      end

      def render
        nodes.join
      end

      private

      def text
        children.map { |child| child[:node_text] }.join
      end
    end

    class Section < Node    ; end
    class Article < Section ; end

    class Codeblock < Node
      def language
        @data[:attributes]['class'].sub(/^language-/, '')
      end

      def to_s
        text
      end

      private

      def text
        @data[:node_text]
      end
    end

    class Codespan < Node
      def to_s
        text
      end

      def text
        @data[:node_text]
      end

      # def render
      #   ['`', @data[:node_text], '`'].join('')
      # end
    end

    class Header < Node
      def to_s
        text
      end

      def depth
        parent.depth
      end
    end

    class P < Node
      def to_s
        text
      end

      # def render
      #   super + "\n\n"
      # end
    end

    class Ol < Node
      # def render
      #   "#{nodes.map(&:render).join}\n"
      # end
    end

    class Ul < Node
      # def render
      #   "#{nodes.map(&:render).join}\n"
      # end
    end

    class Li < Node
      # def render
      #   "- #{nodes.map(&:render).join.strip}\n"
      # end
    end

    # TODO: capture target "HREF", to get (potential) metadata
    class A < Node
      def to_s
        text
      end
    end

    class Br < Node
      def to_s
        "\n"
      end
      # def render
      #   "\n"
      # end
    end

    class Text < Node
      def to_s
        text
      end

      def text
        @data[:node_text]
      end

      # def render
      #   @data[:node_text]
      # end
    end

    # TODO: get the symbol (in Beckett)
    class Symbol < Node
      def to_s
        '<symbol>'
      end
    end
  end
end
