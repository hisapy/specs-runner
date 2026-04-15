---
name: spec-authoring
description: Canonical guidelines for writing Markdown specifications that can be run with specs-runner.
---

# Spec Authoring

This skill provides the canonical guidelines for writing Markdown specifications that can be run with `specs-runner`.

## Purpose

Use this skill when the user wants to:

- write a new spec that can be run with `specs-runner`
- refine an existing spec so it matches the runner contract
- improve acceptance criteria and scenario wording for runnable specs
- review whether a spec is clear, deterministic, and testable

## Principles

- Write specs in plain Markdown
- Describe behavior, not implementation
- Treat specs as high-level acceptance tests
- Use prose to guide implementation without turning it into executable syntax
- Keep the format deterministic for `specs-runner`
- Keep prose non-executable

## Scope

This skill covers Markdown spec writing only.

It does not cover:

- runner installation
- test scaffolding generation
- test implementation

## Default Location

Specs live under:

```text
specs/
```

Prefer underscore-style file names when possible.

Example:

```text
specs/auth/user_login.md
```

## Format

Each spec file must use:

- exactly one H1 heading for the file title
- exactly one H2 heading with the text `Acceptance Criteria`
- inside `Acceptance Criteria`, zero or more H3 headings using the exact prefix `Scenario:`
- any H2 heading other than `Acceptance Criteria` is documentation only
- any H3 heading inside `Acceptance Criteria` that does not start with `Scenario:` is documentation only
- optional prose where it improves clarity
- bullet items directly under `Acceptance Criteria` or under a `Scenario:` subsection for each testable behavior

## Canonical Shape

```md
# Feature or Capability Title

Optional introductory prose.

## Acceptance Criteria

### Scenario: Successful outcome

Optional prose describing context, constraints, or examples.

- First testable behavior
- Second testable behavior
```

## Writing Rules

### Scenario Names

Scenario names should:

- describe one coherent situation
- be short and stable
- be unique within the file

### Acceptance Criteria Bullets

Acceptance criteria bullets should:

- be concise
- describe observable outcomes
- be concrete and specific
- be phrased so a runner or test can verify them directly
- avoid implementation details when possible
- be unique within the scenario
- represent one independently testable behavior

If an acceptance criterion combines multiple outcomes that should be validated independently, split it.

If a statement explains rules, naming conventions, mapping details, or implementation guidance rather than an observable outcome, put it in prose instead of `Acceptance Criteria`.

### Prose

Use normal prose to describe:

- context
- constraints
- examples
- intent

Prose should give enough guidance to help implement the requirement or feature in an SDD workflow, while staying non-executable.

Additional H2 headings are allowed for documentation, but only `## Acceptance Criteria` defines the executable section of the spec.

Prose is documentation only. It is not executable.

## Examples

### User Login Spec example

```md
# User Login

Users can authenticate with email and password.

## Acceptance Criteria

### Scenario: Successful login

The user provides valid credentials.

- Creates a session with valid credentials
- Returns a session token

### Scenario: Failed login

The user provides an invalid password.

- Rejects invalid password
- Increments failed attempt counter
```

## Subscription Checkout Spec example

```md
# Subscription Checkout

Customers can start and complete subscription checkout through a payment provider.

## Acceptance Criteria

### Scenario: Start checkout with valid plan

When a customer selects an active plan, the system begins the checkout flow with the payment provider.

- Creates a checkout session for the selected plan
- Returns a checkout URL for the customer

### Scenario: Reject inactive plan

The selected plan is no longer available for purchase. The system should fail before creating any checkout session.

- Rejects checkout for an inactive plan
- Returns a validation error for the selected plan

### Scenario: Confirm completed checkout

After the payment provider confirms a successful checkout, the subscription becomes active.

- Activates the subscription after successful checkout confirmation
- Records the provider checkout reference
```

## Password Reset Link Spec example

```md
# Password Reset Link

Users can request a password reset link for an existing account.

## Acceptance Criteria

### Scenario: Request reset for existing account

The reset link should be usable for a limited time and tied to the requesting account.

- Creates a password reset token for the account
- Delivers a password reset link to the account email

### Scenario: Reject expired reset token

The reset token is older than the allowed reset window.

- Rejects password reset with an expired token
- Returns an expiration error for the reset token
```

## Review Checklist

- the file has exactly one H1 heading
- the file has exactly one `## Acceptance Criteria` section
- scenario headings, when present, use the exact `Scenario:` prefix
- scenario headings are H3 headings inside `Acceptance Criteria`
- any H2 heading other than `Acceptance Criteria` is treated as documentation only
- every acceptance criteria bullet list item is specific and testable
- scenario names are unique within the file
- acceptance criteria text is unique within each scenario or within the file when no scenarios are used
- prose improves clarity without becoming executable syntax

## What To Avoid

- adding `Given`, `When`, `Then` semantics or equivalent executable sections
- writing specs as step definitions
- syntax intended for runtime execution
- using vague scenario titles and vague acceptance criteria
- adding setup or action sections that the runner must execute
