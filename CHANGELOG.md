# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [2.0.0] - 2026-05-16

### Major Changes

- **Updated checklist from 212 to 370 items** - now covers all 13 categories from the Cyfrin audit-checklist repo
- **Online-first with offline fallback** - fetches latest checklist from GitHub at runtime, falls back to bundled 370-item JSON if offline
- **Progress persistence** - `.solodit-audit-data/progress.json` survives agent restarts, enabling resumable audits
- **Bundle-based context loading** - source code and stream instructions written to files instead of inlined into prompts
- **Deterministic wave loop** - progress tracker gates wave spawning, eliminating unreliable self-motivation loop from v1
- **Multi-platform install** - install.sh auto-detects Claude Code, OpenCode, Cursor, Codex CLI, and Windsurf
- **npx skills add support** - primary install method via `npx skills add raihanmd/solodit-checklist-audit-skills`

### New Files

- `references/checklist.json` - bundled 370-item checklist (compressed, flattened)
- `references/checklist-schema.md` - schema documentation for AI agents
- `references/report-template.md` - standardized audit report template
- `references/stream-template.md` - sub-agent prompt template
- `install.sh` - auto-detecting installer

### Removed

- `references/checklist-index.json` - replaced by new `checklist.json` format
- `setup-prompts/` - consolidated into README.md manual install section
- `detect-platform.sh` - platform detection integrated into install.sh

### Breaking Changes

- Progress data now stored in `.solodit-audit-data/` instead of `/tmp/`
- Checklist JSON structure changed from flat array to object with `items`, `categories`, and metadata fields
- SKILL.md moved to repo root for `npx skills add` compatibility

## [1.0.0] - Previous Version

- Initial release with 212 checklist items
- 8-turn orchestration with wave-based agent spawning
- Remote checklist fetch at runtime
- OpenCode-only installation
