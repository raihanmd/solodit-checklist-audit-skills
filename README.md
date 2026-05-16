# Solodit Checklist Audit Skills

> Checklist-driven smart contract security auditing. Systematically evaluates 370+ Solodit checklist items against your codebase.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Checklist Items](https://img.shields.io/badge/Checklist-370%20items-blue)](https://github.com/Cyfrin/audit-checklist)

## What is Solodit?

[Solodit](https://solodit.xyz) by [Cyfrin](https://cyfrin.io) is the largest open database of smart contract security findings - 50,000+ vulnerabilities from real audits by firms like Cyfrin, Sherlock, Code4rena, Trail of Bits, and more. Every finding is categorized, tagged, and linked to the actual code that caused it.

The [Solodit Audit Checklist](https://github.com/Cyfrin/audit-checklist) distills that database into **370 systematic checks** across 13 categories - from reentrancy and access control to oracle manipulation and cross-chain bridge risks. It's the same checklist professional auditors use to ensure nothing slips through.

## Why This Skill

Going through 370 checklist items manually takes time. This skill speeds it up by:

- **Systematic coverage** - all 370 checklist items are evaluated, not just the ones the AI flags as relevant
- **Parallel execution** - up to 8 agents audit different attack vectors simultaneously
- **Resumable** - progress is tracked in `.solodit-audit-data/`, so if the agent crashes or restarts, it picks up where it left off
- **Traceable output** - every finding maps back to specific checklist IDs, so you know exactly what was checked and what was found

**Best practice:** Use this alongside [Solodit MCP](https://github.com/zerotrust-labs/solodit-mcp) for interactive finding searches during the audit. The MCP server lets you query Solodit's 50,000+ real-world findings to enrich your audit with historical context.

```bash
# Install Solodit MCP (recommended companion)
git clone https://github.com/zerotrust-labs/solodit-mcp.git ~/solodit-mcp
cd ~/solodit-mcp && npm install
```

## Install

### Option 1: npx skills (Recommended)

Works with Claude Code, Cursor, Codex, OpenCode, Windsurf, and 50+ other agents.

> **Note:** Parallel wave execution (up to 8 agents at once) requires OpenCode. On Claude Code, Cursor, Windsurf, and Codex, the skill runs sequentially - all 370 checklist items are still covered.

Preview skills before installing:
```bash
npx skills add raihanmd/solodit-checklist-audit-skills --list
```

Install:
```bash
npx skills add raihanmd/solodit-checklist-audit-skills
```

For global install (available in all projects):
```bash
npx skills add raihanmd/solodit-checklist-audit-skills -g
```

To target specific agents:
```bash
npx skills add raihanmd/solodit-checklist-audit-skills -a claude-code -a cursor
```

For global install (available in all projects):

```bash
npx skills add raihanmd/solodit-checklist-audit-skills -g
```

To target specific agents:

```bash
npx skills add raihanmd/solodit-checklist-audit-skills -a claude-code -a cursor
```

### Option 2: Manual Install

Copy-paste the command for your AI assistant. Each agent has its own skill directory:

**Claude Code**
```bash
mkdir -p ~/.claude/skills/solodit-checklist-audit && curl -sL https://github.com/raihanmd/solodit-checklist-audit-skills/archive/refs/heads/main.tar.gz | tar xz --strip-components=1 -C ~/.claude/skills/solodit-checklist-audit
```

**Cursor**
```bash
mkdir -p ~/.cursor/skills/solodit-checklist-audit && curl -sL https://github.com/raihanmd/solodit-checklist-audit-skills/archive/refs/heads/main.tar.gz | tar xz --strip-components=1 -C ~/.cursor/skills/solodit-checklist-audit
```

**Codex CLI**
```bash
mkdir -p ~/.codex/skills/solodit-checklist-audit && curl -sL https://github.com/raihanmd/solodit-checklist-audit-skills/archive/refs/heads/main.tar.gz | tar xz --strip-components=1 -C ~/.codex/skills/solodit-checklist-audit
```

**OpenCode**
```bash
mkdir -p ~/.config/opencode/skills/solodit-checklist-audit && curl -sL https://github.com/raihanmd/solodit-checklist-audit-skills/archive/refs/heads/main.tar.gz | tar xz --strip-components=1 -C ~/.config/opencode/skills/solodit-checklist-audit
```

**Windsurf**
```bash
mkdir -p ~/.codeium/windsurf/skills/solodit-checklist-audit && curl -sL https://github.com/raihanmd/solodit-checklist-audit-skills/archive/refs/heads/main.tar.gz | tar xz --strip-components=1 -C ~/.codeium/windsurf/skills/solodit-checklist-audit
```

**Cursor**

```bash
mkdir -p ~/.cursor/skills/solodit-checklist-audit && curl -sL https://github.com/raihanmd/solodit-checklist-audit-skills/archive/refs/heads/main.tar.gz | tar xz --strip-components=1 -C ~/.cursor/skills/solodit-checklist-audit
```

**Codex CLI**

```bash
mkdir -p ~/.codex/skills/solodit-checklist-audit && curl -sL https://github.com/raihanmd/solodit-checklist-audit-skills/archive/refs/heads/main.tar.gz | tar xz --strip-components=1 -C ~/.codex/skills/solodit-checklist-audit
```

**OpenCode**

```bash
mkdir -p ~/.config/opencode/skills/solodit-checklist-audit && curl -sL https://github.com/raihanmd/solodit-checklist-audit-skills/archive/refs/heads/main.tar.gz | tar xz --strip-components=1 -C ~/.config/opencode/skills/solodit-checklist-audit
```

**Windsurf**

```bash
mkdir -p ~/.codeium/windsurf/skills/solodit-checklist-audit && curl -sL https://github.com/raihanmd/solodit-checklist-audit-skills/archive/refs/heads/main.tar.gz | tar xz --strip-components=1 -C ~/.codeium/windsurf/skills/solodit-checklist-audit
```

### Option 3: Bash Installer

Auto-detects your platform and installs to all detected agents:

```bash
curl -fsSL https://raw.githubusercontent.com/raihanmd/solodit-checklist-audit-skills/main/install.sh | bash
```

## Usage

After installation, open your AI assistant in the Solidity project directory and run:

```
solodit audit on the codebase
```

```
solodit audit on src/protocol/VaultGuardiansBase.sol src/protocol/VaultShares.sol
```

```
solodit audit --output report.md
```

## How It Works

```
┌─────────────────────────────────────────────────────────────┐
│                    Solodit Audit Pipeline                   │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. DISCOVER                                                │
│     - Fetch checklist (online) or use bundled (offline)     │
│     - Find .sol files, read README for context              │
│     - Create .solodit-audit-data/ for progress tracking     │
│                                                             │
│  2. PARSE & GROUP                                           │
│     - 370 items grouped into focused streams (3-15 each)    │
│     - Filter irrelevant categories conservatively           │
│     - Write progress.json for resumable execution           │
│                                                             │
│  3. SPAWN WAVES                                             │
│     - Up to 8 parallel agents per wave                      │
│     - Each agent audits one narrow stream                   │
│     - Progress tracked in .solodit-audit-data/              │
│                                                             │
│  4. CONTINUE AUTOMATICALLY                                  │
│     - No user prompts between waves                         │
│     - Resumes from last checkpoint if interrupted           │
│     - Safety gate: stops if 3 waves produce nothing         │
│                                                             │
│  5. SYNTHESIS & REPORT                                      │
│     - Deduplicate findings by root cause                    │
│     - Severity gate: HIGH / MEDIUM / LOW / INFO             │
│     - Full coverage table (every checklist item)            │
│     - PDF-safe markdown output                              │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

## Checklist Coverage

| Category                | Items   | Focus                                                                                                                                   |
| ----------------------- | ------- | --------------------------------------------------------------------------------------------------------------------------------------- |
| Attacker's Mindset      | 25      | DOS, Donation, Front-running, Griefing, Miner, Price Manipulation, Reentrancy, Replay, Rug Pull, Sandwich, Sybil                        |
| Basics                  | 135     | Access Control, Arrays/Loops, Block Reorg, Events, Functions, Inheritance, Initialization, Maps, Math, Payment, Proxy/Upgradable, Types |
| Centralization Risk     | 7       | Admin powers, key management, upgrade authority                                                                                         |
| Defi                    | 63      | AMM/Swap, Flash Loans, General, Lending, LSD, Oracles, Staking                                                                          |
| External Call           | 14      | Callback safety, return value handling, gas limits                                                                                      |
| Hash / Merkle Tree      | 5       | Hash collisions, Merkle proof verification                                                                                              |
| Heuristics              | 17      | General security patterns and anti-patterns                                                                                             |
| Integrations            | 56      | AAVE, Balancer, Chainlink, Gnosis Safe, LayerZero, Uniswap                                                                              |
| Low Level               | 5       | Assembly, bytecode, Huff-specific vulnerabilities                                                                                       |
| Multi-chain/Cross-chain | 13      | Bridge security, cross-chain message passing                                                                                            |
| Signature               | 5       | Signature replay, malleability, domain separator                                                                                        |
| Timelock                | 1       | Timelock bypass, governance timing                                                                                                      |
| Token                   | 24      | ERC20, ERC721/1155 compatibility                                                                                                        |
| **Total**               | **370** |                                                                                                                                         |

## Tips

- **Target hot contracts.** Point at specific files for faster, denser results.
- **Run after major changes.** Re-run the audit when you change critical logic.
- **Check progress.** The `.solodit-audit-data/progress.json` file shows real-time audit status.

## Project Structure

```
solodit-checklist-audit-skills/
├── SKILL.md              <- Main skill file (loaded by AI agents)
├── VERSION               <- Skill version
├── README.md             <- This file
├── install.sh            <- Bash installer
├── references/
│   ├── checklist.json    <- Bundled 370-item checklist
│   ├── report-template.md
│   └── stream-template.md
└── .github/              <- GitHub OSS infrastructure
    ├── ISSUE_TEMPLATE/
    └── PULL_REQUEST_TEMPLATE.md
```

## Contributing

We welcome improvements and fixes. See [CONTRIBUTING.md](CONTRIBUTING.md) for the PR process.

The most impactful contributions are **new skills** that teach methodology (how to look), not patterns (what to find).

## License

[MIT](LICENSE)

## Acknowledgments

- [Cyfrin](https://cyfrin.io) / [Solodit](https://solodit.xyz) - The audit checklist database
- [Pashov Audit Group](https://github.com/pashov/skills) - Inspiration for multi-agent orchestration patterns
- [Plamen](https://github.com/PlamenTSV/plamen) - Inspiration for progress tracking and resumable pipelines
