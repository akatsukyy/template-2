PR opened → target: main / master
   ↓
Checkout (fetch-depth: 1)        ← không cần full history nữa
   ↓
Helm dependency update (nếu có Chart.yaml)
   ↓
Install Trivy
   ↓
── HEAD SCAN ──────────────────────────────────────────────
   ↓
trivy fs . --scanners secret,misconfig,vuln
           --ignore-unfixed
           --severity CRITICAL,HIGH
           --file-patterns "dockerfile:.*[Dd]ockerfile.*"
   ↓
── EVALUATE ───────────────────────────────────────────────
   ↓
   ├── Secret?              → ❌ Fail + mail committer & IT team
   ├── CRITICAL/HIGH vuln (có fix)?   → ❌ Fail
   ├── CRITICAL/HIGH misconfig (có fix)? → ❌ Fail
   └── Không có gì / chỉ unfixed   → ✅ Pass
   ↓
── OUTPUT (luôn chạy) ─────────────────────────────────────
   ↓
   ├── $GITHUB_STEP_SUMMARY  → full report, từng phần
   ├── Mail committer        → khi có bất kỳ finding nào
   └── Mail IT team          → chỉ khi có secret, không log summary