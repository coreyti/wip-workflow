module WIP::Workflow
  module Definition
    class Component
      attr_reader :node, :heading, :prologue, :parts

      # ACK! So very ugly. It's a temp hack to get prompts to be associated
      # with codeblocks, which *might* make sense.
      PROMPTS = []

      def initialize(node, prompts = [])
        @node     = node
        @heading  = nil
        @prologue = []
        @parts    = []
        # @prompt   = nil
        @prompts  = prompts
        @in_body  = true

        @node.nodes.each_with_index do |node, index|
          # p @in_body
          # part = Component.new(node)

          case node
          when Parser::Header
            if index == 0
              # puts "header (setting false)"
              @in_body  = false
              @heading = child(node)
            else
              raise 'HERE?'
              @parts << child(node)
            end
          when Parser::A
            @parts << child(node)
            href = node.data[:attributes]['href']

            if href && href.match(/^#/)
              # @prompt = href
              PROMPTS << href
            end
          when Parser::Codeblock
            # puts "codeblock (setting true)"
            @in_body = true
            @parts << child(node, PROMPTS.dup)
            PROMPTS.clear
          when Parser::Section
            # puts "section (setting true)"
            @in_body = true
            @parts << child(node)
          else
            if @in_body
              @parts << child(node)
            else
              # puts "#{node.name} - prologue"
              @prologue << child(node)
            end
          end
        end
      end

      def prompts
        # @prompt.nil? ? children.map(&:prompts).flatten : [@prompt]
        @prompts
      end

      def child(*args)
        Component.new(*args)
      end

      def to_s
        @node.to_s
      end

      def parent
        Component.new(@node.parent)
      end

      protected

      def children
        ([@heading] + @prologue + @parts).compact
      end

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
