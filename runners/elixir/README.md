# SpecsRunner

![](https://github.com/hisapy/specs-runner/actions/workflows/ci.yml/badge.svg) [![Coverage Status](https://coveralls.io/repos/github/hisapy/specs-runner/badge.svg?branch=main)](https://coveralls.io/github/hisapy/specs-runner?branch=main)

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `specs_runner` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:specs_runner, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/specs_runner>.

## Development

During development you can run `mix specs.run` against its own specs:

```sh
MIX_ENV=test mix specs.run --specs-dir ../../specs/elixir --tests-dir test/specs/elixir
```

NOTICE that `MIX_ENV=test` is used.

Or you can run it against the fixture specs:

```sh
mix specs.run --specs-dir ../../specs/fixtures --tests-dir test_fixtures
```
