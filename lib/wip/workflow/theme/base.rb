module WIP::Workflow
  module Theme
    module Base
      @@active = []

      def +(other)
        @@active << self if @@active.empty?
        @@active << other
        self
      end

      def apply(content)
        @@active.inject(content) do |result, theme|
          theme.stylize(result)
        end
      end
    end
  end
end
