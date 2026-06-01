Michael Mux
`[M][i][c][h][a][e][l]'s declaritive multiple[x]ing for everything`


michaelmux:
    - any new todo or tab is a new unit of work
        - watchers?

- if there is no state then something is "done" --> can be cleaned up
    - michaelmux done uow --> closes state
        - maybe as best as possible --> can have a garbage (special uow)
        - this command is destructive, maybe -f removes state, no flag is just things like tabs, etc
            - tabs are only stateless w/ zmx


we start from "unit of work"
    - sometimes we do things quickly -- spawn a new tab
        - this is fine for some things but some turn into long units of work
        - either
            - should have a "watcher" for these and they get added and removed quickly OR
            - we should have a way to "adopt" into a unit of work (things will get messy, move in as needed)


Unit of Work:
    - id
    - mux_id (?)
        - can probably have a better name but like control+shift+num should jump to the current view/layout
    - project (?)
        - needs to find a root marker
        - hard for worktrees i guess but a git command will help
        - what is a project? a folder? A COLLECTION OF UNITS OF WORK 
            - lmao you can think of torchweb as just a collection of all of the units of work ever done on it
    - type (?) can i define this? -- work, jira, idk
    - browser:
        - tabs
        - windows
    - terminal
        - tabs
        - windows
    - other apps?
        - db viewer
    - layout
        - combination of aerospace view, terminal tab/window
    - created_at
    - deleted_at


view:



sketchybar OR mac bar:
    - List units of work by id
        - current UOW (focused tab? idk -- or 1 aerospace space per UOW)
        - expand the current one to show specific fields
        


- *If going with nested structure* -- where it lives/whats under it can define how it operates --> leaf nodes have different setups then tasks that group other tasks, also task type can define

GOALS:
- michaelmux tab bar where i can use shortcuts to switch to each one and it'll automatically know
good views into information


binds for new work, by size (?) and then we can grow it organically:
    - for example:
        - i just opened a new terminal tab to diable kitty bell sounds
        - then i opened the browser to search for why it wasnt working
        - then back to terminal --> dumped that into claude because i didn't want to deal even though it's annoying
    - The problem is that I work naturally and claude needs input and setup. automating small tasks would be really nice
    - AI HANDOFF: if I log all of this stuff (kinda hard to do) then i can have a "handoff to claude" feature where it says what i've done
        - for logging it'd be nice to use event driven architecture:
            - https://github.com/mitchellh/libxev


- I currently keep long-lived tabs (or long lived units of work!!!) around
    - for example, working on a ticket, put into pr -> get's reviewed
        - it's nice to keep the tab for specific context that's there like the claude session
        - would be better to have this as a session. also as the work progresses (moves from dev -> self review -> review) it'd be nice to have different layouts of how I want to work on it
    - DECLARITIVE SETUP!!!!!! I should be able to bring up and down a unit of work and have it be the same
        - do i need to track state/context for units of work? how can i do that
    

- Michael object?
    - jira_board: None | str
    - company: str
    - email: list[str]
    - profiles? like github


- is there anything to benefit from linking uow?
    - linking: jira ticket -> ticket -> ticket
    - nesting: (jira epics is one UOW then tickets)


- kitty notifications for claude stuff w/ keybind
    - it works okay but it's dismissed as I go to the tab even if i don't answer
    - michaelmux needs to have it's own notification system


MICHAELMUX: A Descent into Madness
- Don't worry I have therapy coming up on tuesday








kinda separate: maybe related: be your own manager: byom -> ai manager
