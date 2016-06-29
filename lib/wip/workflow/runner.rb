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
      process_intro(@workflow)
      process_tasks(@workflow)
    end

    def process_intro(context)
      @ui.out {
        @ui.newline
        @ui.say heading(context)

        @ui.newline
        @ui.say context.prologue
      }

      preview_tasks(context)
      continue? 'yes', 'no'
    end

    def process_tasks(context)
      context.tasks.each do |task|
        process_intro(task)
        process_tasks(task)
      end
    end

    # ---

    def preview_tasks(context)
      context.tasks.each do |task|
        @ui.out {
          @ui.say heading(task)

          @ui.newline
          @ui.say task.prologue
        }
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

    def heading(context)
      prefix  = '#' * (context.depth + 1)
      styles  = [:bold]
      styles << :underline if context.depth == 0

      "#{prefix} #{stylize(context.heading, *styles)}"
    end

    def stylize(text, *style)
      stylize? ? @ui.out { @ui.color(text, *style) } : text
    end

    def stylize?
      true
    end
  end
end
