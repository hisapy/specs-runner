# Contributing

Thanks for contributing to specs-runner.

## Development setup

1. Install toolchain versions from `.tool-versions`.
2. Work in the Elixir runner by default: `cd runners/elixir`.
3. Install dependencies: `mix deps.get`.

## Validate your changes

Run these commands in `runners/elixir`:

```sh
mix check
mix test
```

## Contribution flow

1. Open an issue (or discuss in an existing one) before large changes.
2. Create a branch and open a pull request.
3. Keep pull requests focused and include context about behavior changes.
4. Ensure CI is green before requesting review.

## Specs and contract updates

If behavior changes, update the canonical docs first:

- `blueprint.md` for framework contract
- `specs/` for executable behavior specs
- `skills/spec-authoring/SKILL.md` and `skills/spec-runner-usage/SKILL.md` when guidance changes
