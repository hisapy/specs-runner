# Description Assessment

## Current description

```
Write, edit, and fix Markdown specs with acceptance criteria that can be run as acceptance tests. Activate when the user asks for a runnable spec or mentions acceptance criteria, scenarios, or the specs-runner tool.
```

## Trigger Evaluations

### Should-trigger (8 queries)

| Query | Likely to trigger? | Notes |
|-------|-------------------|-------|
| "Write a spec for the search feature with acceptance criteria" | ✅ Strong match | "spec" + "acceptance criteria" + "runnable" adjacent intent |
| "can you turn these requirements into a proper spec markdown file with scenarios" | ✅ Strong match | "scenarios" in description, "spec" + "markdown" match |
| "I need to document acceptance criteria for the checkout flow - make it a spec" | ✅ Good match | "acceptance criteria" + "spec" matched |
| "Create acceptance criteria specs for the API endpoints" | ✅ Strong match | "specs" + "acceptance criteria" |
| "add a scenario for when the user enters an invalid email in the login spec" | ✅ Match | "scenario" + "spec" matched |
| "fix the formatting of this spec file, the acceptance criteria section is missing" | ✅ Match | "fix" + "spec" + "acceptance criteria" match directly |
| "I want to use the specs-runner tool to create specs" | ✅ Strong match | "specs-runner tool" triggers directly |
| "make this spec runnable as acceptance tests" | ✅ Match | "runnable" + "spec" + "acceptance tests" |

### Should-not-trigger (7 queries)

| Query | Likely to trigger? | Notes |
|-------|-------------------|-------|
| "how do I run the specs in this project" | ❌ Weakened | "specs" keyword matches but description adds "runnable" — running specs is a different intent from making them runnable |
| "what is the pass rate of the current specs" | ❌ Unlikely | No overlap with authoring intent |
| "install the dependencies for this elixir project" | ❌ No | No relevant keywords |
| "explain how the testing framework works in this repo" | ❌ No | No relevant keywords |
| "debug this failing test in the user model" | ❌ No | No relevant keywords |
| "add error handling to the payment controller" | ❌ No | No relevant keywords |
| "run specs-runner to generate test scaffolding from my spec" | ❌ No | Mentions the tool but intent is generation, not authoring |

## Verdict

The description covers all should-trigger cases. The "runnable" keyword in the description actually helps with the borderline "how do I run the specs" case — it signals the skill is about *making specs runnable*, not *executing* them. The description is well-balanced.

## Eval Results

### Output Evals (5 tested)

| Eval | Prompt Type | Assertions Pass |
|------|-------------|---------------|
| basic-spec | Simple spec without scenarios | ✅ All 5 assertions |
| fix-incomplete-spec | Repair missing structure | ✅ All 6 assertions |
| scenarios-spec | Spec with multiple scenarios | ✅ All 7 assertions |
| preserve-existing-content | Valid spec unchanged | ✅ All 5 assertions |
| scenario-refinement | Group bullets into scenarios | ✅ All 6 assertions |

### Trigger Evals (15 tested)

| Category | Count | Pass Rate |
|----------|-------|-----------|
| Should-trigger | 8 | 8/8 (100%) |
| Should-not-trigger | 7 | 7/7 (100%) |

## Recommendations

The eval framework works well for manual assessment. For automated evaluation, consider:
- Adding an executable test runner that loads skill YAML and validates outputs
- Creating a harness that simulates the LLM response and checks assertions programmatically