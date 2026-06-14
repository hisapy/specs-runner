---
name: spec-authoring
description: Write, edit, and fix Markdown specs with acceptance criteria that can be run as acceptance tests. Activate when the user asks for a runnable spec or mentions acceptance criteria, scenarios, or the specs-runner tool.
---

# Spec Authoring

Use this skill to write specs with acceptance criteria that can be run as acceptance tests, like Behavior-Driven Development (BDD) but without Gherkin.

The program that reads these specs and runs them as tests is called `specs-runner`.

LLMs already know how to write specs. This skill exists to enforce the required structure and provide minimal guidance on writing good specs for `specs-runner`.

## Required Format

Each markdown spec must have:

- exactly one H1 title
- one H2 section named `## Acceptance Criteria`
- inside `## Acceptance Criteria`, zero or more H3 headings that start with the exact prefix `### Scenario:`
- bullet list items for testable behaviors under `## Acceptance Criteria` or under `### Scenario:` subsections, but not both in the same spec

The rest of the content is considered as arbitrary specs body and can be any text, section or other valid markdown content.

## Spec template

Use this template when you think you don't need to group acceptance criteria into scenarios:

```markdown
# Feature Title

_Optional text, section or other content describing the feature or requirement at a high level._

## Acceptance Criteria

- _A specific, testable condition that must be met_
- _Another specific, testable condition_
```

## Spec template with scenarios

Use this template when you want to group acceptance criteria into scenarios:

```markdown
# Feature Title

_Optional text, section or other content describing the feature or requirement at a high level._

## Acceptance Criteria

### Scenario: With valid input

- _A specific, testable condition that must be met_
- _Another specific, testable condition_

### Scenario: With invalid input

- _A specific, testable condition that must be met_
- _Another specific, testable condition_
```

## Guidance

- In general, follow best practices of Behavior-Driven Development (BDD) but without the need to write in Gherkin syntax.
- Acceptance criteria should describe an expected behavior, not implementation details.
- Keep acceptance criteria concise, specific, and independently testable — each bullet must describe an observable behavior and a verifiable outcome.
- Use scenarios to group related acceptance criteria by specific contexts or conditions.
- Write short scenario titles and acceptance criteria list items because these will be used to match test suite blocks (e.g. `describe`, `context`, `test`, `it`).
- When editing existing content, preserve all existing content and wording. Do not delete or rewrite anything the user wrote.
- Before adding any structural elements (H1 title, `## Acceptance Criteria` section, scenarios), ask the user first. Present your suggestion and let them decide — don't add them silently.
