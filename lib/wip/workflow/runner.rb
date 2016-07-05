module WIP::Workflow
  class Runner
    def initialize(ui, workflow, formatter)
      @ui        = ui
      @workflow  = workflow
      @formatter = formatter
    end

    def run(arguments, options)
      @arguments = arguments
      @options   = options

      @ui.out { execute }
    end

    private

    def execute
      summary @workflow, true

      case continue? 'yes', 'no'
      when :yes
        continue! @workflow
      end
    rescue GuardError, HaltSignal
      # no-op (execution already blocked)
    end

    def raw(content)
      @ui.say content
    end

    def say(content)
      @ui.say @formatter.apply(content)
    end

    def process(context)
      case continue? 'yes', 'no', 'show', 'skip'
      when :yes
        continue!(context)
      when :show
        show(context)
        process(context)
      end
    end

    # ---

    def summary(context, nested = false)
      heading  context
      prologue context

      if nested
        @ui.say 'Tasks:'
        @ui.newline

        preview context
        @ui.newline
      end
    end

    def heading(context)
      say context.heading
    end

    def prologue(context)
      context.prologue.each do |part|
        say part
      end
    end

    def item(content, index, mode)
      case mode
      when :ol
        prefix = "#{index + 1}."
      when :ul
        prefix = '-'
      else
        NotImplementedError
      end

      styles = [:bold]
      "#{prefix} #{stylize(content, *styles)}"
    end

    def preview(context)
      context.tasks.each_with_index do |task, index|
        raw item(task.heading.to_s, index, :ol)
        @ui.indent { preview(task) }
      end
    end

    def show(context)
      unless context.parts.empty?
        context.parts.each do |part|
          if part.heading
            summary(part)
          end
          show(part)
        end
      else
        say context
      end
    end

    # ---

    def continue!(context)
      context.tasks.each do |task|
        # page!
        summary task
        process task
      end
    end

    def continue?(*options)
      choice = nil

      @ui.err {
        @ui.newline
        choice = @ui.choose(*options) do |menu|
          menu.header = 'Continue'
          menu.flow   = :inline
          menu.index  = :none
        end
        @ui.newline
        @ui.newline
      }

      case choice
      when 'yes'
        :yes
      when 'no'
        raise HaltSignal
      when 'show'
        :show
      when 'skip'
        :skip
      end
    end

    def page!
      if paged?
        @ui.out {
          @ui.say "\e[H\e[2J"
        }
      end
    end

    def paged?
      @options.paged
    end

    def stylize(text, *style)
      stylize? ? @ui.out { @ui.color(text, *style) } : text
    end

    def stylize?
      true
    end
  end
end
