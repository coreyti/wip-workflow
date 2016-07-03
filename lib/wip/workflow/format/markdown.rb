module WIP::Workflow
  module Format
    module Markdown
      class << self
        def apply(article)
          article.nodes.map do |node|
            self.build(node, article).format
          end.join("\n")
        end

        def build(node, parent)
          self.const_get(node.name).new(node, parent)
        rescue NoMethodError
          p [node, parent.node]
          raise
        end
      end

      class Node
        def initialize(node, parent)
          @node   = node
          @parent = parent
        end

        def inspect
          "<#{name} @node=#{@node.inspect}>"
        end

        def node
          @node
        end

        def depth
          @node.depth
        end

        def name
          @node.name
        end
      end

      class Block < Node
        def children
          @node.nodes.map { |child| Markdown.build(child, self) }
        end

        def format(bond = "\n", tail = "\n")
          (children.map(&:format)).join(bond) + tail
        end
      end

      class Inline < Node
        def format
          @node.to_s
        end
      end

      # ---

      class Section < Block ; end

      class P < Block
        def format
          # tail = @parent.is_a?(Li) ? '' : "\n"
          super('', '')
        end
      end

      class Codeblock < Block
        def format
          [nil, "```#{@node.language}", @node, "```"].join("\n")
        end
      end

      # ---

      class List < Block
        def format
          head = @parent.is_a?(Li) ? "\n" : ''
          tail = @parent.is_a?(Li) ? '' : "\n"
          head + super("\n", tail)
        end
      end

      class Ul < List ; end
      class Ol < List ; end

      class Li < Block
        def format
          ['  ' * (@node.depth), "- #{super('', '')}"].join
        end
      end

      # ---

      class Header < Inline
        def format
          ['#' * (1 + @parent.depth), @node.to_s].join(' ') + "\n"
        end
      end

      class A < Inline ; end

      class Codespan < Inline
        def format
          "`#{@node.to_s}`"
        end
      end

      class Text < Inline ; end

      # ---

      class Symbol < Node
        def format
          # p @node
        end
      end
    end
  end
end
