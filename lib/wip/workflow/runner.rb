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
      overview
    end

    def overview
      @ui.out {
        @ui.newline
        @ui.say "# #{stylize(@workflow.heading, :underline)}"

        @ui.newline
        @ui.say @workflow.prologue
      }
    end

    # ---

    def stylize(text, style)
      stylize? ? @ui.out { @ui.color(text, style) } : text
    end

    def stylize?
      true
    end
  end
end
