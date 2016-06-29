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
      process_overview(@workflow)
      process_tasks
    end

    def process_overview(context)
      @ui.out {
        @ui.newline
        @ui.say "# #{stylize(context.heading, :underline)}"

        @ui.newline
        @ui.say context.prologue
      }

      continue? 'yes', 'no'
    end

    def process_tasks
      @workflow.tasks.each do |task|
        process_overview(task)
      end
    end

    # ---

    def continue?(*options)
      choice = @ui.choose(*options) do |menu|
        menu.header = 'Continue'
        menu.flow   = :inline
        menu.index  = :none
      end

      case choice
      when 'yes'
      when 'no'
      when 'skip'
      # when 'step'
      # when 'preview'
      end
    end

    def stylize(text, style)
      stylize? ? @ui.out { @ui.color(text, style) } : text
    end

    def stylize?
      true
    end
  end
end
