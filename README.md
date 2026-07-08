# specs-runner

This repository describes a _framework_ for writing testable software specifications in Markdown. This sits somewhere between Spec-Driven Development (SDD) and Behavior-Driven Development (BDD).

It provides:

- a concise common contract in `blueprint.md`
- an AI skill for spec authoring: `skills/spec-authoring/SKILL.md`
- specs for building a specs runner in [specs](./specs/)
- default runner implementations in [runners](./runners)
- an AI skill for using a specs runner: `skills/spec-runner-usage/SKILL.md`

## Runners

- **Elixir**

  ![](https://github.com/hisapy/specs-runner/actions/workflows/ci.yml/badge.svg) [![Coverage Status](https://coveralls.io/repos/github/hisapy/specs-runner/badge.svg?branch=main)](https://coveralls.io/github/hisapy/specs-runner?branch=main)

## Skills Evaluation

Skills are evaluated using a lightweight evaluation system with two categories:

### Trigger Evals

Tests whether the skill description correctly identifies when the skill should activate. Each entry in `trigger-evals.json` contains:

```json
{"query": "User's natural language query", "should_trigger": true|false}
```

### Output Evals

Tests the skill's output against expected assertions. Each eval in `evals.json` contains:

```json
{
  "id": 1,
  "name": "descriptive-name",
  "prompt": "User's query to the skill",
  "expected_output": "Brief description of expected output format",
  "files": ["optional-file-to-include-in-context"],
  "assertions": ["assertion-1", "assertion-2"]
}
```

Assertions should be verifiable conditions like:
- "Output has exactly one H1 heading"
- "No bullet list items directly under ## Acceptance Criteria"
- "Original content is preserved as body text"

### Running Evals

1. For trigger evals: Apply the skill description to each query and verify correct activation decision
2. For output evals: Apply the skill instructions to the prompt and verify assertions pass

### Workspace Structure

Each skill workspace directory (`skills/<skill-name>-workspace/`) contains:
- `evals.json` - Output evals for the skill
- `trigger-evals.json` - Trigger decision evals
- `files/` - Supporting files referenced by evals (optional)
- Analysis documentation with verdict and recommendations

## Open source

- License: [MIT](./LICENSE)
- Contributions: [CONTRIBUTING.md](./CONTRIBUTING.md)
- Code of Conduct: [CODE_OF_CONDUCT.md](./CODE_OF_CONDUCT.md)
- Support: [SUPPORT.md](./SUPPORT.md)
