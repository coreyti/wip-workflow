module WIP::Workflow
  module Parser
    class Section < Node
      attr_reader :heading, :prologue, :tasks, :code

      def initialize(*)
        super

        @heading = @data[:children][0][:children][0][:node_text]
        @code    = []
        @tasks   = []
        prologue = []

        children.each do |child|
          node = Node.build(child, @depth + 1)

          case node
          when Codeblock
            code << node
          when Section
            tasks << node
          else
            prologue << node
          end
        end

        @prologue = prologue.join
      end

      private

      def children
        @data[:children][1..-1]
      end
    end
  end
end
