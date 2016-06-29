module WIP::Workflow
  class Runner
    def initialize(ui, workflow)
      @ui       = ui
      @workflow = workflow
    end

    def run(arguments, options)
      @arguments = arguments
      @options   = options
      execute
    end

    private

    def execute
      @ui.out {
        @ui.say @workflow.heading
      }
    end
  end
end
