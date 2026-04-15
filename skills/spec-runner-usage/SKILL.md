---
name: spec-runner-usage
description: Run Markdown specifications as tests.
---

# Spec Runner Usage

This skills describes the features expected from a specs-runner and how to use it effectively. It assumes the project already has a specs-runner installed and focuses on how to interact with it.

## Purpose

Use this skill when the user wants to:

- verify acceptance criteria in Markdown specs
- generate test implementation scaffolding from specs
- return specs filtered by status

## Core Capabilities

Assume a specs-runner provides these core capabilities regardless of stack:

- run and report specs
- generate test implementation scaffolding from specs
- filter or return specs by status

The exact command names vary by ecosystem.

If possible, runner commands should use a `specs` prefix.

Examples:

- `mix specs.run`
- `mix specs.gen.tests specs/my_spec.md`
- `npm run specs.run`
- `npm run specs.gen.tests specs/my_spec.md`

## Command Discovery

Do not guess the exact command names.

First inspect the project's help output or command definitions.

Examples:

- Elixir: `mix help`
- npm scripts: inspect `package.json`
- other CLIs: run the tool's help command or inspect project documentation

Use the discovered command names from the project itself.

## Workflow

### 1. Detect The Stack

Inspect the repository to identify the stack and its native test runner.

Examples:

- Elixir with ExUnit
- TypeScript with Jest or Vitest

### 2. Discover The specs-runner Commands

Use the project's help command or equivalent discovery mechanism.

Examples:

- `mix help`
- `npm run`
- `<tool> --help`

Identify the commands for:

- running specs
- generating test scaffolding
- filtering specs by status

If the project does not expose these commands clearly, ask one short question, or if the user wants to install a specs-runner or build it based on specifications provided in this repository.

### 3. Run Specs

When the user wants current spec status:

- run the project's specs-run command
- inspect the output
- summarize pass, fail, pending, and orphan results when available

### 4. Generate Test Scaffolding

When the user wants test implementation scaffolding:

- run the project's scaffolding command
- pass a spec path when the command supports targeted generation
- inspect the generated files
- preserve generated names and structure

### 5. Return Specs Filtered By Status Or Scope

When the user wants only a subset of specs:

- use the project's status filtering option when available
- use the project's single-spec option when the user wants to run one Markdown spec file
- otherwise run the specs command and extract the requested statuses from the output

Examples of useful filters and scopes:

- pending specs
- failing specs
- orphaned specs or tests
- a single spec file such as `specs/my_spec.md`

## Output Expectations

Look for:

- passing specs
- failing specs
- pending or unimplemented specs
- orphan tests or orphan groups
- summary counts

## Native Runner Expectations

The specs-runner complements the native test runner.

The project's normal test commands should still work.

## What To Avoid

- guessing command names when the project already defines them
- inventing runner commands that do not exist in the project
- renaming generated scaffolding casually
- changing spec wording while only trying to run or inspect the runner
- replacing the native test runner with the specs-runner
