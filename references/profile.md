# Project profile

Everything project-specific lives in one file at the project root: **`feature-to-dev.profile.md`**. The skill itself stays generic. Read the profile at stage 0 and let it override the defaults in every reference.

## Finding it
1. Look for `feature-to-dev.profile.md` in the working directory, then in its parents.
2. If there is none, fill in only what the stages you're about to run need. Get the facts yourself (README, docs, the Figma file, the repo) and ask only for what you can't find: ticket language, tracker, who owns which screens. A single-stage request (just a grill, one ticket + spec) doesn't need a saved profile. Once the work spans several stages or sessions, show the draft, save it after the user's OK, and mention that it can be edited at any time.
3. **Figma protection** is a decision, not a fact: if the project uses Figma and that block is missing or vague, put it to the user (with the allow-list default as your recommendation) before any Figma write. Re-confirm it whenever a feature page or the file's structure changed since it was written.
4. If an item doesn't apply (no Figma, no codebase yet), write `none`. The matching stage is skipped or swapped, as noted below.

## Template

```markdown
# feature-to-dev profile: <Project name>

## Product
- What it is: <one line>
- Languages shipped (UI copy): <e.g. FR, EN>
- Platforms: <desktop web, mobile web, iOS…>

## Design system
- Source of truth: <Figma file key | tokens file | Storybook URL | the app's own CSS | none>
- Build contract / handoff doc: <path or none>
- Reusable HTML base for prototypes: <path to source artboards, an exported screen, or the live app's built CSS>
- Font, brand colours: <e.g. <font> · <primary hex>>
- Tool quirks: <e.g. how to list all pages in the design file>

### Figma protection (required before any Figma write)
Allow-list, not block-list: anything not in "Write zone" is read-only, including pages created later.
- Write zone: <only pages this skill creates, named e.g. "Feature - <name>", plus their local-components page>
- Never edit (read-only, by name pattern): <e.g. pages "Final - *", "Design system", "Components"; any page whose owner is someone else>
- Library: <published components, component sets, variables/tokens, text and colour styles: never edited | edit with <role>'s OK>
- Gaps in a component: <report as a deviation and build a local copy on the feature page (default)>
- Exceptions: <specific nodes that may be edited with <role>'s OK, or none>

## Codebase
- Location: <repo path | zip path (unzip to scratchpad) | none>
- Read first: <glossary, ADR folder, AGENTS.md…>
- Spec convention: <folder + filename pattern + language, e.g. docs/specs/YYYY-MM-DD-<slug>.md, EN> (leave blank to discover)

## Outputs
- Feature folder: <where <slug>/ folders go, default: project root>
- Ticket language: <FR | EN | …>
- Ticket headings (optional, in that language): <Title / Context / Goal / Scope / Acceptance criteria / Open questions / Detailed spec>
- Tracker: <local only | ClickUp list X | Linear team Y | GitHub repo Z>. Posting always needs confirmation.
- Definition of done (copied into every ticket):
  - [ ] <e.g. Unit tests at the agreed test points pass in CI>
  - [ ] <e.g. Code reviewed and merged behind a feature flag>
  - [ ] <e.g. Copy in every shipped language, reviewed by a native speaker>
  - [ ] <e.g. Keyboard and screen reader pass on the acceptance criteria>
  - [ ] <e.g. Design QA against the prototype frames on desktop and mobile>
  - [ ] <e.g. Glossary, ADRs or docs updated if the feature changed them>
- Outputs wanted by default: <prototype, Figma, video, ticket+spec>

## Video branding
- Caption bar bg / text / accent: <bg hex / text hex / accent hex>
- Card background: <CSS gradient or colour>
- Font: <font family>

## People
- Validator(s): <role that approves the prototype, never a name>
- Notes on how they like to work: <e.g. refs are intent only, short answers>
```

## Default definition of done
Use this when the profile has none, and say in the ticket that it's the default:
- Tests at the agreed test points pass in CI.
- Code reviewed and merged (behind a flag if the team uses them).
- Copy present in every shipped language.
- Acceptance criteria checked with a keyboard and a screen reader.
- Design QA against the prototype frames, desktop and mobile.
- Docs, glossary or ADRs updated if the feature changed them.

## Stage swaps when something is `none`
- **No Figma:** skip 5a, or ask whether the prototype frames should go into whatever design tool they use. The prototype is then the design source of truth.
- **No design system:** build the prototype on the app's live CSS (inspect the running app or the repo's styles). If there's no product yet, ask for 2–3 brand values and list everything else under "Calls I made".
- **No codebase:** write the spec with the default structure, and make "Structure" a proposal. Flag every assumption under Open Questions.
- **No ticket language set:** use the language the user writes in.
