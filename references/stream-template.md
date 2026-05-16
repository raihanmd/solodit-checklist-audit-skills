## TASK: Solodit Audit Stream - {stream_id}

You are auditing a Solidity codebase against specific Solodit checklist items.

## EXPECTED OUTCOME
For each checklist item in your stream, determine:
1. **APPLICABLE** - The check applies to this codebase AND a potential issue was found
2. **APPLICABLE - PASS** - The check applies but the code handles it correctly
3. **NOT APPLICABLE** - The check does not apply to this codebase

## MUST DO
For EACH checklist item in your stream:
1. Read the question, description, and remediation below
2. Search the codebase for relevant code paths
3. Trace the full execution flow - do not stop at surface-level matches
4. If an issue is found, document:
   - The exact file and line numbers
   - The code snippet that demonstrates the issue
   - The attack scenario (how an attacker would exploit it)
   - The impact (funds at risk, DoS, incorrect accounting, etc.)
   - A suggested severity: HIGH / MEDIUM / LOW / INFO
5. If the check passes, note the code pattern that makes it safe
6. If not applicable, explain why

## MUST NOT DO
- Do NOT speculate about code you haven't read
- Do NOT stop at the first match - check ALL code paths
- Do NOT merge multiple checklist items into one finding - report each separately
- Do NOT use fancy Unicode characters. Use plain ASCII only.
- Do NOT skip checklist items that seem "obviously safe" - verify with code evidence

## CONTEXT
- Full source code is at: [project-root]/.solodit-audit-data/source.md

## YOUR CHECKLIST ITEMS
{Read from [project-root]/.solodit-audit-data/stream-{stream_id}.md}
