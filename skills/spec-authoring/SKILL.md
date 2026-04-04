---
name: spec-authoring
description: Canonical guide for writing Markdown specifications that follow the specs-runner methodology.
---

# Spec Authoring

This skill is the canonical source of truth for writing Markdown specifications in the `specs-runner` methodology.

## Purpose

Use this skill when the user wants to:

- write a new specification in Markdown
- refine an existing Markdown specification
- improve scenario and assertion wording
- review whether a spec follows this methodology

## Principles

- Write specifications in plain Markdown
- Keep the format small and deterministic
- Describe behavior, not test implementation
- Let the runner parse the spec deterministically
- Do not recreate Gherkin, Cucumber, Gauge, or similar step systems

## Scope

This skill covers only Markdown specification writing.

It does not cover:

- runner installation
- test scaffolding generation
- test implementation

## Default Location

Specifications live under:

```text
specs/
```

Example:

```text
specs/auth/login.md
```

## Format Specification

Each specification file must use:

- exactly one H1 heading for the file title
- zero or more H2 headings using the exact prefix `Scenario:`
- optional prose where it helps explain intent
- an `Assertions:` section under each scenario when testable behaviors are listed
- bullet items directly under `Assertions:` for each testable behavior

## Canonical Shape

```md
# Feature or Capability Title

Optional introductory prose.

## Scenario: Scenario name

Optional prose describing context, constraints, or examples.

Assertions:

- First testable behavior
- Second testable behavior
```

## Writing Rules

### Scenario Names

Scenario names should:

- describe one coherent situation
- be short and stable
- be unique within the file

### Assertion Bullets

Assertion bullets should:

- describe observable outcomes
- be concrete and specific
- avoid implementation details when possible
- be unique within the scenario
- represent one independently testable behavior

If an assertion combines multiple outcomes that should be validated independently, split it.

### Prose

Use normal prose to describe:

- context
- constraints
- examples
- intent

Prose is documentation only. It is not executable.

## Good And Bad Assertions

Good examples:

- `Creates a session with valid credentials`
- `Rejects invalid password`
- `Returns a validation error for an empty email`

Weak examples:

- `Works correctly`
- `Handles edge cases`
- `Does the right thing`

## Example Spec

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

## Review Checklist

- the file has exactly one H1 heading
- every scenario heading uses the exact `Scenario:` prefix
- scenario headings are H2 headings
- every assertion bullet is specific and testable
- scenario names are unique within the file
- assertion text is unique within each scenario
- prose improves clarity without becoming executable syntax

## What To Avoid

- adding `Given`, `When`, `Then` semantics or equivalent executable sections
- writing specs as step definitions
- embedding tables or parameter syntax intended for runtime execution
- using vague scenario titles and vague assertions
- adding setup or action sections that the runner must execute
