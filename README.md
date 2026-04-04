# specs-runner

`specs-runner` is a repository for a Markdown-based specification workflow that maps specs to native tests without introducing a step-definition DSL.

The canonical source of truth for how to write Markdown specifications in this methodology is:

- `skills/spec-authoring/SKILL.md`

The repository contains:

- `blueprint.md`: the language-agnostic contract for the workflow
- `skills/`: focused AI-facing skills for authoring specs, setting up runners, and implementing generated test scaffolding
- `runners/`: runner implementations per ecosystem
- `specs/`: dogfooding specs used to validate the approach
- `PLAN.md`: the implementation roadmap

## Skills

- `skills/spec-authoring/`
- `skills/runner-setup/`
- `skills/test-scaffold-implementation/`

If you are defining or reviewing the Markdown methodology itself, start with `skills/spec-authoring/SKILL.md`.

## Current Runner

- `runners/elixir/`

## Status

The repository currently includes:

- the base blueprint
- focused skills for agents
- the initial Elixir runner scaffold

The intended workflow is:

1. author Markdown specs
2. generate test scaffolding from specs
3. implement the scaffolded tests

The next major step is writing dogfooding specs under `specs/` and implementing the Elixir runner against them.
