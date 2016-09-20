module WIP
  module Workflow
    class Error      < WIP::Runner::Error; end
    class GuardError < Error; end
    class HaltSignal < Error; end
  end
end

require "wip/workflow/version"
require "wip/workflow/builder"
require "wip/workflow/definition"


# require "wip/workflow/dsl"
# require "wip/workflow/format"
# require "wip/workflow/formatted_ui"
# require "wip/workflow/parser"
# require "wip/workflow/runner"
# require "wip/workflow/specification"
# require "wip/workflow/theme"
