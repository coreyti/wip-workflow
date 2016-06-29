module WIP::Workflow
  module Definition
    class Workflow < Component
      attr_accessor :heading, :prologue, :tasks

      # TODO: consider taking Node, instead/also
      def initialize(command)
        @command = command
      end
    end
  end
end
