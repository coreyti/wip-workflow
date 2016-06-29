module WIP::Workflow
  module Definition
    class Workflow < Component
      def initialize(command)
        @command = command
        raise @command.inspect
      end
    end
  end
end
