module WIP::Workflow
  module Definition
    class Builder
      include WIP::Runner::Renderer

      def initialize(command, config, &block)
        raise NotImplementedError if block_given?

        @command = command
        @content = parse(config.to_a.flatten)
      end

      def build
        Workflow.new(@command)
      end

      private

      def parse(config)
        mode, value = config

        case mode
        when :file
          raise render(value)
        when :text
          raise NotImplementedError
        else
          raise NotImplementedError
        end
      end
    end
  end
end
