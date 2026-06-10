---
name: spec-authoring
description: Write specs in Markdown
---

# Spec Authoring

Use this skill to write specs with acceptance criteria that can be run as acceptance tests.

The program that reads these specs and runs them as tests is called `specs-runner`.

LLMs already know how to write specs. This skill exists to enforce the required structure and provide minimal guidance on writing good specs for `specs-runner`.

## Required Format

Each markdown spec must have:

- exactly one H1 title
- one H2 section named `## Acceptance Criteria`
- inside `## Acceptance Criteria`, zero or more H3 headings that start with the exact prefix `### Scenario:`
- bullet list items for testable behaviors under `## Acceptance Criteria` or under a `### Scenario:` subsection

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
- Keep acceptance criteria concise, specific, and independently testable.
- Use scenarios to group related acceptance criteria by specific contexts or conditions.
- Write short scenario titles and acceptance criteria list items because these will be used to match `describe` blocks, and `test` blocks in tools such as `Jest`, `ExUnit`, `RSpec` or function names in `pytest`.
- When editing an existing spec keep the original format even if invalid, i.e., do not worry about existing spec with invalid format
