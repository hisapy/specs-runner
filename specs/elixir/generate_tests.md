# Generate Tests from Specs

An Elixir Mix task called `specs.generate_tests` that generates ExUnit test scaffolding for a given spec based on the [run_specs](run_specs.md) matching rules.

## Behavior

The `specs.generate_tests` task takes a single spec file path as an argument and generates a test file or test blocks for that spec if it doesn't have matching tests yet. Requiring an explicit spec path keeps concurrent invocations (e.g. multiple agents working on different specs) safe, since each run only reads and writes the files for one spec.

It follows the matching spec files to ExUnit tests rules from [run_specs](run_specs.md#matching-spec-files-to-exunit-tests) to determine where and how to create test code.

## Acceptance Criteria

### Scenario: Missing test file

- generates a test file when the spec has no corresponding test file
- places the test file in the configured tests directory mirroring the specs structure
- includes a `describe` block for each scenario in the spec
- includes a `test` block for each acceptance criteria item
- uses the acceptance criteria text as the test name
- generates tests without a body to be explicit about untested behavior

### Scenario: Missing test blocks

- adds `describe` blocks for scenarios that don't have corresponding test groups
- adds `test` blocks for acceptance criteria items that don't have corresponding tests
- preserves existing tests in the file