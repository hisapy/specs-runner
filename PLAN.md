# Specs Runner Plan

## Goal

Build a language-agnostic framework for writing Markdown specifications and implementing deterministic specs-runners. The first reference implementation is Elixir.

## Scope

This repository provides:

- a canonical contract in `blueprint.md`
- canonical AI skills in `skills/`
- runner specs in `specs/`
- runner implementations in `runners/`

## Execution Model

- Specs are behavior-first and deterministic.
- Specs are matched to native tests through runner-specific conventions.
- Fixture-based tests are the canonical validation strategy for runner behavior.
- Running the runner against this repository's own specs is optional and treated as a smoke check only.

## Roadmap

### 1. Foundation

- [x] Establish repository structure and conventions
- [x] Define the canonical blueprint contract
- [x] Create initial AI skills (`spec-authoring`, `spec-runner-usage`)
- [x] Bootstrap Elixir runner project under `runners/elixir/`
- [x] Establish Elixir CI baseline with `mix ci`

### 2. Specs For Elixir Runner

- [ ] Complete and refine `specs/elixir/run_specs.md`
- [ ] Add scenarios for passed and failed test reporting
- [ ] Add scenarios for parsing and validation failures
- [ ] Keep this phase focused on `mix specs.run`
- [ ] Add separate spec files later for:
- [ ] generating tests from specs
- [ ] filtering by status

### 3. Elixir Runner Implementation: `mix specs.run`

- [ ] Implement `mix specs.run` from `specs/elixir/run_specs.md`
- [ ] Iterate spec <-> fixture tests until behavior is stable
- [ ] Ensure output reports spec/scenario/criteria status clearly
- [ ] Validate with `mix ci` in `runners/elixir/`

### 4. Publish Elixir Runner (GitHub -> Hex)

- [ ] Prepare package metadata and docs for install via GitHub
- [ ] Verify install/use from a separate sample repository
- [ ] Publish an initial GitHub-installable release
- [ ] Prepare Hex package metadata and release checklist
- [ ] Publish to Hex when release quality is acceptable

### 5. Elixir Mix Task For Generating Tests

- [ ] Write dedicated specs for `mix specs.gen.tests`
- [ ] Implement `mix specs.gen.tests`
- [ ] Validate generated scaffolding shape and naming via fixture tests

### 6. Add Filtering Options For Elixir Runner

- [ ] Write dedicated specs for status filtering
- [ ] Implement filtering options for runner output and scope
- [ ] Validate filtering behavior with fixture-based tests

## Release Policy

- Version targets are iterative and feedback-driven from real usage in another repository.
- `v1.0` criteria are intentionally deferred and will be decided from implementation feedback.
