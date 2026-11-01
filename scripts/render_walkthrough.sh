#!/usr/bin/env bash
# Usage: render_walkthrough.sh <tour-dir containing tour.html> <step-count> <out.mp4> [width=1480] [height=1040]
# First and last steps are treated as title cards (held longer).
# Env: CHROME=/path/to/chrome · HOLD=3.8 (seconds per step) · CARD=4.5 (seconds per title card) · FADE=0.5
#      CHROME_FLAGS="--extra --flags" (appended to every Chrome call)
set -euo pipefail
[ $# -ge 3 ] || { echo "usage: $0 <tour-dir> <step-count> <out.mp4> [width] [height]" >&2; exit 1; }
[[ "$2" =~ ^[1-9][0-9]*$ ]] && [ "$2" -le 200 ] || { echo "error: step-count must be 1 through 200" >&2; exit 1; }
DIR=$(cd "$1" && pwd); N=$2; OUT=$3; W=${4:-1480}; H=${5:-1040}
HOLD=${HOLD:-3.8}; CARD=${CARD:-4.5}; FADE=${FADE:-0.5}
OS=$(uname -s)

CH="${CHROME:-}"
if [ -z "$CH" ]; then
  for c in "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" "/Applications/Chromium.app/Contents/MacOS/Chromium" \
           google-chrome google-chrome-stable chromium chromium-browser; do
    if [ -x "$c" ] || command -v "$c" >/dev/null 2>&1; then CH="$c"; break; fi
  done
fi
[ -n "$CH" ] || { echo "error: Chrome not found. Install Chrome or Chromium, or set CHROME=/path/to/chrome" >&2; exit 1; }
command -v ffmpeg >/dev/null || { echo "error: ffmpeg is required (macOS: brew install ffmpeg · Debian/Ubuntu: apt install ffmpeg)" >&2; exit 1; }

# Keep Chrome sandboxing enabled; run as a non-root user.
EXTRA=()
if [ "$OS" = Linux ]; then
  EXTRA+=(--disable-dev-shm-usage)
fi
# shellcheck disable=SC2206
[ -n "${CHROME_FLAGS:-}" ] && EXTRA+=(${CHROME_FLAGS})

LOG=$(mktemp "${TMPDIR:-/tmp}/render_walkthrough.XXXXXX")
trap 'rm -f "$LOG"' EXIT

capture() { # $1 = step, $2 = output png
  "$CH" --headless=new --disable-gpu --hide-scrollbars --force-device-scale-factor=1 \
    ${EXTRA[@]+"${EXTRA[@]}"} --window-size="$W,$H" --virtual-time-budget=6000 \
    --screenshot="$2" "file://$DIR/tour.html?step=$1" >"$LOG" 2>&1
}

last=$((N-1))
for i in $(seq 0 $last); do
  f="$DIR/s$(printf %02d "$i").png"
  rm -f "$f"
  if ! capture "$i" "$f" || [ ! -s "$f" ]; then
    if [ ! -s "$f" ]; then
      echo "error: Chrome could not capture step $i ($CH)." >&2
      echo "---- Chrome output ----" >&2; cat "$LOG" >&2; echo "-----------------------" >&2
      exit 1
    fi
  fi
  echo "captured $f"
done

args=(); durs=()
for i in $(seq 0 $last); do d=$HOLD; { [ "$i" -eq 0 ] || [ "$i" -eq $last ]; } && d=$CARD; durs+=("$d"); args+=(-loop 1 -t "$d" -i "$DIR/s$(printf %02d "$i").png"); done
f=""; prev="0:v"; acc=${durs[0]}
for i in $(seq 1 $last); do
  off=$(awk -v a="$acc" -v f="$FADE" -v i="$i" 'BEGIN{printf "%.2f", a-f*i}')
  f+="[$prev][$i:v]xfade=transition=fade:duration=$FADE:offset=$off[v$i];"; prev="v$i"
  acc=$(awk -v a="$acc" -v d="${durs[$i]}" 'BEGIN{print a+d}')
done
ffmpeg -y -loglevel error "${args[@]}" -filter_complex "${f}[$prev]format=yuv420p[out]" -map "[out]" -r 30 -c:v libx264 -crf 20 -movflags +faststart "$OUT"

# contact sheet (2 columns) for a visual check
inputs=(); fs=""; cols=""; TH=$(( (740*H/W) / 2 * 2 ))  # fixed, even tile height so xstack sizes always match
for i in $(seq 0 $last); do inputs+=(-i "$DIR/s$(printf %02d "$i").png"); fs+="[$i]scale=740:$TH[p$i];"; cols+="[p$i]"; done
N2=$N
if [ $((N%2)) -eq 1 ]; then inputs+=(-f lavfi -i "color=c=black:s=740x$TH"); cols+="[$N]"; N2=$((N+1)); fi
ffmpeg -y -loglevel error "${inputs[@]}" -filter_complex "${fs}${cols}xstack=inputs=$N2:grid=2x$((N2/2))" -frames:v 1 -update 1 "$DIR/contact.png" \
  || echo "warning: contact sheet failed (the video is fine)" >&2

echo "video: $OUT"; echo "contact sheet: $DIR/contact.png"
ffprobe -v error -show_entries format=duration -of csv=p=0 "$OUT"
