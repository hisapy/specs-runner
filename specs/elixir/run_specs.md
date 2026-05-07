# Run Specs

An Elixir Mix task called `specs.run` that implements the `specs-runner` [blueprint](../../blueprint.md) to:

- read specs from Markdown files
- match specs, acceptance criteria, and scenarios to existing acceptance tests
- run the matched tests
- report the status of the specs based on the test results

The default output format should be similar to ExUnit's output.

A more verbose or documentation-like output might be documented in another spec file.

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

## Architecture

The architecture is event-driven, based on `ExUnit`.

The main components are:

- the specs parser used to parse streams of spec files
- `ExUnit` which runs the tests matching specs
- the reporter (formatter) used to print results to stdout

The formatter handle events emitted by the spec parser and ExUnit.

## Runtime

Given valid specs dir and tests dir, from a high-level perspective, `mix specs.run`

- parses specs
- matches valid specs to tests
- runs tests with ExUnit
- prints specs and tests output

From an event-driven perspective, events are emitted when:

- the specs runner is started
- a .md file in the specs dir is added to the run
- an error is detected parsing a specs file
- a specs file parsing is finished
- ExUnit finishes a test (actually ExUnit emits more events but this is the one we care about)

The reporter (a `GenServer` like `ExUnit.CLIFormatter`) handles the events and prints a message accordingly.

An specs file is matched to a test file only if it's done parsing without errors.

After parsing all the specs files, ExUnit is run with all the matching test files.

The output is similar to ExUnit's output but includes information about the spec file when an error happens. The reporter/formatter must keep track of valid specs to match `:test_finished` events from ExUnit to acceptance criteria items in the specs.

The pending specs are reported at the end of the run. An specs file will be marked as pending if its test file is missing or if any of its acceptance criteria or scenarios are not implemented in the test file, and the output indicates the exact missing pieces including the line number in the spec file.

Pending specs due to missing test files can be reported before ExUnit starts.

### Output example

```text
$ mix specs.run

Specs Runner started
Parsing specs from: specs

[PARSE ERROR] specs/billing/missing_title.md:3
	missing spec title (`# <title>`)

[PARSE ERROR] specs/profile/repeated_acceptance_criteria.md:14
	repeated acceptance criteria item: "User can upload an avatar"

Pending specs (pre-run):

- specs/orders/refund_flow.md
	reason: missing test file
	expected: test/specs/orders/refund_flow_test.exs

Running ExUnit with matched tests...

...

specs/billing/update_payment_method.md (Update payment method)
	1) test updates billing details (Specs.BillingTest)
		 test/specs/billing_test.exs:42
		 ** (RuntimeError) payment gateway timeout

specs/security/revoke_api_token.md (Revoke API token)
	2) test revokes api token (Specs.SecurityTest)
		 test/specs/security_test.exs:51
		 ** (MatchError) no match of right hand side value: {:error, :unauthorized}

..

specs/security/sign_out_everywhere.md (Sign out from all devices)
	3) test signs out from all devices (Specs.SecurityTest)
		 test/specs/security_test.exs:77
		 ** (ExUnit.AssertionError)

.....

specs/profile/update_email.md (Update profile email)
	4) test updates email (Specs.ProfileTest)
		 test/specs/profile_test.exs:23
		 ** (ArgumentError) invalid email format

Finished in 0.2 seconds
14 tests, 4 errors

Specs parser: 2 files with parsing errors

Pending specs: 3 (1 reported before ExUnit, 2 reported after ExUnit)

- specs/profile/change_avatar.md
	reason: missing test case
	acceptance criteria: "User can remove avatar"
	line: 18

- specs/onboarding/invite_teammate.md
	reason: missing scenario
	scenario: "Scenario: Invite by email"
	line: 22
```

## Acceptance Criteria

When `mix specs.run` is executed, the output should report the status of the specs, acceptance criteria and scenarios tested.

For testing this, both specs and tests should be provided as fixtures.

### Scenario: Missing test file

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
