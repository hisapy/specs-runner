# Specs Runner Implementation Plan

## Goal

Build a language-agnostic workflow for writing specifications in Markdown and mapping them to native test runners, starting with an Elixir reference implementation.

The repository will contain:

- a language-agnostic blueprint for the workflow
- AI-facing instructions for authoring specs and wiring tests
- runner implementations per ecosystem
- dogfooding specs used to validate the approach itself

## Scope For The First Iteration

The first iteration focuses on the Elixir runner only.

The initial repository structure should support future runners without changing the top-level layout.

## Guiding Principles

- Keep the runtime deterministic; do not use AI during runner execution
- Use Markdown for specs, with minimal required structure
- Map specs to native tests instead of inventing a step-definition DSL
- Keep setup and review incremental with small, isolated tasks
- Dogfood the methodology inside this repository
- Prefer text output first; add machine-readable output later if needed

## Current Decisions

### Repository Structure

- Root repository name stays `specs-runner`
- The root is language-agnostic
- Runner implementations live under `runners/`
- The first runner is an Elixir Mix project under `runners/elixir/`
- Shared repository specs live under `specs/`

### Specification Format

- A spec is a Markdown file
- The file maps to a test file by mirrored path convention
- `## Scenario: ...` is the required scenario heading format
- `Assertions:` contains the bullet list that maps to tests
- No data-passing syntax is introduced in specs

### Mapping Strategy

- Spec file maps to test file
- Scenario heading maps to a grouped test construct when supported, such as `describe`
- Assertion bullet maps to a test case name
- Runners without grouped blocks may use a naming convention instead

### Reporting

- Version 1 uses CLI text output
- Statuses include pass, fail, pending, and orphan
- JSON can be added later for CI and tooling integration

## Implementation Phases

### Phase 1: Foundation

- [x] Initialize the repository structure
- [ ] Write the language-agnostic blueprint
- [ ] Write the AI-facing `SKILL.md`

### Phase 2: Dogfooding Specifications

- [ ] Write parsing specs
- [ ] Write matching specs
- [ ] Write reporting specs

### Phase 3: Elixir Runner

- [ ] Implement the Markdown spec parser
- [ ] Implement ExUnit test discovery
- [ ] Implement the matcher
- [ ] Implement the reporter
- [ ] Implement the `mix spec` task

### Phase 4: Validation And Examples

- [ ] Run the runner against the repository's own specs
- [ ] Add a minimal example project layout and usage documentation

## Small Reviewable Tasks

### Task 1: Initialize The Repository

Create the initial language-agnostic repository structure and scaffold the Elixir runner project.

Deliverables:

- [x] `runners/elixir/` as a Mix project
- [x] `specs/` directory at the repo root
- [x] `.github/workflows/ci.yml` with an Elixir CI job running `mix test`
- [x] placeholder top-level documents to be filled in later

Review focus:

- Does the repository layout support multiple future runners?
- Is the Elixir runner cleanly isolated?
- Is CI targeting the correct working directory?

### Task 2: Write `blueprint.md`

Document the language-agnostic contract for spec parsing, test discovery, matching, and reporting.

Review focus:

- Is the workflow precise enough for both humans and LLMs?
- Does it avoid introducing DSL complexity?

### Task 3: Write `SKILL.md`

Document how agents should write specs, write tests, and install or copy runners into user projects.

Review focus:

- Would an agent follow the intended conventions consistently?
- Are examples concrete and minimal?

### Task 4: Write Parsing Specs

Create Markdown specs that describe how the parser should interpret valid and invalid spec files.

Review focus:

- Are scenario and assertion rules unambiguous?
- Are malformed cases covered?

### Task 5: Write Matching Specs

Create Markdown specs for file pairing, scenario matching, assertion matching, and orphan detection.

Review focus:

- Are all matching outcomes accounted for?
- Are pending and orphan states clearly separated?

### Task 6: Write Reporting Specs

Create Markdown specs for CLI output structure and summary behavior.

Review focus:

- Is the report readable by humans and AI tools?
- Are summary counts and error cases clear?

### Task 7: Implement The Elixir Spec Parser

Parse Markdown files into an internal representation of file title, scenarios, and assertions.

Review focus:

- Does the parser accept only the intended structure?
- Are failures explicit and actionable?

### Task 8: Implement ExUnit Test Discovery

Parse ExUnit files and extract grouped blocks and test names for matching.

Review focus:

- Is discovery robust without executing tests?
- Does it handle common ExUnit structures?

### Task 9: Implement The Matcher

Join spec data and discovered test data to compute pass, fail, pending, and orphan states.

Review focus:

- Is the matching deterministic?
- Are mismatches reported precisely?

### Task 10: Implement The Reporter

Render a CLI report from the computed status model.

Review focus:

- Is the output concise and easy to scan?
- Are nested results readable?

### Task 11: Implement `mix spec`

Create the integration entrypoint that loads specs, discovers tests, runs matching, and prints the report.

Review focus:

- Does the task feel native to Elixir workflows?
- Can it run independently of normal `mix test` usage?

### Task 12: Dogfood The Runner

Run the Elixir runner against this repository's own specs and tests, then fix gaps.

Review focus:

- Does the methodology hold up in practice?
- Are there hidden assumptions or missing rules?

### Task 13: Add Examples

Add a minimal sample spec and mapped test to make onboarding concrete.

Review focus:

- Can a new contributor understand the workflow quickly?
- Is the example small but representative?

## CI Strategy

### Initial CI

The repository starts with a single Elixir CI job.

The job should:

- check out the repository
- set up Erlang and Elixir
- run `mix deps.get` in `runners/elixir/`
- run `mix test` in `runners/elixir/`

### Future CI Expansion

When additional runners are added, each gets an independent CI job.

Examples:

- Elixir runner job
- TypeScript runner job
- Python runner job

Each job should execute only the native commands for that runner and should not require unrelated toolchains.

## Success Criteria For Task 1

Task 1 is complete when:

- the repository has the agreed root structure
- the Elixir runner exists as an isolated Mix project
- CI is configured to run the Elixir runner tests
- the repository is ready for the next task, `blueprint.md`
