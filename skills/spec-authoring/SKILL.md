---
name: spec-authoring
description: Write Markdown specifications that can translate to testable assertions
---

# Spec Authoring

This skill is based on the contract in `blueprint.md`.

When writing specifications in Markdown, follow the format specified in the [blueprint](../../blueprint.md) and the guidelines in this skill.

## Purpose

Use this skill when the user wants to:

- write product or behavior specifications in Markdown
- improve scenario and assertion wording
- review Markdown spec quality and structure

## Use This Skill When

Use this skill when:

- specifications live in Markdown
- the runner will parse specs deterministically
- test scaffolding may be generated separately from the spec authoring step

Do not use this skill for teams that explicitly want executable Given/When/Then steps or data-driven step bindings.

## First Principles

- Do not invent a new DSL
- Do not reimplement Gherkin, Cucumber, Gauge, or similar step-based systems
- Do not pass data tables or strings from specs into test functions
- Keep the spec readable and deterministic to parse
- Do not make this skill responsible for generating or filling test files

## Expected Project Shape

By default, assume specifications live under:

```text
specs/
```

Example:

```text
specs/auth/login.md
```

The runner may later use mirrored paths to generate or discover test files, but this skill focuses only on authoring the Markdown spec.

## What This Skill Produces

This skill should produce:

- valid Markdown spec files
- clear scenario names
- concrete assertion bullets
- helpful prose that remains non-executable

This skill should not produce:

- test scaffolding
- test implementation
- runner installation changes
- stack-specific test code

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

## Context And Prose

Use normal prose to capture context, constraints, and examples.

- prose above `Assertions:` is allowed
- prose should help humans and future agents understand intent
- prose is documentation only unless the runner explicitly chooses to display it

Do not turn prose into executable sections.

## Review Checklist

- the file has exactly one H1 heading
- every scenario heading uses the exact `Scenario:` prefix
- every assertion bullet is specific and testable
- scenario names are unique within the file
- assertion text is unique within each scenario
- the wording avoids implementation details when possible

## What To Avoid

- adding `Given`, `When`, `Then` semantics or equivalent executable sections
- using broad scenario titles with vague assertions
- putting implementation details into assertion names
- adding setup or action sections that the runner must execute

## Related Skills

- Use `runner-setup` to install or extend the runner
- Use `test-scaffold-implementation` to fill generated test scaffolding
