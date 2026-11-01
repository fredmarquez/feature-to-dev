# Walkthrough video

The video is made from crisp captioned stills joined with crossfades. A live screen recording would be shakier and harder to reproduce, and stills re-render in seconds when the design changes.

## 1. Tour page
1. Copy the prototype to a scratch folder as `tour.html` and inject `<script src="tour.js"></script>` before `</body>`.
2. Copy `assets/tour-template.js` to `tour.js`, set the `BRAND` colours and font from the profile's video branding, and fill in `STEPS`. Each step is one of two kinds:
   - `{card:'intro'|'outro'}` for a title card or rules recap. Edit the card HTML.
   - `{cap:[title, subtitle], setup(){...}, target:'css selector', tip:true, hover:'selector', menu:true, scroll:..., mobile:true}`
3. `setup()` **sets the state directly** (e.g. `S.panel='open'; S.items[2].status='error'`) instead of replaying clicks. That makes every step reproducible on its own.

## 2. Render
```bash
scripts/render_walkthrough.sh <tour-dir> <step-count> <out.mp4> [width] [height]
```
Set `CHROME=/path/to/chrome` if Chrome isn't found automatically. Chrome sandboxing stays enabled: run as a non-root user. Extra flags go in `CHROME_FLAGS`; do not use them to disable security protections. If a capture fails, the script prints Chrome's own output and stops. Shorter holds for a user-facing demo: `HOLD=3.2 CARD=4`. This captures `s00.png … sNN.png` with headless Chrome (default 1480×1040). It holds cards for 4.5s and content steps for 3.8s, joins them with 0.5s crossfades, and writes an H.264 MP4. It also writes `contact.png`, a grid of all frames.

## 3. Check the contact sheet before sending
Look at it. Is every popover visible? Is every cursor on its target? Is any text wrapping? A red "MISSING target" banner means a step's selector matched nothing: fix the selector or the step's `setup()`.

## No Chrome or ffmpeg?
Say so in one line, then hand over `tour.html` with its folder: opening `tour.html?step=0&play=1` plays every step on its own with the same timings, ready for a screen recording.

## Known headless traps (each already fixed in the template)
- **Resize after load.** New headless Chrome lays the page out at a smaller viewport, then resizes. That triggers the prototype's resize handler, which may close popovers and change the scale. The template:
  - forces `scale=1` by overriding `fit`
  - blocks resize events with a capturing listener
  - waits for `document.fonts.ready` plus 700ms
  - locks popover state with `Object.defineProperty`
- **Cursor drift.** Position the cursor and ring `absolute`, not `fixed`, and compute positions after the wait.
- **Hover-only states** (tooltips, hovered rows) don't exist headless. Use the `.tipon` and `.hov` classes.

Captions should say what happens and the rule behind it, in one line each. Devs watch these without sound.
