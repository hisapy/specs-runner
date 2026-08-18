# Generate Tests from Specs

An Elixir Mix task called `specs.gen` that generates ExUnit test scaffolding for pending specs based on the [run_specs](run_specs.md) matching rules.

## Behavior

The `specs.gen` task scans specs files and generates test files or test blocks for specs that don't have matching tests yet.

It follows the matching spec files to ExUnit tests rules from [run_specs](run_specs.md#matching-spec-files-to-exunit-tests) to determine where and how to create test code.

## Acceptance Criteria

### Scenario: Missing test file

- generates a test file when the spec has no corresponding test file
- places the test file in the configured tests directory mirroring the specs structure
- includes a `describe` block for each scenario in the spec
- includes a `test` block for each acceptance criteria item

### Scenario: Missing test blocks

- adds `describe` blocks for scenarios that don't have corresponding test groups
- adds `test` blocks for acceptance criteria items that don't have corresponding tests
- preserves existing tests in the file

### Scenario: Test content generation

- generates valid ExUnit test syntax
- uses the acceptance criteria text as the test name
- includes a `skip` call by default for generated tests to be explicit about untested behavior
- follows Elixir naming conventions for test modules and functions