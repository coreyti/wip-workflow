module WIP::Workflow
  module Parser
    class Section < Node
      attr_reader :heading, :prologue, :tasks, :code, :body

      def initialize(*)
        super

        @heading = @data[:children][0][:children][0][:node_text]
        @body    = []
        @code    = []
        @tasks   = []
        prologue = []
        in_body  = false

        children.each do |child|
          node = Node.build(child, self)

          case node
          when Codeblock
            in_body = true
            code  << node
            @body << node
          when Section
            in_body = true
            tasks << node
            @body << node
          else
            if in_body
              @body << node
            else
              prologue << node
            end
          end
        end

        @prologue = prologue.join
      end

      # protected
      #
      # def children
      #   @data[:children][1..-1]
      # end
    end
  end
end
