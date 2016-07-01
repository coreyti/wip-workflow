require 'wip/workflow/definition/builder'
require 'wip/workflow/definition/component'
require 'wip/workflow/definition/task'
require 'wip/workflow/definition/workflow'

module WIP::Workflow
  module Definition # class ???
    class << self
      def define(command, *args, &block)
        command.send(:include, InstanceMethods)

        command.class_exec do
          options do |parser, config|
            config.overview = false
            config.paged    = false
            config.preview  = false

            parser.on('--paged', 'Pages workflow steps') do
              config.paged = true
            end

            # parser.on('--overview', 'Prints workflow overview') do
            #   config.no_validate = true
            #   config.overview    = true
            # end
            #
            # parser.on('--preview', 'Prints workflow preview') do
            #   config.preview = true
            # end
          end

          define_method(:builder) do
            @builder ||= Builder.new(self, *args, &block)
          end
        end
      end

      module InstanceMethods
        def runner #(arguments, options)
          @runner ||= begin
            workflow = builder.build #(arguments, options)
            Runner.new(@ui, workflow)
          end
        end
      end
    end
  end
end
