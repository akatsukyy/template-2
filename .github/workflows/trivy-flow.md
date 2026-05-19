# Trivy Security Scan — PR Flow

## Trigger
- PR opened → target: `main` / `master`

---

## Steps

### 1. Checkout
- `fetch-depth: 1` — full history no longer needed

### 2. Helm Dependency Update
- Runs only if `Chart.yaml` exists in the repository

### 3. Install Trivy

---

## Head Scan

```bash
trivy fs . \
  --scanners secret,misconfig,vuln \
  --ignore-unfixed \
  --severity CRITICAL,HIGH \
  --file-patterns "dockerfile:.*[Dd]ockerfile.*"
```

---

## Evaluate

| Finding | Result |
|---|---|
| Secret found | ❌ Fail + mail committer & IT team |
| CRITICAL/HIGH vuln (fixable) | ❌ Fail |
| CRITICAL/HIGH misconfig (fixable) | ❌ Fail |
| Nothing found / unfixed only | ✅ Pass |

---

## Output *(always runs)*

| Destination | Condition | Content |
|---|---|---|
| `$GITHUB_STEP_SUMMARY` | Always | Full report, per section |
| Mail committer | Any finding exists | Findings summary |
| Mail IT team | Secret found only | No summary logged |