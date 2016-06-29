module WIP::Workflow
  module Definition
    class Builder
      include WIP::Runner::Renderer

      def initialize(command, config, &block)
        raise NotImplementedError if block_given?

        @command  = command
        @document = parse(config.to_a.flatten)
      end

      def build
        Workflow.new(@document.article)
      end

      private

      def parse(config)
        mode, value = config

        case mode
        when :file
          Parser::Document.new(render(value))
        when :text
          Parser::Document.new(value)
        else
          raise NotImplementedError
        end
      end
    end
  end
end
