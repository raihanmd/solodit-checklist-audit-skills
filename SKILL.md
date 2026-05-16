---
name: solodit-checklist-audit
description: Solodit checklist-driven smart contract audit. Fetches the full Solodit audit checklist (370 items across 13 categories), auto-groups items into focused audit streams, and runs continuous parallel micro-audits until every checklist item is covered. Trigger on "solodit audit", "checklist audit", "full audit with solodit", "comprehensive audit".
---

# Solodit Checklist-Driven Audit

> **Agent compatibility:** Designed for OpenCode (uses `task()`, `background_output()`, `category` delegation). For other agents, the checklist references and audit methodology still apply - adapt the orchestration to your agent's toolset.

You are the orchestrator of a **continuous, checklist-driven smart contract security audit** powered by the [Solodit audit checklist](https://github.com/Cyfrin/audit-checklist).

This skill evaluates every checklist item against the codebase - each attack vector, baseline check, and integration-specific item is systematically reviewed.

**Skill directory:** `$SKILL_DIR` is the directory containing this SKILL.md file. Find it by searching for this file's location:
- OpenCode: `~/.config/opencode/skills/solodit-checklist-audit/`
- Claude Code: `~/.claude/skills/solodit-checklist-audit/`
- Cursor: `~/.cursor/skills/solodit-checklist-audit/`
- Codex CLI: `~/.codex/skills/solodit-checklist-audit/`
- Windsurf: `~/.codeium/windsurf/skills/solodit-checklist-audit/`

**Project root:** The directory where the `.sol` files being audited live. Resolve it from your current working directory.

## Mode Selection

**Exclude pattern:** skip directories `interfaces/`, `lib/`, `mocks/`, `test/`, `node_modules/` and files matching `*.t.sol`, `*Test*.sol`, `*Mock*.sol`, `*Interface*.sol`.

- **Default** (no arguments): scan all `.sol` files in scope. Use Bash `find` (not Glob).
- **`$filename ...`**: scan the specified file(s) only.

**Flags:**

- `--output <path>` (optional): write the final report to a markdown file. Default: `solodit-report.md` in the project root.

**Progress persistence:** All audit state is stored in `.solodit-audit-data/` at the project root. This survives agent restarts - if the agent crashes or is restarted, it resumes from the last completed wave.

---

## Orchestration

### Turn 1 - Discover

Print the banner, then make these parallel tool calls in one message:

```

 ███████╗██████╗ ███████╗
██╔════╝██╔══██╗██╔════╝
███████╗██████╔╝█████╗
╚════██║██╔═══╝ ██╔══╝
███████║██║     ███████╗
╚══════╝╚═╝     ╚══════╝

  S O L O D I T   C H E C K L I S T   A U D I T

```

a. Bash `find` for in-scope `.sol` files per mode selection
b. **Checklist fetch (online-first with offline fallback):**
   - Bash `curl -sfL --connect-timeout 10 --max-time 30 https://raw.githubusercontent.com/Cyfrin/audit-checklist/main/checklist.json`
   - If fetch succeeds: use the remote JSON
   - If fetch fails: read `$SKILL_DIR/references/checklist.json` (bundled 370 items)
   - If both fail: abort with `Cannot fetch Solodit checklist. Check internet connection or reinstall the skill.`
c. Bash `mkdir -p [project-root]/.solodit-audit-data`
d. Read project documentation if available (README.md, docs/, or similar)
e. Bash `find` for any existing audit reports or security docs (`.md` files mentioning "audit", "security", "finding", "vulnerability")

If the remote checklist fetch succeeds, count total items (sum all `data[].length` across categories) and compare with the bundled version. If they differ, print a note: `Using remote checklist ({N} items). Bundled version has {M} items - consider reinstalling to refresh.`

### Turn 2 - Parse, Group & Build Progress Tracker

Parse the checklist JSON. The Cyfrin format is:
```json
[
  {
    "category": "Attacker's Mindset",
    "data": [
      { "id": "SOL-AM-DOSA-1", "question": "...", "description": "...", "remediation": "...", "references": [...] },
      ...
    ]
  },
  ...
]
```

Each item has: `id`, `question`, `description`, `remediation`, `references` (array of URLs). The `category` field is on the parent object, not on individual items.

**Filter by relevance:** Skip categories that clearly don't apply (e.g., ERC721/1155 checks if no NFT contracts, LayerZero if no cross-chain code, Proxy/Upgradable if no proxy patterns). Be conservative - when in doubt, include the stream.

**Group into audit streams:** Each stream = one narrow focus = one sub-agent. Group by attack vector/topic. Target 3-15 items per stream. Too many = agent loses focus. Too few = wasteful overhead.

**Name each stream** with a short descriptive label (e.g., `dos-griefing`, `reentrancy`, `access-control`, `math-precision`, `uniswap-integration`, `erc20-compatibility`).

**Write the progress tracker** to `[project-root]/.solodit-audit-data/progress.json`:

```json
{
  "version": "1.0.0",
  "started_at": "<timestamp>",
  "total_items": <N>,
  "streams": [
    {
      "stream_id": "dos-griefing",
      "category": "Attacker's Mindset",
      "item_ids": ["SOL-AM-DOSA-1", "SOL-AM-DOSA-2", ...],
      "priority": "high",
      "status": "pending",
      "wave": null,
      "result_file": null
    }
  ],
  "waves_completed": 0,
  "findings_count": 0
}
```

**Build source bundle:** Write ALL in-scope `.sol` files to `[project-root]/.solodit-audit-data/source.md` with `### path` headers and fenced code blocks.

**Build stream instruction files:** For each stream, write `[project-root]/.solodit-audit-data/stream-{stream_id}.md` containing:
- The stream's checklist items with full question, description, remediation, and references
- The absolute path to source.md (e.g., `/home/user/project/.solodit-audit-data/source.md`)
- The absolute path to the results directory (e.g., `/home/user/project/.solodit-audit-data/results/`)

Print: `Parsed {N} checklist items into {M} audit streams. Progress tracker: .solodit-audit-data/progress.json`

**Priority assignment:**
- `high`: Attacker's Mindset, DeFi, Token (ERC20), External Call items
- `medium`: Basics (Access Control, Math, Payment, Function), Integrations items
- `low`: Basics (Event, Inheritance, Type, Version), Heuristics items

### Turn 3 - Spawn Wave 1

Read `progress.json`. Select up to 8 streams with `status: "pending"` and highest priority.

**If running on OpenCode:** For each selected stream, spawn an agent using `task()` with `category="deep"` or `category="unspecified-high"`, `run_in_background=true`, `load_skills=[]`.

**If running on other agents (Claude Code, Cursor, Codex, Windsurf):** Process streams sequentially - one at a time. Read the stream file, audit inline, then move to the next stream. No background spawning.

**Agent prompt:** Read `$SKILL_DIR/references/stream-template.md` and substitute all placeholders:
- `{stream_id}` - the stream's ID
- `{source_path}` - absolute path to source.md
- `{results_path}` - absolute path to results directory
- `{checklist_items}` - embed the actual checklist items from the stream file inline (do NOT pass a placeholder or file reference)

**Update progress.json:** For each spawned stream, set `status: "running"`, `wave: <current_wave_number>`.

Store each agent's `session_id` for follow-up (OpenCode only).

### Turn 4 - Wave Continuation Loop

**This is the critical loop. Do NOT ask the user for permission between waves. Continue automatically.**

**If running on OpenCode:**
1. Collect results from all background agents via `background_output(task_id="...")`.
2. For each completed agent:
   - Write results to `[project-root]/.solodit-audit-data/results/stream-{stream_id}.md`
   - Update `progress.json`: set `status: "completed"`, `result_file: "results/stream-{stream_id}.md"`
   - Increment `waves_completed`
3. **Check for remaining streams:** Read `progress.json`. Are there streams with `status: "pending"`?
   - **YES** AND we haven't exceeded 3 consecutive waves without progress:
     - Spawn Wave N+1 with up to 8 pending streams (highest priority first)
     - Update their status to `running` in `progress.json`
     - **END YOUR RESPONSE.** Wait for the system notification, then repeat from step 1.
   - **NO** (all streams completed): Proceed to Turn 5 (Final Synthesis).

**If running on other agents:** After processing all streams sequentially, proceed directly to Turn 5.

**Safety gate:** If 3 consecutive waves produce zero findings AND zero applicable items, stop and note: `Remaining streams appear to be not applicable to this codebase. Marking as NOT APPLICABLE.`

### Turn 5 - Final Synthesis & Report

1. **Collect all results** from every stream.
2. **Deduplicate:** Group findings by root cause. If two checklist items surface the same underlying bug, merge them and note both checklist IDs.
3. **Severity gate:** Apply standard audit severity criteria:
   - **HIGH:** Direct loss of funds, protocol insolvency, governance takeover
   - **MEDIUM:** Partial loss of funds, DoS, incorrect accounting, bypass of intended restrictions
   - **LOW:** Minor deviation from spec, gas inefficiency, confusing UX
   - **INFO:** Code style, naming, documentation, minor improvements
4. **Coverage report:** Build a table of every checklist item with its status (FINDING / PASS / NOT APPLICABLE).
5. **Write the final report** to `{output_path}` (default: `solodit-report.md`).

**Report format:** Read `$SKILL_DIR/references/report-template.md` and fill in the placeholders. Use plain ASCII only - no em-dashes, curly quotes, or decorative Unicode. Use [H], [M], [L], [I] for severity tags.

6. **Cleanup:** Remove `.solodit-audit-data/` directory after successful report generation. Or keep it if the user wants to resume later.

Print the banner closing:

```

   S C A   A U D I T   C O M P L E T E

```

---

## Banner

Before doing anything else, print this exactly:

```

 ███████╗██████╗ ███████╗
██╔════╝██╔══██╗██╔════╝
███████╗██████╔╝█████╗
╚════██║██╔═══╝ ██╔══╝
███████║██║     ███████╗
╚══════╝╚═╝     ╚══════╝

  S O L O D I T   C H E C K L I S T   A U D I T

```

---

## Key Design Principles

1. **One agent = one narrow focus.** Each stream covers 3-15 related checklist items. Never give one agent 50+ items.
2. **Continuous execution.** The orchestrator keeps spawning waves until all items are covered. No user prompts between waves.
3. **Progress persistence.** `.solodit-audit-data/progress.json` survives agent restarts. If the agent crashes, it resumes from the last completed wave.
4. **Online-first, offline fallback.** Fetch the latest checklist from GitHub. Fall back to the bundled 370-item version if offline.
5. **Bundle-based context.** Source code and stream instructions are written to files, not inlined into prompts. This saves tokens and keeps prompts clean.
6. **Conservative filtering.** When deciding if a checklist category applies, err on the side of inclusion. Missing a check is worse than a wasted agent.
7. **Deduplication at synthesis.** Multiple checklist items may surface the same bug. Merge at synthesis time, not during agent execution.
8. **Trace, don't match.** Agents must trace full execution paths, not just grep for keyword matches.
9. **PDF-safe output.** All report text must be valid UTF-8 with plain ASCII - no em-dashes, curly quotes, or decorative Unicode symbols.
