# specs-runner

`specs-runner` is a repository for a Markdown-based specification workflow that maps specs to native tests without introducing a step-definition DSL.

The repository contains:

- `blueprint.md`: the language-agnostic contract for the workflow
- `skills/`: focused AI-facing skills for authoring specs and setting up runners
- `runners/`: runner implementations per ecosystem
- `specs/`: dogfooding specs used to validate the approach
- `PLAN.md`: the implementation roadmap

## Skills

- `skills/spec-authoring/`
- `skills/runner-setup/`

## Current Runner

- `runners/elixir/`

## Status

The repository currently includes:

- the base blueprint
- focused skills for agents
- the initial Elixir runner scaffold

The next major step is writing dogfooding specs under `specs/` and implementing the Elixir runner against them.
