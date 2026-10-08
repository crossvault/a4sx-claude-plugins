#!/usr/bin/env bash
# Validate the marketplace and the plugin. CI runs this same script.
#
#   1. A basic check that needs only python3: every manifest is valid JSON, the required fields are
#      set, and the marketplace entry and plugin.json agree on the name.
#   2. `claude plugin validate --strict` on the marketplace and on the plugin (the official check).
#      Skipped with a notice when `claude` is not installed, unless REQUIRE_CLAUDE=1 (as in CI).
set -euo pipefail
cd "$(dirname "$0")/.."

echo "== basic manifest check"
python3 - <<'PY'
import json, pathlib, re, sys

def load(path):
    try:
        return json.loads(pathlib.Path(path).read_text(encoding="utf-8"))
    except Exception as e:
        sys.exit(f"FAIL {path}: {e}")

errors = []
mkt = load(".claude-plugin/marketplace.json")
for key in ("name", "owner", "plugins"):
    if key not in mkt:
        errors.append(f"marketplace.json: missing '{key}'")
if not (mkt.get("owner") or {}).get("name"):
    errors.append("marketplace.json: owner.name is required")

for i, entry in enumerate(mkt.get("plugins") or []):
    name, src = entry.get("name"), entry.get("source")
    if not name or not src:
        errors.append(f"marketplace.json plugins[{i}]: 'name' and 'source' are required")
        continue
    if not isinstance(src, str) or not src.startswith("./") or ".." in src:
        errors.append(f"plugins[{i}]: source must be a './' path inside the repo")
        continue
    root = pathlib.Path(src)
    man = load(root / ".claude-plugin" / "plugin.json")
    if man.get("name") != name:
        errors.append(f"plugins[{i}]: entry name {name!r} != plugin.json name {man.get('name')!r}")
    for key in ("version", "description", "author"):
        if not man.get(key):
            errors.append(f"{root}/.claude-plugin/plugin.json: missing '{key}'")
    mcp_path = root / ".mcp.json"
    if mcp_path.exists():
        servers = load(mcp_path).get("mcpServers") or {}
        for sname, cfg in servers.items():
            if cfg.get("type") == "http" and not str(cfg.get("url", "")).startswith("https://"):
                errors.append(f"{mcp_path}: server {sname!r} must use an https:// url")
            if cfg.get("headers"):
                errors.append(f"{mcp_path}: server {sname!r} must not carry headers (no credentials in files)")
    for skill in sorted((root / "skills").glob("*/SKILL.md")):
        text = skill.read_text(encoding="utf-8")
        m = re.match(r"^---\n(.*?)\n---\n", text, re.S)
        if not m or not re.search(r"^description:\s*\S", m.group(1), re.M):
            errors.append(f"{skill}: needs YAML frontmatter with a description")

if errors:
    print("\n".join("FAIL " + e for e in errors))
    sys.exit(1)
print("ok")
PY

if command -v claude >/dev/null 2>&1; then
  echo "== claude plugin validate --strict . (marketplace)"
  claude plugin validate --strict .
  for dir in plugins/*/; do
    echo "== claude plugin validate --strict ${dir%/}"
    claude plugin validate --strict "${dir%/}"
  done
elif [ "${REQUIRE_CLAUDE:-0}" = "1" ]; then
  echo "FAIL: claude is not installed (REQUIRE_CLAUDE=1)" >&2
  exit 1
else
  echo "== skipped claude plugin validate: the claude CLI is not installed"
fi
echo "== all checks passed"
