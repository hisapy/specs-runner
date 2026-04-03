# Specs Runner Blueprint

## Purpose

Define a language-agnostic workflow for:

- writing specifications in Markdown
- mapping specifications to native tests
- reporting implementation status without introducing a new testing DSL

This blueprint is the contract that runner implementations should follow.

## Non-Goals

This workflow does not try to:

- replace native test runners
- execute specification prose as code
- pass structured data from specifications into tests
- introduce step definitions, regex bindings, or shared step state
- reimplement Gherkin, Cucumber, Gauge, or similar executable specification systems
- require AI at runtime

## Core Idea

Use Markdown for specification authorship and native tests for execution.

The runner is responsible for:

- parsing specification files
- discovering test files and test names
- matching specification elements to test elements
- reporting pass, fail, pending, and orphan states

The runner is not responsible for generating tests or interpreting prose semantically.

## Design Principles

- Keep the runtime deterministic
- Prefer explicit conventions over inference
- Keep the spec format minimal and readable
- Avoid introducing a new executable syntax
- Let tests own setup, actions, and assertions in code
- Make missing coverage visible
- Make mismatches cheap to detect and fix

## Repository Model

A project using this workflow should have:

- a `specs/` directory containing Markdown specifications
- a test directory for spec-mapped tests, such as `test/specs/`
- a native runner-specific implementation that reads both

The default mapping model is mirrored paths.

Example:

```text
specs/auth/login.md
test/specs/auth/login_test.exs
```

The exact test file suffix depends on the ecosystem.

## Specification Format

### File Structure

A specification is a Markdown file.

The format is intentionally small:

- `# ...` defines the feature or capability title
- `## Scenario: ...` defines a scenario
- `Assertions:` defines the list of expected testable behaviors for that scenario
- all other prose is documentation only

Example:

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

### Required Rules

- Each spec file must contain exactly one H1 heading
- A scenario heading must use the exact prefix `Scenario:` at H2 level
- `Assertions:` applies to the scenario that precedes it
- Assertions are bullet items immediately under `Assertions:`
- Scenario names must be unique within a file
- Assertion text must be unique within a scenario

### Allowed Free-Form Content

The following content is allowed but ignored by the runner unless a runner chooses to expose it in reports:

- introductory paragraphs
- explanatory prose under a scenario
- notes, constraints, examples, or context sections
- additional headings that are not `## Scenario: ...`

The workflow intentionally keeps these sections non-executable.

## Mapping Model

### Level 1: File To File

A spec file maps to a test file by mirrored path convention.

Example:

```text
specs/billing/refunds.md
test/specs/billing/refunds_test.exs
```

If no test file is found for a spec file, the specification is pending or not implemented.

### Level 2: Scenario To Group

A `## Scenario: Name` maps to the native grouping construct when the runner supports one.

Grouped runner examples:

- ExUnit `describe "Name"`
- Jest `describe("Name", ...)`
- RSpec `describe "Name" do`

If the runner does not support grouped blocks, the scenario name is still part of the matching key.

Flat runner examples:

- pytest function naming
- Go `Test...` function naming

### Level 3: Assertion To Test

Each bullet under `Assertions:` maps to a single test case name.

Example:

```md
## Scenario: Failed login

Assertions:

- Rejects invalid password
```

maps to a native test case equivalent to:

```elixir
# Elixir
describe "Failed login" do
  test "Rejects invalid password" do
    # ...
  end
end
```

```ts
// Jest
describe("Failed login", () => {
  test("Rejects invalid password", () => {
    // ...
  });
});
```

## Runner Strategies

### Grouped Runner Strategy

Use the native test hierarchy when available.

Matching key:

- file path
- scenario name
- assertion text

Example shape:

```md
# User Login

## Scenario: Failed login

Assertions:

- Rejects invalid password
```

```elixir
describe "Failed login" do
  test "Rejects invalid password" do
    # ...
  end
end
```

### Flat Runner Strategy

If the native runner has no grouping construct, encode the scenario name into the test name or into a supported grouping substitute.

Examples:

- `test_failed_login__rejects_invalid_password`
- `class TestFailedLogin` with `test_rejects_invalid_password`

The runner implementation for that ecosystem defines the exact naming convention, but it must still preserve the same logical mapping:

- file
- scenario
- assertion

## Arrange, Act, Assert

The specification format does not explicitly map arrange, act, and assert to test code.

Reasoning:

- specs should describe behavior, not test mechanics
- test code should own setup, actions, and assertions
- mapping setup prose into executable code recreates the step-definition complexity this workflow is designed to avoid

If authors want to document context, they should write normal prose above `Assertions:`. The runner may display that prose in the future, but it does not execute or match it.

## Parsing Contract

Every runner implementation should parse a spec file into a structure equivalent to:

```text
SpecFile
- path
- title
- scenarios[]

Scenario
- name
- assertions[]
- prose[]

Assertion
- text
```

The exact internal representation is runner-specific.

### Parse Failures

A runner should fail clearly when a file violates the contract in ways that would make matching ambiguous.

Examples:

- missing H1 heading
- duplicate scenario names in one file
- duplicate assertion text inside one scenario
- `Assertions:` block without a preceding scenario

For purely non-essential prose variations, the runner should stay tolerant.

## Test Discovery Contract

Every runner implementation should discover test structure without relying on AI.

Preferred approaches:

- parse source files statically when practical
- use runner metadata or structured output when available
- avoid evaluating arbitrary test setup during discovery unless the native framework makes that unavoidable

The discovered structure should be equivalent to:

```text
TestFile
- path
- groups[]

Group
- name
- tests[]

TestCase
- name
```

For flat runners, `groups[]` may be synthesized from naming conventions.

## Matching Contract

Matching should be deterministic and based on exact names.

### Exactness Rules

- file mapping is by mirrored path convention
- scenario names are matched exactly
- assertion text is matched exactly to test names

Do not use fuzzy matching by default.

If names differ, the runner should report the mismatch instead of guessing.

### Matching Outcomes

For each spec element, compute one of the following:

- implemented and passing
- implemented and failing
- pending because no match exists

For each discovered test element with no matching spec element, compute orphan status.

## Status Model

The minimum status model is:

- `pass`: the mapped test exists and passed
- `fail`: the mapped test exists and failed
- `pending`: the spec file, scenario, or assertion has no matching test element
- `orphan`: a discovered test file, group, or test has no matching spec element

Runners may expose more detail internally, but the external reporting model should stay simple.

### Hierarchical Status

Status should aggregate upward.

Examples:

- a spec file is `pending` if its mapped test file does not exist
- a scenario is `pending` if any of its assertions are unmatched and no failing tests exist for it
- a scenario is `fail` if any matched assertion fails
- a scenario is `pass` only if all assertions are matched and passing

The same logic applies to the spec file level.

## Reporting Contract

The initial implementation uses CLI text output.

The output should show:

- spec files
- scenarios
- assertions
- their statuses
- orphan test items
- a summary line

Example:

```text
Specs Report

specs/auth/login.md
  [PASS] Scenario: Successful login
    [PASS] Creates a session with valid credentials
    [PASS] Returns a session token
  [FAIL] Scenario: Failed login
    [FAIL] Rejects invalid password
    [PASS] Increments failed attempt counter

specs/billing/refunds.md
  [PEND] No matching test file

Orphan Tests
  test/specs/auth/login_test.exs
    [ORPH] describe "Legacy flow"

Summary: 3 pass, 1 fail, 1 pending, 1 orphan
```

## CI Contract

The runner must coexist with the native test runner, not replace it.

Example expectations:

- ExUnit tests still run with `mix test`
- Jest tests still run with `npm test`
- the spec runner is an additional command, not a new required runtime

Recommended CI approach:

- run native tests normally
- run the spec runner separately when the implementation is ready
- keep jobs isolated per ecosystem

## AI Contract

AI is useful for authoring and setup, not for runtime matching.

Agents should:

- write specs following this format
- write tests that follow native conventions and exact naming
- install or copy the appropriate runner implementation for the project stack

Agents should not:

- invent alternative executable spec syntax
- add semantic matching at runtime
- translate prose into test code bindings automatically
