---
name: spec-authoring
description: Canonical guidelines for writing Markdown specifications that can be run with specs-runner.
---

# Spec Authoring

This skill provides the canonical guidelines for writing Markdown specifications that can be run with `specs-runner` and support Spec-Driven Development (SDD).

## Purpose

Use this skill when the user wants to:

- write a new spec that can be run with `specs-runner`
- refine an existing spec so it matches the runner contract
- improve scenario and assertion wording for runnable specs
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
- one or more H2 headings using the exact prefix `Scenario:`
- any H2 heading that does not start with `Scenario:` is documentation only
- optional prose where it improves clarity
- an `Assertions:` section under each scenario
- bullet items directly under `Assertions:` for each testable behavior

## Canonical Shape

```md
# Feature or Capability Title

Optional introductory prose.

## Scenario: Successful outcome

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

- be concise
- describe observable outcomes
- be concrete and specific
- be phrased so a runner or test can verify them directly
- avoid implementation details when possible
- be unique within the scenario
- represent one independently testable behavior

If an assertion combines multiple outcomes that should be validated independently, split it.

If a statement explains rules, naming conventions, mapping details, or implementation guidance rather than an observable outcome, put it in prose instead of `Assertions:`.

### Prose

Use normal prose to describe:

- context
- constraints
- examples
- intent

Prose should give enough guidance to help implement the requirement or feature in an SDD workflow, while staying non-executable.

Additional H2 headings are allowed for documentation, but if they do not start with `Scenario:` they are not executable and do not define scenarios.

Prose is documentation only. It is not executable.

## Examples

### User Login Spec

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

## Subscription Checkout Spec

```md
# Subscription Checkout

Customers can start and complete subscription checkout through a payment provider.

## Scenario: Start checkout with valid plan

When a customer selects an active plan, the system begins the checkout flow with the payment provider.

Assertions:

- Creates a checkout session for the selected plan
- Returns a checkout URL for the customer

## Scenario: Reject inactive plan

The selected plan is no longer available for purchase. The system should fail before creating any checkout session.

Assertions:

- Rejects checkout for an inactive plan
- Returns a validation error for the selected plan

## Scenario: Confirm completed checkout

After the payment provider confirms a successful checkout, the subscription becomes active.

Assertions:

- Activates the subscription after successful checkout confirmation
- Records the provider checkout reference
```

## Password Reset Link Spec

```md
# Password Reset Link

Users can request a password reset link for an existing account.

## Scenario: Request reset for existing account

The reset link should be usable for a limited time and tied to the requesting account.

Assertions:

- Creates a password reset token for the account
- Delivers a password reset link to the account email

## Scenario: Reject expired reset token

The reset token is older than the allowed reset window.

Assertions:

- Rejects password reset with an expired token
- Returns an expiration error for the reset token
```

## Review Checklist

- the file has exactly one H1 heading
- the file has at least one `Scenario:` H2 heading
- every scenario heading uses the exact `Scenario:` prefix
- scenario headings are H2 headings
- any H2 heading without the `Scenario:` prefix is treated as documentation only
- every scenario has an `Assertions:` section
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
