Developer clone repo template
   ↓
Config hookPath (gitleaks) trên máy local — 1 lần duy nhất
   ↓
   ├── Không config → commit thiếu trailer
   │                      ↓
   │             Push lên GitHub
   │                      ↓
   │             CI check trailer → missing → ❌ fail → không merge được
   │
   └── Đã config → gitleaks chạy trước mỗi commit
                       ↓
                  Phát hiện secret? → ❌ block commit ngay tại local
                       ↓
                  Clean → commit có trailer → push lên GitHub


─────────────────────────────────────────────────────
PR opened → target: main/master
─────────────────────────────────────────────────────
   ↓
CI: check trailer hợp lệ
   ├── Missing → ❌ fail
   └── OK → tiếp tục
   ↓
CI: trivy fs
   --scanners secret, misconfig, vuln
   --ignore-unfixed
   --severity CRITICAL, HIGH
   ↓
   ├── Secret ở HEAD         → ❌ fail + mail committer & IT team
   ├── CRITICAL/HIGH vuln    → ❌ fail
   ├── CRITICAL/HIGH misconf → ❌ fail
   └── Clean / unfixed only  → ✅ pass
   ↓
Output (luôn chạy dù pass hay fail)
   ├── $GITHUB_STEP_SUMMARY  → full report, từng phần, collapsible
   ├── Mail → committer      → nếu có finding
   └── Mail → IT team        → chỉ khi có secret
   ↓
Merge vào main/master


─────────────────────────────────────────────────────
Repo có build image (opt-in)
─────────────────────────────────────────────────────
   ↓
workflow build riêng của repo
   ↓
Build image → push lên GHCR
   ↓
Gọi reusable workflow: org/.github/trivy-image-scan.yml
   ↓
trivy image ghcr.io/org/image:sha
   --scanners vuln
   --ignore-unfixed
   --severity CRITICAL, HIGH
   ↓
   ├── CRITICAL/HIGH vuln → ❌ fail + mail committer
   └── Clean              → ✅ pass