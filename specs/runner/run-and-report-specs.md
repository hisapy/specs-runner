# Run And Report Specs

The specs runner reads Markdown specifications, matches them to native tests, and reports implementation status using a minimal spec format.

This file covers the core reporting flow for matched specs, missing test coverage, orphan test coverage, and summary output.

## Scenario: Discover mapped tests for specs

The runner should discover only the test files and test items that correspond to the requested specs instead of treating the whole test suite as in scope.

Each runner defines a spec test directory within the native test layout for its ecosystem.

For example, if a runner's spec test directory is `test/specs/`, then `specs/auth/login.md` maps to a mirrored test path such as `test/specs/auth/login_test.<suffix>`. The exact suffix and file naming pattern follow the ecosystem's native test conventions.

Assertions:

- Looks for mapped test files under the runner's configured spec test directory
- Maps a spec file to a test file by preserving its relative path under the spec test directory
- Limits discovery to the mapped test file for each spec file
- Discovers scenario-level groups and test case names from the mapped test file
- Does not require unrelated test files to determine spec status

## Scenario: Report pending coverage

When a spec element has no matching test element, the runner should make the missing coverage visible instead of guessing.

Assertions:

- Marks a spec file as pending when no matching test file exists
- Marks an assertion as pending when no matching test exists for its assertion text
- Marks a scenario as pending when it has unmatched assertions and no failing matched assertions

## Scenario: Report passing assertions

A specification file, its scenarios, and their assertion bullets all have matching native tests, and those tests pass.

Assertions:

- Marks each matched assertion as pass when its test passes
- Marks a scenario as pass when all of its assertions are matched and passing
- Marks a spec file as pass when all of its scenarios are passing

## Scenario: Report failing assertions

A matched assertion should report the underlying native test result without changing the assertion text or scenario name.

Assertions:

- Marks a matched assertion as fail when its test fails
- Marks a scenario as fail when any of its matched assertions fail
- Marks a spec file as fail when any of its scenarios fail

## Scenario: Report orphan tests

Discovered test elements that do not map to any spec element should be reported as orphan coverage.

Assertions:

- Reports a test file as orphan when it has no matching spec file
- Reports a grouped test block as orphan when it has no matching scenario in the mapped spec file
- Reports a test case as orphan when it has no matching assertion in the mapped scenario

## Scenario: Print hierarchical report output

The initial reporting surface is CLI text output that makes spec coverage easy to inspect.

Assertions:

- Lists spec files in the report output
- Lists scenarios under their spec file
- Lists assertions under their scenario
- Displays the computed status for each reported spec file, scenario, and assertion
- Displays orphan test items in a separate orphan section

## Scenario: Print summary totals

The report should end with a compact summary of the overall result set.

Assertions:

- Prints the total count of passing items in the summary
- Prints the total count of failing items in the summary
- Prints the total count of pending items in the summary
- Prints the total count of orphan items in the summary
