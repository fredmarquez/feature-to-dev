#!/usr/bin/env bash
# Usage: render_frames.sh <prototype.html> <out-dir> <state-id> [<state-id>...]
# Renders <out-dir>/<state-id>.png from <prototype>?state=<id>&shot=1 with headless Chrome.
# These are the shared reference frames for the Figma build, the video and screenshots for the user.
# Env: MOBILE=1 (adds &view=mobile, writes <id>-mobile.png) · W/H (window size; default 1440x900, mobile 480x900)
#      CHROME=/path/to/chrome · CHROME_FLAGS="--extra --flags"
set -euo pipefail
[ $# -ge 3 ] || { echo "usage: $0 <prototype.html> <out-dir> <state-id>..." >&2; exit 1; }
HTML=$(cd "$(dirname "$1")" && pwd)/$(basename "$1"); OUTDIR=$2; shift 2
for id in "$@"; do
  [[ "$id" =~ ^[A-Za-z0-9_-]+$ ]] || { echo "error: state IDs must use letters, digits, underscores or hyphens" >&2; exit 1; }
done
mkdir -p "$OUTDIR"
if [ "${MOBILE:-0}" = 1 ]; then W=${W:-480}; H=${H:-900}; VIEW="&view=mobile"; SUF="-mobile"; else W=${W:-1440}; H=${H:-900}; VIEW=""; SUF=""; fi

CH="${CHROME:-}"
if [ -z "$CH" ]; then
  for c in "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" "/Applications/Chromium.app/Contents/MacOS/Chromium" \
           google-chrome google-chrome-stable chromium chromium-browser; do
    if [ -x "$c" ] || command -v "$c" >/dev/null 2>&1; then CH="$c"; break; fi
  done
fi
[ -n "$CH" ] || { echo "error: Chrome not found. Install Chrome or Chromium, or set CHROME=/path/to/chrome" >&2; exit 1; }

EXTRA=()
if [ "$(uname -s)" = Linux ]; then EXTRA+=(--disable-dev-shm-usage);  fi
# shellcheck disable=SC2206
[ -n "${CHROME_FLAGS:-}" ] && EXTRA+=(${CHROME_FLAGS})
LOG=$(mktemp "${TMPDIR:-/tmp}/render_frames.XXXXXX"); trap 'rm -f "$LOG"' EXIT

for id in "$@"; do
  f="$OUTDIR/$id$SUF.png"; rm -f "$f"
  "$CH" --headless=new --disable-gpu --hide-scrollbars --force-device-scale-factor=1 \
    ${EXTRA[@]+"${EXTRA[@]}"} --window-size="$W,$H" --virtual-time-budget=4000 \
    --screenshot="$f" "file://$HTML?state=$id&shot=1$VIEW" >"$LOG" 2>&1 || true
  if [ ! -s "$f" ]; then
    echo "error: Chrome could not render state '$id'." >&2; echo "---- Chrome output ----" >&2; cat "$LOG" >&2; exit 1
  fi
  echo "frame: $f"
done
