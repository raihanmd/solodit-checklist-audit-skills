# Contributing to Solodit Checklist Audit Skills

Thank you for your interest in contributing! This project provides AI agent skills for checklist-driven smart contract security auditing.

## How to Contribute

### Skills (Highest Impact)

The most valuable contributions are **new skills** that teach methodology (how to look), not patterns (what to find).

1. Create a new skill directory with `SKILL.md` and any reference files
2. Write clear orchestration instructions in `SKILL.md`
3. Add reference files under `references/` if needed
4. Update the README.md if adding new capabilities

### Checklist Items

If you find missing checklist items or improvements to existing ones:

1. Open an issue describing the gap or improvement
2. Submit a PR with the updated `checklist.json`
3. Reference any relevant Solodit findings or audit reports

### Bug Fixes

1. Fork the repository
2. Create a branch: `git checkout -b fix/description`
3. Make your changes
4. Run any relevant validation
5. Submit a PR

### Documentation

Improvements to README, setup guides, or platform-specific instructions are always welcome.

## Pull Request Process

1. Update documentation to reflect any changes
2. Update the VERSION file if releasing a new version
3. Add an entry to CHANGELOG.md following [Keep a Changelog](https://keepachangelog.com/) format
4. Ensure your PR description clearly describes the change

## Development Guidelines

- Skills should be **methodology-driven** -- teach the AI how to audit, not what to find
- Keep SKILL.md files under 500 lines for optimal AI consumption
- Use plain ASCII in all output templates (no Unicode decorations)
- Test your skill in at least one AI platform before submitting

## Code of Conduct

This project follows the [Contributor Covenant Code of Conduct](CODE_OF_CONDUCT.md).

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
