module WIP::Workflow
  module Definition
    class Component
      attr_reader :heading, :prologue, :node, :parts

      def initialize(node)
        @node     = node
        @heading  = nil
        @prologue = []
        @parts    = []
        in_body   = true

        @node.nodes.each_with_index do |node, index|
          part = Component.new(node)

          case node
          when Parser::Header
            if index == 0
              in_body  = false
              @heading = part
            else
              @parts << part
            end
          when Parser::Section, Parser::Codeblock
            in_body = true
            @parts << part
          else
            if in_body
              @parts << part
            else
              @prologue << part
            end
          end
        end
      end

      def to_s
        @node.to_s
      end

      def parent
        Component.new(@node.parent)
      end

      protected

      def method_missing(method_name, *args, &block)
        if @node.respond_to?(method_name)
          @node.send(method_name, *args, &block)
        else
          @node.instance_eval {
            method_missing(method_name, *args, &block)
          }
        end
      end

      def respond_to_missing?(method_name, include_private = false)
        @node.respond_to?(method_name) || super
      end
    end
  end
end
