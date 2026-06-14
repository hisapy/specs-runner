# Description Assessment

## Current description

```
Write, edit, and fix Markdown specs with acceptance criteria that can be run as acceptance tests. Activate when the user asks for a runnable spec or mentions acceptance criteria, scenarios, or the specs-runner tool.
```

## Trigger eval set analysis

### Should-trigger (6 queries)

| Query | Likely to trigger? | Notes |
|-------|-------------------|-------|
| "Write a spec for the search feature with acceptance criteria" | ✅ Strong match | "spec" + "acceptance criteria" + "runnable" adjacent intent |
| "can you turn these requirements into a proper spec markdown file with scenarios" | ✅ Strong match | "scenarios" in description, "spec" + "markdown" match |
| "I need to document acceptance criteria for the checkout flow - make it a spec" | ✅ Good match | "acceptance criteria" + "spec" matched |
| "Create acceptance criteria specs for the API endpoints" | ✅ Strong match | "specs" + "acceptance criteria" |
| "add a scenario for when the user enters an invalid email in the login spec" | ✅ Match | "scenario" + "spec" matched |
| "fix the formatting of this spec file, the acceptance criteria section is missing" | ✅ Match | "fix" + "spec" + "acceptance criteria" match directly |

### Should-not-trigger (6 queries)

| Query | Likely to trigger? | Notes |
|-------|-------------------|-------|
| "how do I run the specs in this project" | ❌ Weakened | "specs" keyword matches but description adds "runnable" — running specs is a different intent from making them runnable |
| "what is the pass rate of the current specs" | ❌ Unlikely | No overlap with authoring intent |
| "install the dependencies for this elixir project" | ❌ No | No relevant keywords |
| "explain how the testing framework works in this repo" | ❌ No | No relevant keywords |
| "debug this failing test in the user model" | ❌ No | No relevant keywords |
| "add error handling to the payment controller" | ❌ No | No relevant keywords |

## Verdict

The description covers all should-trigger cases. The "runnable" keyword in the description actually helps with the borderline "how do I run the specs" case — it signals the skill is about *making specs runnable*, not *executing* them. The description is well-balanced.
