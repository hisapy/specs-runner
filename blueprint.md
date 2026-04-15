# Specs Runner Blueprint

This document is a _lightweight_ language-agnostic blueprint for a `specs-runner`.

A `specs-runner` is a tool for testing software specifications written in Markdown.

The idea is to make specifications live documentation by:

- writing specifications in Markdown
- mapping specifications to _acceptance_ tests
- reporting specification test and implementation status

In a way, this is similar to Behavior Drive Development (BDD) tools like Cucumber but using a simpler format in Markdown instead of Gherkin.

## Specifications Format

Each specification file written in Markdown should have:

- Exactly one H1 `title`
- One H2 `Acceptance Criteria` section
- Inside `Acceptance Criteria`, zero or more H3 `Scenario:` prefixed subheadings
- Bullet list items for testable behaviors under `Acceptance Criteria` or under a `Scenario:` subsection

The key elements considered by the `specs-runner` are:

- **Title**: a short, high-level description of the feature or requirement to be implemented
- **Acceptance criteria**: specific conditions that must be met
- **Scenarios**: optional groupings for related acceptance criteria

All other prose is documentation only that should guide a developer (or AI coding agent) to build the specified feature or requirement.

Nevertheless, the specifications should:

- be clear and concise
- include just enough information to build a required feature or software functionality
- provide a clear acceptance criteria optionally grouped in specific situations or **scenarios**

Example:

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

## Runtime Behavior

To test specifications, the `specs-runner` should:

- read specs from Markdown files
- match specs, acceptance criteria, and scenarios to existing acceptance tests in the codebase
- run the matched tests
- report the status of the specs based on the test results

The output report should show:

- spec titles, acceptance criteria, and scenarios
- status of each of the above items
- summary totals

## Matching Specs with Tests

- One spec `.md` file should match a test file
- Each runner defines its own spec test directory
- Acceptance criteria items map to test case names
- Scenario names map to test grouping construct when available
- Matching is exact by default (case-sensitive)

To simplify file matching, it is recommended to place the specifications in the `specs` directory at the root of the repo, and all the corresponding _acceptance_ tests in a specific directory, e.g., `test/specs`.

Example:

```md
## Acceptance Criteria

### Scenario: Login Failed

- rejects invalid password
```

would match something like the following inside a test

```javascript
// file: __tests__/spec/login.test.ts

describe("Login Failed", () => {
  it("rejects invalid password")
}
```

## About Statuses

- `passed` - a spec passes when all its acceptance criteria pass
- `failed` - a spec fails when any of its acceptance criteria fails
- `pending` - a spec, acceptance critieria or scenario is pending if there are no matching tests
- `orphan` - a test file, test group, or test is considered orphan if its matching spec, scenario, or acceptance criterion is not found in the expected `specs` directory

## Implementation Guidelines

The `specs-runner` should use the existing native test framework already used in the codebase. For example, if this is an Elixir codebase, the `specs-runner` can be a Mix task that uses `ExUnit` to run the tests in the `test/specs` directory.

Ideally, if the test runner can emit structured output, like `ExUnit`, test execution should be similar to a pipeline with the following stages:

1. **Discovery**: specs, acceptance criteria, and scenarios are loaded and prepared to be mapped
2. **Test run**: the test runner can run the expected tests
3. **Result mapping**: the results are matched with the specs
4. **Report**: the matched specs and tests are reported accordingly

The `specs-runner` should not:

- require AI at runtime
- introduce step definitions or runtime bindings
- execute prose as code
- replace the native test runner with a new implementation

### Additional Features

Eventually, the `specs-runner` should also provide options for:

- generating test scaffolding for pending specs (test files, classes, describe blocks, or tests)
- running tests with filters, e.g., filter specific specs to test
- marking specs as skipped or ignored in case we don't want to implement tests for specific spec files, scenarios, or acceptance criteria
- validating specs format, e.g., checking missing title or missing acceptance criteria
