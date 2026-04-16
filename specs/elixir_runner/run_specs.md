# Run Specs

An Elixir Mix task called `specs.run` that implements the `specs-runner` [blueprint](../../blueprint.md) to:

- read specs from Markdown files
- match specs, acceptance criteria, and scenarios to existing acceptance tests
- run the matched tests
- report the status of the specs based on the test results

The default output format should be similar to ExUnit's output.

A more verbose or documentation-like format might be documented in another spec file.

## Matching spec files to ExUnit tests

- the tests directory, e.g., `test/specs` should mirror the strucutre of the specs dir
- `.md` files should match a test file in the test dir, e.g., `specs/login.md` and `test/specs/login_test.exs`
- acceptance criteria items should match `test` blocks
- `Scenario:` in spec should match a `describe` block in a test file when scenarios are used
- acceptance criteria items may match tests directly without a `describe` block when no scenarios are used

### Configuration

The specs and tests directory should be configurable:

- it should be possible to configure them with `Config`, e.g., in the `config.exs` file.
- the configuration in the `config.exs` file should be overridable with CLI arguments

## Acceptance Criteria

When `mix specs.run` is executed, the output should report the status of the specs, acceptance criteria and scenarios tested.

### Scenario: Missgin test file

- reports the spec as pending
- shows the name of the missing test file

### Scenario: Missing describe block

- reports the sepc as pending
- reports the scenario as pending
- shows the spec title and the missing describe block

### Scenario: Missing test case

- reports the sepc as pending
- reports the acceptance criteria item as pending
- shows the spec title and the missing test case

### Scenario: Missing test case in scenario

- reports the sepc as pending
- reports the scenario as pending
- shows the spec title, scenario and the missing test case
