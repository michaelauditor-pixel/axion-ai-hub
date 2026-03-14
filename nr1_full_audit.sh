set -euo pipefail

BASE="/opt/nr1corporativo"
OUTDIR="/root/nr1_audit_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$OUTDIR"

echo "== NR1 AUDIT ==" | tee "$OUTDIR/00_header.txt"
date | tee -a "$OUTDIR/00_header.txt"
hostname | tee -a "$OUTDIR/00_header.txt"
whoami | tee -a "$OUTDIR/00_header.txt"
echo "BASE=$BASE" | tee -a "$OUTDIR/00_header.txt"
echo >> "$OUTDIR/00_header.txt"

{
  echo "=== SYSTEM ==="
  uname -a
  echo
  echo "=== UPTIME ==="
  uptime
  echo
  echo "=== MEMORY ==="
  free -h
  echo
  echo "=== DISK ==="
  df -h
} > "$OUTDIR/01_system.txt"

{
  echo "=== PORTS ==="
  ss -ltnp || netstat -ltnp || true
  echo
  echo "=== UVICORN / PYTHON ==="
  ps aux | grep -Ei "uvicorn|python" | grep -v grep || true
  echo
  echo "=== DOCKER PS ==="
  docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" 2>/dev/null || true
  echo
  echo "=== DOCKER COMPOSE CANDIDATES ==="
  find /opt -maxdepth 4 \( -name "docker-compose.yml" -o -name "compose.yml" -o -name "docker-compose.yaml" \) 2>/dev/null | sort || true
} > "$OUTDIR/02_runtime.txt"

{
  echo "=== PROJECT ROOT ==="
  ls -lah "$BASE" || true
  echo
  echo "=== APP TREE (depth 4) ==="
  find "$BASE/app" -maxdepth 4 -type f 2>/dev/null | sort || true
  echo
  echo "=== STATIC TREE ==="
  find "$BASE/app/static" -maxdepth 4 -type f 2>/dev/null | sort || true
  echo
  echo "=== ROUTES TREE ==="
  find "$BASE/app/routes" -maxdepth 3 -type f 2>/dev/null | sort || true
} > "$OUTDIR/03_project_tree.txt"

{
  echo "=== GIT STATUS ==="
  cd "$BASE" 2>/dev/null && git status --short && echo && git branch && echo && git log --oneline -n 20 || true
} > "$OUTDIR/04_git.txt"

{
  echo "=== PYTHON FILES WITH FastAPI/APIRouter ==="
  grep -RniE "FastAPI|APIRouter|include_router|@router.get|@router.post|@app.get|@app.post" "$BASE/app" 2>/dev/null || true
} > "$OUTDIR/05_routes_index.txt"

python3 <<'PY' > "$OUTDIR/06_main_candidates.txt"
from pathlib import Path
base = Path("/opt/nr1corporativo/app")
for p in sorted(base.rglob("main.py")):
    print(f"=== FILE: {p} ===")
    try:
        txt = p.read_text(encoding="utf-8", errors="ignore")
        for i, line in enumerate(txt.splitlines(), 1):
            if "FastAPI(" in line or "include_router(" in line or "from app.routes" in line:
                print(f"{i:04d}: {line}")
    except Exception as e:
        print("ERROR:", e)
    print()
PY

{
  echo "=== ENV / SECRETS NAMES ONLY ==="
  find "$BASE" -maxdepth 4 \( -name ".env" -o -name "*.env" -o -name ".secrets" -o -name "*.ini" -o -name "*.yaml" -o -name "*.yml" \) 2>/dev/null | sort | while read -r f; do
    echo "--- $f ---"
    grep -E '^[A-Za-z_][A-Za-z0-9_]*=' "$f" 2>/dev/null | sed 's/=.*$/=***REDACTED***/' || true
    echo
  done
} > "$OUTDIR/07_env_names.txt"

{
  echo "=== API LOG TAIL ==="
  tail -n 200 "$BASE/api.log" 2>/dev/null || true
} > "$OUTDIR/08_api_log_tail.txt"

{
  echo "=== HEALTH CHECK ==="
  curl -sS http://127.0.0.1:8011/health || true
  echo
  echo
  echo "=== COMMAND CENTER ==="
  curl -I -sS http://127.0.0.1:8011/command-center-v3 || true
  echo
  echo "=== SNAPSHOT ==="
  curl -I -sS http://127.0.0.1:8011/dashboard-snapshot/enterprise || true
  echo
  echo "=== ALERT STREAM ==="
  curl -I -sS http://127.0.0.1:8011/alerts/stream || true
  echo
  echo "=== MARKET STATS ==="
  curl -I -sS http://127.0.0.1:8011/market/stats || true
  echo
  echo "=== MAP GRID ==="
  curl -I -sS http://127.0.0.1:8011/map/grid || true
} > "$OUTDIR/09_http_checks.txt"

python3 <<'PY' > "$OUTDIR/10_dashboard_summary.txt"
from pathlib import Path
import re, json

base = Path("/opt/nr1corporativo")
summary = {}

summary["project_exists"] = base.exists()
summary["routes_dir_exists"] = (base / "app/routes").exists()
summary["static_img_exists"] = (base / "app/static/img").exists()

imgs = []
imgdir = base / "app/static/img"
if imgdir.exists():
    imgs = sorted([p.name for p in imgdir.iterdir() if p.is_file()])
summary["static_images"] = imgs

main_candidates = sorted((base / "app").rglob("main.py"))
summary["main_candidates"] = [str(p) for p in main_candidates]

route_files = sorted((base / "app/routes").glob("*.py")) if (base / "app/routes").exists() else []
summary["route_files"] = [p.name for p in route_files]

endpoints = {}
for rf in route_files:
    txt = rf.read_text(encoding="utf-8", errors="ignore")
    hits = re.findall(r'@(?:router|app)\.(get|post|put|delete)\("([^"]+)"', txt)
    if hits:
        endpoints[rf.name] = [{"method": m.upper(), "path": p} for m,p in hits]
summary["endpoints"] = endpoints

print(json.dumps(summary, indent=2, ensure_ascii=False))
PY

cat > "$OUTDIR/99_EXEC_SUMMARY.txt" <<'EOF'
NR1 AUDIT EXEC SUMMARY
=====================

Leia primeiro estes arquivos:
- 10_dashboard_summary.txt
- 09_http_checks.txt
- 06_main_candidates.txt
- 08_api_log_tail.txt
- 07_env_names.txt

Objetivo:
1. descobrir qual main.py está ativo
2. descobrir quais routers estão registrados
3. confirmar quais endpoints funcionam
4. confirmar assets do dashboard
5. identificar gaps para próximos passos
EOF

tar -czf "${OUTDIR}.tar.gz" -C /root "$(basename "$OUTDIR")"

echo
echo "AUDIT_DIR=$OUTDIR"
echo "AUDIT_TAR=${OUTDIR}.tar.gz"
echo
echo "===== QUICK SUMMARY ====="
cat "$OUTDIR/10_dashboard_summary.txt"
echo
echo "===== HTTP CHECKS ====="
cat "$OUTDIR/09_http_checks.txt"
