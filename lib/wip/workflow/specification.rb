module WIP::Workflow
  class Specification < WIP::Runner::Command
    include WIP::Runner::Renderer

    class << self
      def workflow(*args, &block)
        command = (eval 'self', block.send(:binding))
        Definition.define(command, *args, &block)
      end
    end
  end
end
