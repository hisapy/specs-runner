# Generate Tests from Specs

An Elixir Mix task called `specs.generate_tests` that generates ExUnit test scaffolding for a given spec based on the [run_specs](run_specs.md) matching rules.

## Behavior

The `specs.generate_tests` task takes a single spec file path as an argument and generates a test file (or updates an existing one) for that spec if it doesn't have matching tests yet. Requiring an explicit spec path keeps concurrent invocations (e.g. multiple agents working on different specs) safe, since each run only reads and writes the files for one spec.

It follows the matching spec files to ExUnit tests rules from [run_specs](run_specs.md#matching-spec-files-to-exunit-tests) to determine where and how to create test code.

It generates not implemented tests, i.e., `test` without `do...end` blocks.

## Acceptance Criteria

### Scenario: With a missing test file

- creates the test file in the configured test directory
- generates tests and describe blocks matching the acceptance criteria ordering

### Scenario: When the test file exists

- appends describe blocks to the test module
- appends tests to the test module
- appends tests to existing describe blocks
- does not overwrite existing matching tests and describe blocks
