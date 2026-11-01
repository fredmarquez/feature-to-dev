# Prototype conventions

## Base
- Start from the profile's reusable HTML base. That can be a design-tool HTML export of an artboard, the HTML behind the Figma file, a saved page of the live app, or the repo's built CSS and tokens. Copy its `<style>` block and root markup, drop any framework wrapper (`<x-dc>`, support.js, React roots) and keep plain HTML, CSS and inline SVG.
- With no HTML base, rebuild the screen from Figma `get_design_context` and `get_variable_defs`, or from the tokens file.
- Keep the real tokens, radii, shadows and font. Only invent a value when no token fits, and list it as a design choice you made.
- Use a fixed artboard size (e.g. 1440×900) and scale it to fit the window with `transform: scale()`. Keep a global `scale` variable, because menu positioning has to divide `getBoundingClientRect` values by it.

## Structure
```js
const DATA = {...};           // content, models, items
let S = fresh();              // all UI state in one object
function render(){ stage.innerHTML = view(); fit(); renderOverlays(); }
document.addEventListener('click', e => { const a = e.target.closest('[data-act]'); ... }); // delegated actions
```
- Every interactive element has a `data-act`, and that one delegated listener handles it. This makes the tour script and debugging trivial.
- Popovers live in an absolutely positioned overlay layer inside the frame, not inside scroll containers, which would clip them. Open them above the anchor when it sits in the lower half of the frame.
- Tooltips: `[data-tip]:hover::after` in CSS. Add an equivalent `.tipon::after` rule so the video can force them visible.
- Simulate async with `setTimeout` (e.g. a ~1.5s loading state).
- **URL jumps:** `?state=<id>` sets the state object directly (no click replay); `&shot=1` hides the chrome and fixes scale at 1; `&view=mobile` shows the mobile frame. List the ids in the notes panel. `scripts/render_frames.sh` renders `frames/<id>.png` from these at approval.
- **Keep `S`, `render`, `fit` and `scale` as top-level globals** (`let` / `function` in a classic `<script>`, not a module or a wrapping function). The tour script and the frame renderer reach into them; inside a module they're invisible and the tour silently shows the default state.

## When it grows
Past ~1,500 lines, or once there's a second revision, split the source: `src/proto.js`, `src/extra.css`, `src/notes.html` and a small build script (`src/build.py` or `build.js`) that inlines them into the single `<slug>.html`. The output stays one self-contained file. For a revision the user may want to compare, add an override file (`src/v2.js`) instead of editing the base.

## Previewing
Open it through a local static server. If one server type can't read the folder (sandboxed folder access, for instance), try another (`python3 -m http.server`, `npx serve`). If the user can't view HTML where they are, send a labelled PNG of all frames.

## Chrome outside the design
A sticky top bar that is clearly not part of the design:
- view switch (Desktop / Mobile)
- toggles for rule-driven states (e.g. "First 5 / After 5")
- Reset
- "Spec & open questions" panel with: what you're looking at (numbered), copy (all languages), and "Calls I made: confirm or change"

## Mobile
A separate 390×844 frame in a phone bezel, scaled to the window height. Replace hover affordances with labelled buttons, and turn side-by-side layouts into tabs with swipe.

## Self-check before handing over
Open it in the browser and click through every state. Check:
- popovers open in the right place
- tooltips appear
- the expand/collapse layout holds
- the mobile view scales
- the console has no errors

Then send it to the user rendered inline.
