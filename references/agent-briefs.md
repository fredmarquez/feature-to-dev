# Sub-agent briefs

Copy a brief, then fill in the `<…>` placeholders. All of them run in the background unless your next step depends on the result.

## Design-system inspection (read-only, general-purpose)
Adapt the source to the profile: a Figma file (below), a tokens file, Storybook, or the repo's styles and components. Keep the same report.
> Read-only inspection of Figma file `<file key>`. Do NOT modify anything. Follow the Figma connector's own instructions (session setup, required skills) before the first call, and use only its read tools (screenshots, metadata, design context, variables). Also read `<build contract / handoff doc>` and skim `<source artboards folder>`.
> I'm about to build an HTML mockup of `<feature>` inside `<screen>`. Inspect `<node ids>` and any menus or pickers. Save screenshots to `<scratch>/figma/`.
> Report concisely (<700 words):
> 1. Base screen layout: widths, columns, header, message or content styles, type, colours, spacing.
> 2. The canonical order and sizes of repeated elements (action rows etc.), noting conflicts between frames.
> 3. Inputs and form controls.
> 4. Existing menu/picker styles.
> 5. Tokens.
> 6. Which HTML source files to reuse as a base, and how self-contained they are.

## Codebase exploration (Explore agent, medium-thorough)
> Codebase at `<path>` (if it's a zip, unzip it to the scratchpad first). Read CLAUDE.md/AGENTS.md/README/docs first, and note the domain glossary and ADRs. I'm writing a spec for `<feature summary>`.
> Report with file paths (<900 words):
> 1. Glossary terms and relevant ADRs.
> 2. The request path for the core action (routes, services, validation that could block the feature).
> 3. The data model for the entities involved, including dormant or planned structures.
> 4. The UI components involved.
> 5. Config or catalogue sources.
> 6. Per-user settings, counter and feature-flag storage.
> 7. Test setup and prior-art tests.
> 8. Any existing similar logic (suggestions, classifiers, etc.).
> 9. The repo's spec convention: where design specs live (e.g. `docs/specs/`, `rfcs/`), the filename pattern, the language, and the section headings of the 1–2 most recent specs.

## Pattern research (general-purpose, background, web access)
> Research how established products handle `<pattern, e.g. snoozing an item>` for `<product, one line>`. Read `references/accessibility.md` (section 1 and the checklist) first.
> Report with a source link on every line (<600 words):
> 1. How 3 to 5 well-regarded products handle it: entry point, defaults, undo, empty and error states. Mark what they agree on (convention) and where they differ (a real decision).
> 2. The accessibility requirements this pattern raises, from the checklist, stated for this feature.
> 3. Known pitfalls from reviews, forums or support pages.
> Facts only; no recommendation on what our product should do.

## Accessibility review (general-purpose, before validation)
> Review the prototype `<slug>.html` (states: `<?state= ids>`) against the checklist in `references/accessibility.md`. Use the frames in `<frames/>` or render states with `scripts/render_frames.sh`; check colour pairs from the tokens with `scripts/contrast.py`; read the markup for names, roles, focus handling and live regions.
> Report (<500 words), most severe first: each issue with the state, the element, the WCAG reference, and a concrete fix in the prototype's own terms (token, markup, behaviour). Then list what passes in one line. No issues found is a valid answer; don't pad.

## Figma build (general-purpose, background)
> Build `<feature>` into Figma file `<key>`.
> - **Setup:** follow the Figma connector's own instructions before any call (session setup, the skills it requires before writing). They change over time, so follow what the connector says today rather than a fixed tool list. Read `<build contract>`.
> - **Protection (non-negotiable):** `<paste the profile's Figma protection block verbatim>`. You may write ONLY inside the write zone; every other page, library component, variable and style is read-only, even if it looks unowned. First list all pages (some read tools return an incomplete list; use the plugin API's `figma.root.children`) and save that list as a snapshot. Before each write call, confirm the target page is still in the write zone; if not, STOP and report. Instance existing components (`<ids>`), bind variables by name, one setCurrentPageAsync per call, don't modify or delete existing screens, and literal hex is OK only for brand marks.
> - **Source of truth:** `<prototype.html>`, plus the reference renders in `<feature-folder>/frames/` (one PNG per state, rendered at approval). Replicate the copy, sizes and colours exactly.
> - **Key design facts:** `<paste the spec: the component specs and copy>`.
> - **Screens:** a new page "`<Feature>`" placed after `<section>`, frames `<PREFIX>-01…NN` (listed with one-line intent). Lay them out left to right in flow order with ~200px gaps, each with a title and a one-line note above it. Connect them with labelled flow arrows, and put a rules annotation at the start of the page.
> - **Verify:** screenshot each frame and compare it with its PNG in `frames/`; fix issues.
> - **Component gaps:** don't edit library components, variables or styles. Build a local component or wrapper on the feature page and list it as a deviation.
> - **Final check:** re-list pages and compare with the snapshot (names, order, count). Account for explicitly authorized new pages; existing page names and relative order must remain unchanged. Report any other difference and confirm zero edits outside the write zone.
> - **Report** (<400 words): page id, frame ids and names, deviations/gaps.

When the report lists deviations (missing component slots, local wrappers), bring them to the user. Follow-up fixes go to the **same** agent so it keeps its context. Changing anything outside the write zone needs an exception in the profile's protection block and the user's yes for that specific change; then prefer adding a property or variant over detaching, and check that an existing screen using the component still renders.
