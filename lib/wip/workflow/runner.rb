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
      summarize(@workflow, true)

      if continue? 'yes', 'no'
        continue!(@workflow)
      end
    rescue GuardError, HaltSignal
      # no-op (execution already blocked)
    end

    def summarize(context, nested = false)
      @ui.out {
        @ui.newline
        @ui.say heading(context)

        @ui.newline
        @ui.say context.prologue

        if nested
          # @ui.err ???
          @ui.say 'Tasks:'
          @ui.newline

          context.tasks.each_with_index do |task, index|
            preview(task, index)
          end

          @ui.newline
        end
      }
    end

    def preview(task, index)
      @ui.out {
        @ui.indent {
          @ui.say item(task, index, :ol)
          task.tasks.each_with_index do |t, i|
            preview(t, i)
          end
        }
      }
    end

    # ---

    def continue!(context)
      context.tasks.each do |task|
        summarize(task)

        if continue? 'yes', 'no', 'skip'
          continue!(task)
        end
      end
    end

    def continue?(*options)
      choice = nil

      @ui.err {
        choice = @ui.choose(*options) do |menu|
          menu.header = 'Continue'
          menu.flow   = :inline
          menu.index  = :none
        end
      }

      case choice
      when 'yes'
        true
      when 'no'
        raise HaltSignal
      # when 'show'
      when 'skip'
        false
      end
    end

    def heading(context)
      prefix  = '#' * (context.depth + 1)
      styles  = [:bold]
      styles << :underline if context.depth == 0

      "#{prefix} #{stylize(context.heading, *styles)}"
    end

    def item(context, index, mode)
      case mode
      when :ol
        prefix = "#{index + 1}."
      when :ul
        prefix = '-'
      else
        NotImplementedError
      end

      styles  = [:bold]
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
