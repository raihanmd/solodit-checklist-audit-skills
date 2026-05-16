# Solodit Checklist Audit Report

## Protocol: {protocol name from README}

## Date: {current date}

## Checklist Version: {version from checklist.json}

## Coverage: {N}/{total} items evaluated

---

## Summary

| Severity           | Count   |
| ------------------ | ------- |
| HIGH               | {n}     |
| MEDIUM             | {n}     |
| LOW                | {n}     |
| INFO               | {n}     |
| **Total Findings** | **{n}** |

---

## HIGH Severity Findings

### [HIGH-1] - {Title}

- **Checklist IDs:** {SOL-XXX-1, SOL-XXX-2}
- **Affected Contracts:** {Contract.sol}
- **Description:** {detailed description}
- **Impact:** {what can go wrong}
- **Code:** {file:line} - {snippet}
- **Attack Scenario:** {step by step}
- **Recommended Fix:** {specific fix}

---

## Coverage Appendix

| Checklist ID  | Category           | Question                              | Status           |
| ------------- | ------------------ | ------------------------------------- | ---------------- |
| SOL-AM-DOSA-1 | Attacker's Mindset | Is the withdrawal pattern followed... | FINDING (MEDIUM) |
| SOL-AM-DOSA-2 | Attacker's Mindset | Is there a minimum transaction...     | PASS             |
| ...           | ...                | ...                                   | ...              |
