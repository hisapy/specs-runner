---
name: runner-setup
description: Detect the project stack and install, copy, or extend a specs-runner implementation while preserving the native test runner.
---

# Runner Setup

## Purpose

Use this skill when the user wants to:

- set up a specs-runner workflow in an existing project
- copy or extend a runner implementation
- detect the project's stack and choose the right runner strategy
- add native integration such as `mix spec`

This skill is based on the contract in `blueprint.md`.

## First Principles

- Preserve the project's native test runner
- Prefer copying an existing runner over generating one from scratch
- Keep the implementation small and deterministic
- Do not introduce stack-specific concepts into the spec format
- Do not replace the user's existing test commands

## Expected Outcomes

After using this skill, the project should have:

- a `specs/` directory or agreed equivalent
- a spec-mapped test directory such as `test/specs/`
- a runner implementation for the detected stack
- unchanged native test commands such as `mix test` or `npm test`
- a new command or workflow for spec reporting when supported

## Setup Workflow

### 1. Detect The Stack

Inspect repository files first.

Examples:

- `mix.exs` and ExUnit usage -> Elixir
- `package.json` with Jest or Vitest -> TypeScript or JavaScript
- `pytest` config -> Python
- `rspec` config -> Ruby

If ambiguous, ask one short question.

### 2. Detect Whether A Compatible Workflow Already Exists

Look for:

- `specs/`
- a spec-mapped test directory such as `test/specs/`
- native integration such as `mix spec`
- prior project documentation that already defines the workflow

If the project already follows the blueprint, extend it instead of replacing it.

### 3. Choose The Installation Strategy

Prefer these approaches in order:

1. extend the project's existing compatible runner
2. copy an existing runner implementation from this repository
3. implement a new runner following `blueprint.md`

Current available runner:

- Elixir runner from `runners/elixir/`

### 4. Copy Or Implement Minimally

When copying or implementing a runner:

- preserve the project's native runner conventions
- adapt paths only where needed
- avoid unnecessary dependencies
- keep code readable and easy to review
- keep file mapping deterministic

### 5. Create The Base Project Structure

Unless the project already has an equivalent layout, create:

```text
specs/
test/specs/
```

Use stack-appropriate file names under the test directory.

### 6. Preserve Native Test Commands

Examples:

- Elixir tests must still run with `mix test`
- Jest tests must still run with `npm test`

The spec runner is additional workflow, not a replacement.

### 7. Verify The Installation

Verify that:

- the native test runner still works
- the runner implementation resolves the expected spec and test paths
- the copied or generated command integrates cleanly with the project

## When To Ask The User

Ask a short question only when needed, for example:

- the repository has multiple plausible test stacks
- the project already has a conflicting specs workflow
- the default `specs/` and `test/specs/` layout clearly does not fit the project
- the user wants a stack for which no runner implementation exists yet

## What To Avoid

- rewriting a compatible existing workflow just for stylistic consistency
- replacing the native test runner with a custom runtime
- generating large framework layers when a small adapter is enough
- introducing executable spec syntax
- coupling the runner too tightly to one project's internal app code

## This Repository

When working in this repository:

- treat `blueprint.md` as the contract
- treat `PLAN.md` as the roadmap
- prefer extending `runners/elixir/` for the initial implementation
- keep future runner implementations under `runners/`
