# Specs Runner Blueprint

This document is a _lightweight_ language-agnostic blueprint for a `specs-runner`.

A `specs-runner` is a tool for testing assertions in software specifications written in Markdown.

The idea is to facilitate Spec-Driven Development (SDD) and make specifications live documentation by:

- writing specifications in Markdown
- mapping specifications to _acceptance_ tests
- reporting specification test and implementation status

In a way, this is similar to tools like Cucumber but using a simpler format in Markdown instead of Gherkin.

## Specifications Format

Each specification file written in Markdown should have:

- Exactly one H1 `title`
- One or more H2 `Scenario:` prefixed subheadings
- Inside scenarios, one `Assertions:` line and below it, a bullet list of testable behaviors

The key elements considered by the `specs-runner` are:

- **Title**: a short, high-level description of the feature or requirement to be implemented
- **Scenarios**: the behavior of the feature or requirement is described in different scenarios
- **Assertions**: represent specific conditions that must be met

All other prose is documentation only that can be used to build the specified feature or requirement.

Nevertheless, the specifications should:

- be clear and concise
- include just enough information to build a required feature or software functionality
- describe the behavior of the feature or functionality in specific situations or **scenarios**

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

## Runtime Behavior

To test assertions in specifications, the `specs-runner` should:

- read specs from Markdown files
- match specs, scenarios, and assertions to existing acceptance tests
- run the matched tests
- report the status of the specs based on the test results

The output report should show:

- spec titles, scenarios, assertions
- status of each of the above items
- summary totals

## Matching Specs with Tests

- One spec `.md` file should match a test file
- Each runner defines its own spec test directory within the native test layout
- Scenario names map to the native grouping construct when available
- Assertion text maps to native test case names
- Matching is exact by default

To simplify file matching, it is recommended to place the specifications in the `specs` directory at the root of the repo, and all the corresponding _acceptance_ tests in a specific directory, e.g., `test/specs`.

Example:

`## Scenario: Login Failed` would match a `describe("Login Failed")` block inside a test.

And

```md
Assertions:

- rejects invalid password
```

would match a `it("rejects invalid password")` test.

## About Statuses

- `passed` - a spec passes when all its assertions pass
- `failed` - a spec fails when any of its assertions fails
- `pending` - a spec, scenario, or assertion is pending if there are no corresponding tests
- `orphan` - a test file, test group, or test is considered orphan if its corresponding spec, scenario, or assertion is not found in the expected `specs` directory

## Implementation Guidelines

The `specs-runner` should use the existing native test framework already used in the codebase. For example, if this is an Elixir codebase, the `specs-runner` can be a Mix task that uses `ExUnit` to run the tests in the `test/specs` directory.

Ideally, if the test runner can emit structured output, like `ExUnit`, test execution should be similar to a pipeline with the following stages:

1. **Discovery**: specs, scenarios, assertions are loaded and prepared to be mapped
2. **Test run**: the native test runner can run all the tests in the specific directory for spec tests
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
- marking specs as skipped or ignored in case we don't want to implement tests for specific spec files, scenarios or assertions
- validating specs format, e.g., checking missing title or missing assertions in scenarios
