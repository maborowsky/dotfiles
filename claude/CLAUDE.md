# Personal global instructions

## Superpowers plugin

- Do not commit plan or spec files produced by the superpowers skills (e.g. files under `docs/superpowers/plans/` or `docs/superpowers/specs/`). Write them and leave them unstaged — I'll commit them myself if I want them in the repo. This overrides any "commit the spec/plan" step in the brainstorming, writing-plans, or related skills.

## Git branching

When creating a new branch, do not pass `origin/<branch>` as the starting point — `git checkout -b <name> origin/<x>` and `git branch <name> origin/<x>` both set the new branch's upstream to that remote ref, which makes later `git push`/`git status` misleading. Instead:

- Fetch first, then branch from the local ref: `git fetch origin && git checkout -b <name> master`.
- Or branch from `FETCH_HEAD` immediately after a fetch.
- Or pass `--no-track` to the `git branch`/`git checkout -b` invocation.
