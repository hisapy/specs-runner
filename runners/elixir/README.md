# SpecsRunnerElixir

Elixir reference runner for the `specs-runner` repository.

This project is intentionally minimal during the foundation phase.

It will eventually provide a native `mix spec` workflow for:

- parsing Markdown specifications
- discovering mapped ExUnit tests
- matching specs to tests
- reporting pass, fail, pending, and orphan states

Current status:

- project scaffold created
- CI runs `mix test`
- implementation modules will be added in later tasks
