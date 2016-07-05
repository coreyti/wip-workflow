module WIP::Workflow
  module Format
    module Markdown
      class << self
        def apply(component)
          self.build(component, component.parent).to_s
        end

        def build(component, parent)
          self.const_get(component.name).new(component, parent)
        end
      end

      class Node
        attr_reader :component, :parent

        def initialize(component, parent)
          @component = component
          @parent    = parent
        end

        def inspect
          "<#{name} @component=#{@component.inspect}>"
        end

        def depth
          @component.depth
        end

        def name
          @component.name
        end

        def position
          @parent.index(self)
        end

        def index(child)
          @component.index(child)
        end
      end

      class Block < Node
        def children
          @component.parts.map { |child| Markdown.build(child, self) }
        end

        def to_s(bond = "\n", tail = "\n")
          (children.map(&:to_s)).join(bond) + tail
        end
      end

      class Inline < Node
        def to_s
          @component.to_s
        end
      end

      # ---

      class Section < Block ; end

      class P < Block
        def to_s
          tail = @parent.is_a?(Li) ? '' : "\n"
          super('', tail)
        end
      end

      class Codeblock < Block
        def to_s
          [nil, "```#{@component.language}", @component.to_s, "```", nil].join("\n")
        end
      end

      # ---

      class List < Block
        def to_s
          head = @parent.is_a?(Li) ? "\n" : ''
          tail = @parent.is_a?(Li) ? '' : "\n"
          head + super("\n", tail)
        end
      end

      class Ul < List ; end
      class Ol < List ; end

      class Li < Block
        def to_s
          [padding, "#{prefix}#{super('', '')}"].join
        end

        def padding
          '  ' * (depth)
        end

        def prefix
          case @parent.name
          when 'Ol'
            "#{position + 1}. "
          when 'Ul'
            '- '
          end
        end
      end

      # ---

      class Header < Inline
        def to_s
          ['#' * (1 + @parent.depth), @component.to_s].join(' ') + "\n"
        end
      end

      class A < Inline ; end

      class Codespan < Inline
        def to_s
          "`#{@component.to_s}`"
        end
      end

      class Text < Inline ; end

      # ---

      class Symbol < Node
        def to_s
          # p @component
        end
      end
    end
  end
end
