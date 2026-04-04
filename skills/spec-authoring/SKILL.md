---
name: spec-authoring
description: The canonical guide for writing Markdown specifications that can be tested deterministically with an spec runner.
---

# Spec Authoring

This skill is the authoritative source of truth for writing testable system requirements, features, behaviors or any kind of software specifications in Markdown, following a format that can be parsed and verified deterministically by an spec runner tailored to this format.

The strategy is:

- write specifications in plain Markdown
- keep the format small and deterministic
- describe behavior, not test implementation
- let the runner parse specs deterministically
- let later workflow steps generate and implement tests

We are not trying to recreate executable step systems such as Gherkin, Cucumber, or Gauge.

## Purpose

Use this skill when the user wants to:

- write a new specification in Markdown
- refine an existing Markdown specification
- improve scenario and assertion wording
- review whether a spec follows the format specified in this document

This skill defines how Markdown specifications should be written before any runner-specific parsing or test scaffolding happens.

## Scope

This skill covers only Markdown specification writing.

This skill does not cover:

- runner installation
- scaffold generation
- test implementation
- native test framework usage

## Default Location

By default, specifications live under:

```text
specs/
```

Example:

```text
specs/auth/login.md
```

## Format specification

Each specification file must follow these rules:

- exactly one H1 heading for the file title
- zero or more H2 headings using the exact prefix `Scenario:`
- zero or more paragraphs of prose anywhere they help explain intent
- an `Assertions:` section under each scenario when explicit testable behaviors are listed
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

## Semantics

### H1 Title

The H1 heading names the overall feature, capability, or concern described by the file.

Use a concise, human-readable title.

### Scenario Headings

Each scenario heading must be an H2 heading with the exact `Scenario:` prefix.

Good examples:

- `## Scenario: Successful login`
- `## Scenario: Failed login with wrong password`

Bad examples:

- `## Successful login`
- `## Scenarios`
- `### Scenario: Successful login`

### Assertions Section

`Assertions:` introduces the list of expected testable behaviors for the scenario.

Each bullet under `Assertions:` should represent one concrete behavior that can later map to one generated test case.

## Writing Rules

### Scenario Naming

Scenario names should:

- describe one coherent situation
- be short enough to reuse later in generated test structure
- stay stable over time when possible
- be unique within the file

### Assertion Writing

Assertion bullets should:

- describe observable outcomes
- be concrete and specific
- avoid implementation details when possible
- be unique within the scenario
- represent one independently testable behavior

### Prose Usage

Normal prose is allowed and encouraged when it improves understanding.

Good uses of prose:

- describe context
- explain constraints
- clarify intent
- note examples or domain expectations

Prose remains documentation.
It is not executable and should not be written as if it were code.

## Good And Bad Assertions

Good assertion examples:

- `Creates a session with valid credentials`
- `Rejects invalid password`
- `Returns a validation error for an empty email`
- `Does not create a second subscription for the same user`

Weak assertion examples:

- `Works correctly`
- `Handles edge cases`
- `Does the right thing`
- `Logs in the user and updates analytics and sends email`

If an assertion combines multiple outcomes that should be validated independently, split it.

## Recommended Writing Style

- prefer one feature or cohesive capability per file
- prefer one scenario per distinct situation
- prefer one behavior per assertion bullet
- keep wording outcome-focused
- keep titles and assertions easy to reuse verbatim later
- avoid unnecessary jargon when simple wording is enough

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

Use this checklist when reviewing a spec:

- the file has exactly one H1 heading
- every scenario heading uses the exact `Scenario:` prefix
- scenario headings are H2 headings
- every assertion bullet is specific and testable
- scenario names are unique within the file
- assertion text is unique within each scenario
- prose improves clarity without becoming executable syntax
- wording avoids implementation details unless they are essential to the behavior

## What To Avoid

- adding `Given`, `When`, `Then` semantics or equivalent executable sections
- writing specs as if they were step definitions
- embedding tables or parameter syntax intended for runtime execution
- using broad scenario titles with vague assertions
- putting implementation details into every assertion
- adding setup or action sections that the runner must execute
- inventing alternative section names for the canonical structure when avoidable
