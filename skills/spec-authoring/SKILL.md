---
name: spec-authoring
description: Write Markdown specifications and matching native tests that follow the specs-runner contract.
---

# Spec Authoring

## Purpose

Use this skill when the user wants to:

- write product or behavior specifications in Markdown
- map those specifications to native tests
- review or refine spec and test alignment
- improve scenario and assertion wording

This skill is based on the contract in `blueprint.md`.

## Use This Skill When

Use this skill when the user wants a workflow where:

- specifications live in Markdown
- tests stay native to the project stack
- coverage is tracked by deterministic name and path matching
- missing implementation and orphan tests are reported clearly

Do not use this skill for teams that explicitly want executable Given/When/Then steps or data-driven step bindings.

## First Principles

- Do not invent a new DSL
- Do not reimplement Gherkin, Cucumber, Gauge, or similar step-based systems
- Do not pass data tables or strings from specs into test functions
- Do not use AI at runtime to interpret specification prose
- Keep the spec readable and the test native to the stack
- Follow exact naming for deterministic matching

## Expected Project Shape

By default, assume this layout:

```text
specs/
test/specs/
```

Example:

```text
specs/auth/login.md
test/specs/auth/login_test.exs
```

The path is mirrored between specs and tests. Use ecosystem-specific file suffixes.

## Required Spec Rules

- one H1 title per file
- scenarios must be H2 headings with the exact prefix `Scenario:`
- each scenario may include free-form prose
- assertions must appear under `Assertions:`
- assertion bullets must be concrete, testable behaviors
- scenario names must be unique within the file
- assertion text must be unique within the scenario

## Recommended Writing Style

- keep scenario names short and stable
- make assertions observable and outcome-focused
- avoid implementation details in spec text
- avoid overly broad assertions that bundle many outcomes together
- avoid splitting one tiny behavior into many trivial assertions
- prefer one behavior per assertion bullet
- prefer one feature or cohesive capability per spec file
- keep prose helpful but non-essential to matching

## Writing Heuristics

Good assertion examples:

- `Creates a session with valid credentials`
- `Rejects invalid password`
- `Returns a validation error for an empty email`

Weak assertion examples:

- `Works correctly`
- `Handles edge cases`
- `Logs in the user and updates analytics and sends email`

If an assertion combines multiple independently testable outcomes, split it.

## Spec Example

```md
# User Login

Users can authenticate with email and password.

## Scenario: Successful login

The user provides valid credentials.

Assertions:

- Creates a session with valid credentials
- Returns a session token

## Scenario: Failed login

The user provides an invalid password.

Assertions:

- Rejects invalid password
- Increments failed attempt counter
```

## Matching Rules

The native tests must match the spec by:

- mirrored file path
- exact scenario name
- exact assertion text

Do not use fuzzy matching.

Prefer exact title reuse by copying scenario and assertion text from the spec into test names.

## Elixir Example

Spec file:

```text
specs/auth/login.md
```

Test file:

```text
test/specs/auth/login_test.exs
```

Test code:

```elixir
defmodule MyApp.Auth.LoginTest do
  use ExUnit.Case, async: true

  describe "Successful login" do
    test "Creates a session with valid credentials" do
      # arrange, act, assert in native ExUnit style
    end

    test "Returns a session token" do
      # ...
    end
  end

  describe "Failed login" do
    test "Rejects invalid password" do
      # ...
    end

    test "Increments failed attempt counter" do
      # ...
    end
  end
end
```

## TypeScript Example

```ts
describe("Successful login", () => {
  test("Creates a session with valid credentials", () => {
    // arrange, act, assert in native test style
  })

  test("Returns a session token", () => {
    // ...
  })
})
```

If the target runner does not support `describe`, preserve the same logical mapping using the ecosystem's normal naming convention.

## Arrange, Act, Assert

Keep arrange, act, and assert in test code.

Do not try to map Markdown sections directly to setup hooks, actions, or assertions.

The spec describes behavior.
The test owns setup and execution details.

If the user wants to document context, write it as normal prose above `Assertions:`.

## Validation Checklist

- every spec file has a matching test file when implementation exists
- every `Scenario:` has a matching grouped test construct or equivalent
- every assertion bullet has a matching test case name
- there are no unexpected orphan test items in the spec-mapped test directory

When reviewing mismatches, prefer renaming for consistency over adding aliasing rules.

## What To Avoid

- adding `Given`, `When`, `Then` semantics or equivalent executable sections
- deriving test names semantically from prose
- introducing hidden naming normalization rules
- using broad scenario titles with vague assertions
- putting implementation details into assertion names
- making the spec format depend on test framework internals
- adding setup or action sections that the runner must execute
