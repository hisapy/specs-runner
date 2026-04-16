# AGENTS

This repository defines a framework for Markdown-based executable specifications and includes guidance assets (blueprint, plans, and skills). It is currently documentation-first, with runner implementation work centered under `runners/`.

## Start Here

- Read [README.md](README.md) for repository purpose and structure.
- Treat [blueprint.md](blueprint.md) as the canonical contract for specs-runner behavior.
- Use [PLAN.md](PLAN.md) for current scope, phases, and implementation priorities.

## Canonical Authoring And Usage Guides

- For writing specs, follow [skills/spec-authoring/SKILL.md](skills/spec-authoring/SKILL.md).
- For running or operating a runner, follow [skills/spec-runner-usage/SKILL.md](skills/spec-runner-usage/SKILL.md).

## Working In This Repo

- If changing contracts or behavior definitions, update the source-of-truth docs first, then align dependent docs.
- Prefer linking to existing docs instead of duplicating guidance in new files.
- Be alert for stale references: some docs may describe planned paths/commands that are not yet implemented.

## Key Directories

- Specs for specific `spec-runner` implementation live in the [specs](./specs/) directory
- The implemented runners live in the `runners` directory

## Validation

- There is no guaranteed root-level build/test command for the whole repo.
- CI targets runners in the `runners` directory
- Specs for specific implementations should be validated against the [blueprint](./blueprint.md) and the guidelines in the [spec-authoring](./skills/spec-authoring/SKILL.md)
