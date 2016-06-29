module WIP::Workflow
  module Definition
    class Workflow < Component
      attr_accessor :heading, :prologue

      def initialize(command)
        @command = command
      end
    end
  end
end
