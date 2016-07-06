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
        process!(context)
      when :show
        show(context)
        process(context)
      end
    end

    def process!(context)
      evaluate!(context)
      # continue? 'yes', 'no'
      # continue!(context)
    end

    # ---

    class Prompt
      def initialize(ui, workflow, reference)
        @ui        = ui
        @workflow  = workflow
        @reference = reference
      end

      def evaluate!(env)
        @ui.err {
          @ui.indent do
            answer = @ui.ask("- #{desc}: ") do |q|
              # q.default  = (options[:default] || ENV[key])
              # if options[:required]
              #   # q.validate = Proc.new { |a| ! a.empty? }
              #   q.validate = /^.+$/
              # end
            end

            env[key] = answer unless answer.empty?
          end
        }
      end

      def key
        @reference.sub(/^#/, '').gsub(/-/, '_').upcase
      end

      def desc
        @reference
      end
    end

    class Shell
      def initialize(ui, workflow, codeblock)
        @ui        = ui
        @workflow  = workflow
        @codeblock = codeblock
      end

      def evaluate!(env)
        code = @codeblock.to_s

        env.each do |key, value|
          placeholder = "<#{key}>"
          code.sub!(/#{Regexp.escape(placeholder)}/, value)
        end

        script = code.gsub(/"/, '\"').gsub(/\$/, "\\$")
        script = %Q{bash -c "#{script}"}

        # @ui.say script

        # # TODO: move to a wip-runner object
        # Open3.popen2e(env, script) do |stdin, stdoe, wait_thread|
        #   status = wait_thread.value
        #   lines  = 0
        #
        #   @ui.err {
        #     @ui.indent do
        #       while line = stdoe.gets
        #         @ui.newline if lines == 0
        #         @ui.say("> #{line}")
        #         lines += 1
        #       end
        #     end
        #
        #     if lines > 0
        #       continue? 'yes', 'no'
        #     end
        #
        #     exit 1 unless status.success?
        #   }
        # end
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
    end

    def evaluate!(context, sum = false)
      case context.name
      when 'Codeblock'
        env = ENV

        context.prompts.each do |ref|
          prompt = Prompt.new(@ui, @workflow, ref)
          prompt.evaluate!(env) # with @env ?
        end

        shell = Shell.new(@ui, @workflow, context)
        shell.evaluate!(env)
      when 'Section'
        summary(context) if sum

        context.parts.each do |part|
          evaluate!(part, true)
        end
      else
        # ???
      end
    end

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
      # unless context.prompts.empty?
      #   say context.prompts.inspect
      # end

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
        summary(task)
        process(task)
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
