module WIP::Workflow
  module Parser
    class Section < Node
      attr_reader :heading, :prologue

      def initialize(*)
        super

        @heading = @data[:children][0][:children][0][:node_text]
        prologue = []

        children.each do |child|
          node = Node.build(child, @depth + 1)

          if node.is_a?(Section)
            puts "TODO: #{node.name}"
          else
            puts "prologue: #{node.inspect}"
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
