require 'spec_helper'

module WIP::Workflow
  describe Doc do
    describe '#run' do
      let(:command) { definition.new(ui) }

      context 'given ... (file)' do
        let(:definition) {
          define_command do
            include WIP::Workflow::Specification

            workflow file: 'workflows/example.md'

            def execute(arguments, options)
              workflow.run(arguments, options)
            end
          end
        }

        it 'executes' do
          expect { command.run }.to show %(
            ...
          )
        end
      end

      context 'given ... (text)' do
        let(:specification) { File.read(asset('workflows/markdown.md')) }
        let(:definition) {
          define_command do
            include WIP::Workflow::Specification

            workflow text: %(
              # Heading

              Some prologue, with:

              - some
              - list
            )

            def execute(arguments, options)
              workflow.run(arguments, options)
            end
          end
        }

        it 'executes' do
          expect { command.run }.to show %(
            ...
          )
        end
      end
    end
  end
end
