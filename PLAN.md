# Specs Runner Plan

## Goal

Build a language-agnostic framework for:

- writing specifications in Markdown
- building a specs runner with deterministic behavior
- using that runner to run specs, generate scaffolding, and inspect status

The first reference implementation will be in Elixir.

## Repository Scope

This repository provides:

- a canonical AI skill for spec authoring
- specs for building a specs runner under `specs/`
- an AI skill for using a specs runner
- runner implementations per ecosystem

## Current Decisions

### Specification Format

- specs are Markdown files
- `## Scenario: ...` is the required scenario heading format
- `Assertions:` contains the bullet list of testable behaviors
- the format stays simple and deterministic
- `blueprint.md` is being deprecated and its behavioral contract should move into specs under `specs/`

### Runner Capabilities

Every specs runner should provide these core capabilities:

- run and report specs
- generate test implementation scaffolding from specs
- return specs filtered by status

If possible, runner commands should use a `specs` prefix.

Examples:

- `mix specs.run`
- `mix specs.gen.tests specs/my_spec.md`
- `npm run specs.run`

### AI Responsibilities

- `spec-authoring` is the canonical guide for writing Markdown specs
- `spec-runner-usage` is the guide for interacting with a specs runner
- runner execution stays deterministic and does not depend on AI

## Phases

### Phase 1: Foundation

- [x] Initialize the repository structure
- [x] Write the blueprint
- [x] Write the AI skills
- [ ] Remove `blueprint.md` after its remaining guidance has been moved into specs

### Phase 2: Specs For The Runner

- [x] Write specs for running and reporting specs
- [ ] Write specs for spec parsing and validation failures
- [ ] Write specs for generating test scaffolding
- [ ] Write specs for filtering specs by status

### Phase 3: Elixir Runner

- [ ] Implement Elixir command discovery and entry points
- [ ] Implement `mix specs.run`
- [ ] Implement `mix specs.gen.tests`
- [ ] Implement status filtering

### Phase 4: Validation

- [ ] Run the Elixir runner against this repository's own specs
- [ ] Add a minimal example flow

## Near-Term Tasks

### Task 1: Foundation

- [x] Root repository structure
- [x] Elixir runner scaffold under `runners/elixir/`
- [x] Initial CI for Elixir
- [x] Core docs and skills

### Task 2: Spec Authoring Skill

- [x] Canonical Markdown format
- [x] Example spec
- [x] Review checklist

### Task 3: Spec Runner Usage Skill

- [x] Run specs guidance
- [x] Scaffolding guidance
- [x] Status filtering guidance
- [x] Command discovery guidance

### Task 4: Runner Specs

- [ ] Add specs under `specs/` for:
- [x] running and reporting specs
- [ ] spec parsing and validation failures
- [ ] generating test scaffolding
- [ ] filtering specs by status

### Task 4.1: Blueprint Deprecation

- [ ] Move remaining behavioral guidance from `blueprint.md` into specs under `specs/`
- [ ] Remove `blueprint.md`

### Task 5: Elixir Runner Commands

- [ ] Implement `mix specs.run`
- [ ] Implement `mix specs.gen.tests`
- [ ] Implement status filtering support

## CI

Initial CI runs only the Elixir runner.

- [x] `mix test` in `runners/elixir/`
- [ ] run the specs runner in CI once the commands exist

Additional stacks can be added as separate CI jobs later.
