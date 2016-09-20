require 'spec_helper'

module WIP::Workflow
  describe DSL do
    describe '#run' do
      let(:command) { definition.new(ui) }

      context 'given ...' do
        let(:definition) {
          define_command do
            include WIP::Workflow::DSL

            workflow 'Heading' do |arguments, options|
              text %(
                Some prologue, with:

                - some
                - list
              %)

              task 'Task 1' do
                text 'Some prologue'

                step 'Step 1a' do
                  text "Some prologue, with: #{ arguments.context }"

                  # would allow options to adjust execution, or use meta-comment as below.
                  shell :bash, %(
                    #!/usr/bin/env bash
                    #:script

                    echo something
                  )

                  shell :bash, %(
                    #!/usr/bin/env bash
                    # ---
                    # gfm:
                    #   mode: script

                    echo something
                  )
                end
              end

              task 'Task 2' do
                text 'Some prologue'
                text 'Some epilogue'
              end
            end

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
