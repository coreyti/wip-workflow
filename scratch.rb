module Workflow
  class Engine # Manager
    # instantiated with Workflow::Definition;
    # creates Workflow::Execution (registers for events)
    # creates Workflow::WorkList(s)
    # creates Workflow::Handler
  end

  class Instance # Execution, Case, ProcessInstance
    # The representation of a single enactment of a process.
    #
    # maintains state; allows auditing (via Workflow::Events ???)
    # ??? inherits properties of Workflow::Definition
  end

  class WorkPool # ???
    # all WorkItems within a Defintion (ungrouped)
  end

  class WorkList # Queue, WorkQueue
    # A list of work items associated with a given workflow participant
    # (or in some cases with a group of workflow participants who may share
    # a common worklist). The worklist forms part of the interface between
    # a workflow engine and the worklist handler.
    #
    # constructed from the "body" of Workflow::ActivitySet
  end

  class WorkItem # Task, Work, Element
    # The representation of the work to be processed (by a workflow
    # participant) in the context of an activity within a process instance.
    #
    # constructed from the "body" of Workflow::Activity
  end

  class Handler # Manager, Performer
    # A software component that manages the interaction between the user
    # (or group of users) and the worklist maintained by a workflow engine.
    # It enables work items to be passed from the workflow management system
    # to users and notifications of completion or other work status conditions
    # to be passed between the user and the workflow management system.
    #
    # Given a WorkList, passes WorkItem(s) in sequence to appropriate Agents (?)
  end

  class Monitor
    # auditing ???
  end

  # ---

  class Builder
    # creates/modifies Workflow::Definition
  end

  class Definition # Process
    # heading, prologue, epilogue, summary
    # N x Workflow::ActivitySet
  end

  class ActivitySet # ActivityList, ActivityQueue
    # A set of activities within a process definition which share one or more
    # common properties which cause the workflow management software to take
    # certain actions with respect to the block in total.
    # For example a group of activities may be classified as a block
    # if they require a common resource allocation policy.
    #
    # ??? heading, prologue, epilogue, summary
    # N x Workflow::Activity
    #
    # state "complete" IFF all Activities are complete
  end

  class Activity # Step, Node, Task, Operation, Instruction
    # A description of a piece of work that forms one logical step within
    # a process.
    #
    # heading, prologue, epilogue, summary
  end

  # ---

  class Agent # Participant, Actor, Performer
    # A resource which performs the work represented by a workflow
    # activity instance. This work is normally manifested as one or more
    # work items assigned to the workflow participant via the worklist.
    #
    # e.g., Display, Prompt, Shell, Operator (? human)
    # acts on Workflow::WorkItem
  end

  # ---

  class Data # ??? CaseData, RelevantData

  end

  class Event
    # trigger, action
  end

  class State # ??? ControlData, StateData
    #
  end

  class PreCondition # Check
    # these could both be Check, with positional importance
  end

  class PostCondition # Check

  end

  class Route

  end

  class Iteration

  end

  class Transition
    # with condition(s)
  end
end
