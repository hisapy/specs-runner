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

- it should be possible to configure them with `Config`, e.g., in the `config.exs` file or [test.exs](../../runners/elixir/config/test.exs)
- the configuration in the `config.exs` file should be overridable with CLI arguments

## Architecture

The architecture is event-driven, based on `ExUnit`.

The main components are:

- the specs parser used to parse streams of spec files
- `ExUnit` which runs the tests matching specs
- the output formatter used to print results to stdout

The formatter handle events emitted by the spec parser and ExUnit.

## Runtime

Given valid specs dir and tests dir, from a high-level perspective, `mix specs.run`

- parses specs
- matches valid specs to tests
- runs tests with ExUnit
- prints specs and tests output

The `:test_finished` event is emitted when ExUnit finishes a test (actually ExUnit emits more events but this is the one we care about). A `GenServer` like `ExUnit.CLIFormatter` handles the events and uses the output formatter to print the test state, like `ExUnit` does, but starting the output with the specs file path and title in case of failures.

An specs file is matched to a test file only if it's done parsing without errors.

After parsing all the specs files, ExUnit is run with all the matching test files.

The output is similar to ExUnit's output but includes information about the spec file when an error happens. The reporter/formatter must keep track of valid specs to match `:test_finished` events from ExUnit to acceptance criteria items in the specs.

### Output example

```text
$ mix specs.run
SpecsRunner is running
Specs directory: ../../specs/
Tests directory: test/specs

[INVALID] billing/missing_title.md:3
	- missing spec title (`# <title>`)
[PENDING] orders/refund_flow.md (Refund flow)
	reason: missing test file
	expected: orders/refund_flow_test.exs
[INVALID] profile/repeated_acceptance_criteria.md:14
	- repeated acceptance criteria item: "User can upload an avatar"

Running ExUnit with matched tests...

...

[FAILED] billing/update_payment_method.md (Update payment method)
	1) test updates billing details (Specs.BillingTest)
		 test/specs/billing_test.exs:42
		 ** (RuntimeError) payment gateway timeout

[FAILED] security/revoke_api_token.md (Revoke API token)
	2) test revokes api token (Specs.SecurityTest)
		 test/specs/security_test.exs:51
		 ** (MatchError) no match of right hand side value: {:error, :unauthorized}

..

[FAILED] security/sign_out_everywhere.md (Sign out from all devices)
	3) test signs out from all devices (Specs.SecurityTest)
		 test/specs/security_test.exs:77
		 ** (ExUnit.AssertionError)

.....

[FAILED] profile/update_email.md (Update profile email)
	4) test updates email (Specs.ProfileTest)
		 test/specs/profile_test.exs:23
		 ** (ArgumentError) invalid email format

Finished in 0.2 seconds
14 tests, 4 errors

[PENDING] billing/update_payment_method.md (Update payment method)
	reason: missing scenario

	Scenario: Update succeeded
	- sends an email to the user

[PENDING] sso/github.md (Add GitHub SSO)
	reason: untested acceptance criteria
	- sends an email to the user

```

## Acceptance Criteria

The output of `mix specs.run` should cover the following scenarios.

### Scenario: Invalid specs error

- when the specs title is missing or repeated
- when the acceptance criteria section is missing or repeated
- when a scenario is repeated or empty
- when a test is repeated

### Scenario: Pending specs warning

- with reason: missing test file
- with reason: missing scenario
- with reason: untested acceptance criteria

### Scenario: Passed tests

- print a green dot

### Scenario: Failed tests

- include the specs path and title
- report the errors like ExUnit

### Scenario: Summary

- includes the ExUnit summary
- includes total specs count
- includes passed specs count
- includes pending specs count
- includes failed specs count
