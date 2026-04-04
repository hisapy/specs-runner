---
name: test-scaffold-implementation
description: Fill generated test scaffolding from specs-runner by implementing native tests for each generated scenario and assertion.
---

# Test Scaffold Implementation

## Purpose

Use this skill when the user wants to:

- fill generated test scaffolding created from Markdown specs
- implement native test code for generated scenarios and assertions
- turn placeholder tests into working test coverage

This skill assumes the runner or project already generated the test file structure.

## Use This Skill When

Use this skill after:

- a spec file already exists
- the runner has generated a scaffolded test file, or
- the project already contains placeholder tests that correspond to spec scenarios and assertions

Do not use this skill to write the Markdown spec itself.

## First Principles

- Keep the test code native to the project stack
- Reuse the generated structure instead of rewriting it
- Implement arrange, act, and assert in code, not in the Markdown spec
- Preserve generated names so deterministic matching still works
- Prefer minimal, clear test implementations

## Expected Inputs

This skill expects:

- a spec file under `specs/`
- a scaffolded test file produced by the runner or by prior project setup
- scenario groups and test names already present in the test file

## Expected Outputs

This skill should produce:

- implemented test bodies
- stack-appropriate setup and fixtures
- clear assertions in native test syntax

This skill should not:

- rename generated scenarios or test names without a strong reason
- change the spec format
- replace the native test runner

## Workflow

### 1. Read The Spec And The Scaffold Together

Review the Markdown spec and the generated test file.

Confirm that:

- each generated group corresponds to a scenario
- each generated test corresponds to an assertion
- naming still matches exactly

### 2. Preserve The Generated Structure

Keep the generated file layout and names unless the scaffold is clearly wrong.

Prefer changing test bodies over changing test names.

### 3. Implement Native Test Logic

For each generated test:

- arrange the required data and setup
- execute the behavior under test
- assert the expected outcome

Use the project's normal helpers, fixtures, factories, and conventions.

### 4. Run The Native Tests

Verify that the implemented tests run with the native command for the stack.

Examples:

- `mix test`
- `npm test`

### 5. Check Specs Status If The Runner Supports It

If the runner provides a status command, use it to confirm whether specs are now passing, pending, or failing.

## Elixir Example

Generated scaffold:

```elixir
defmodule MyApp.Auth.LoginTest do
  use ExUnit.Case, async: true

  describe "Successful login" do
    test "Creates a session with valid credentials" do
      flunk("Not implemented")
    end
  end
end
```

Implemented test:

```elixir
defmodule MyApp.Auth.LoginTest do
  use ExUnit.Case, async: true

  describe "Successful login" do
    test "Creates a session with valid credentials" do
      user = insert(:user, password: "secret123")

      assert {:ok, session} = Auth.login(user.email, "secret123")
      assert session.user_id == user.id
    end
  end
end
```

## What To Avoid

- renaming generated scenarios or tests casually
- replacing scaffolded tests with a different structure unless required
- leaking spec wording into helper names or implementation details unnecessarily
- introducing abstractions too early when a direct test is clearer

## Related Skills

- Use `spec-authoring` to create or refine the Markdown spec
- Use `runner-setup` to install or extend the runner
