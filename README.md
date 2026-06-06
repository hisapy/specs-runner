# specs-runner

This repository describes a _framework_ for writing testable software specifications in Markdown. This sits somewhere between Spec-Driven Development (SDD) and Behavior-Driven Development (BDD).

It provides:

- a concise common contract in `blueprint.md`
- an AI skill for spec authoring: `skills/spec-authoring/SKILL.md`
- specs for building a specs runner in [specs](./specs/)
- default runner implementations in [runners](./runners)
- an AI skill for using a specs runner: `skills/spec-runner-usage/SKILL.md`

## Runners

<table>
  <tr>
    <td valign="middle"><a href="./runners/elixir/README.md">Elixir</a></td>
    <td valign="middle"><img src="https://github.com/hisapy/specs-runner/actions/workflows/ci.yml/badge.svg" alt="" /> <a href="https://coveralls.io/github/hisapy/specs-runner?branch=main"><img src="https://coveralls.io/repos/github/hisapy/specs-runner/badge.svg?branch=main" alt="Coverage Status" /></a></td>
  </tr>
</table>

## Open source

- License: [MIT](./LICENSE)
- Contributions: [CONTRIBUTING.md](./CONTRIBUTING.md)
- Code of Conduct: [CODE_OF_CONDUCT.md](./CODE_OF_CONDUCT.md)
- Support: [SUPPORT.md](./SUPPORT.md)
