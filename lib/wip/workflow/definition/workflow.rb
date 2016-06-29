module WIP::Workflow
  module Definition
    class Workflow < Component
      attr_accessor :heading

      def initialize(command)
        @command = command
      end
    end
  end
end
