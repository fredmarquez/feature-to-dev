# Dev ticket + spec

The dev output comes in **two files**:
- **`TICKET.md`**: the build ticket, in the profile's ticket language (or the user's language if none is set). It's what a developer works from: what to build, how we'll know it works, and what "done" means for this team.
- **The spec**: the detailed version, written **the way the repo's own specs are written**, so devs can drop it into the repo and feed it to their own tools (agents, planning skills).

The ticket is the checklist; the spec holds the reasoning, the copy tables, the structure and the code references. The ticket links to the spec instead of repeating it.

## Before writing
If no grill came before (an old backlog item, a bare ticket request), put the open decisions to the user first in one short round, each with your recommendation. Then explore the codebase with a sub-agent (brief in `agent-briefs.md`). The spec earns its value through four things:
- **The team's vocabulary.** Use the domain glossary's terms, and honour its "don't call it X" rules.
- **Reuse.** Point at existing (even dormant) infrastructure and the ADRs that planned for this feature. Never design a second system next to one that exists.
- **Real blockers.** Name the validation rules, guards or invariants the feature would trip over.
- **The repo's spec convention.** Use the profile's spec convention if it names one. Otherwise find where the repo keeps design specs (e.g. `docs/specs/YYYY-MM-DD-<slug>.md`, `rfcs/NNNN-<slug>.md`, `adr/`). Read 1–2 recent ones and copy their format: filename pattern, language, title style, section names and order, tone and length.

If the work is a gap in something already built (an old backlog item, a hardening pass), check the code first and cover **only what's missing**. Leave out what's done.

## The ticket (`TICKET.md`)
Write it in the profile's ticket language, translating the headings (or use the profile's own headings if it lists them). Every line should be something a developer builds or checks off:

```
**Title:** <outcome, not implementation>

**Why:** one line: the user problem this solves.

**What to build**
- <one bullet per piece the dev team delivers: UI element and where it lives, behaviour and rules, data or settings, API or service change, notifications>
- <name the state ids from the prototype when a bullet maps to a screen: `?state=menu`>

**Acceptance criteria**
- [ ] <one testable behaviour per line: "Given / when / then" or a plain observable result>
- [ ] <every failure and edge state the spec gives a message for>
- [ ] <the accessibility items this feature raised (keyboard path, announced status, contrast, target size)>
- [ ] <copy present in every shipped language>

**Definition of done**
- [ ] <the team's standing checklist, copied from the profile>

**Out of scope**
- <what this version explicitly doesn't do>

**Open questions for the dev team**
1. <question> (recommendation: <answer>)

**Links:** spec `<spec filename>` · prototype `<slug>.html` · frames `frames/` · video `<slug>-walkthrough.mp4`
```

Rules:
- **Acceptance criteria vs definition of done.** Acceptance criteria are specific to this feature and testable. The definition of done is the team's standing checklist (tests, review, translations, accessibility, design QA, flags, docs) and barely changes between features. Take it from the profile; if the profile has none, use the default in `references/profile.md` and say so.
- **Keep the checklist plannable.** Aim for 6 to 12 acceptance criteria. Group minor states into one line that points to the spec ("every state in the spec's Messages table shows its exact message") rather than listing each toast.
- **Build terms, not user stories.** "Add a Snooze item to the row action menu, between Due date and Delete" beats "users can snooze tasks". Keep it at the level a developer plans from; implementation choices still open go to Open questions.
- **No code, paths or copy tables** in the ticket: those live in the spec. Prototype state ids are fine, they're how devs find the screen.
- **Versions.** When the scope splits (V1 now, V2 later), write one ticket and one spec per version (`TICKET-V1.md`, `TICKET-V2.md`), each self-contained.

## The spec
Follow the repo convention you found. It overrides the default below.

**Default when the repo has no spec convention:**

```
# <Feature Name> Design

## Problem        (what happens today, with file/function references; the gap, in numbered cases if several)
## Decision       (the choices made, as bullets with a short why; flag each one that hangs on an open question)
## User-facing copy   (table: state · trigger · level · one column per language the product ships)
## Structure      (modules, interfaces, schema, API contract, client changes; name real files and functions)
## Tests          (numbered, at the highest seams; name prior-art tests and fixtures to reuse; add a manual acceptance line when real-world data matters)
## Open Questions (numbered; each with your recommendation)
## Out of Scope
```

Other rules:
- **Language.** Match the repo's existing specs (usually English) even when the ticket is in French. User-facing copy appears in every language the product ships.
- **Error and status messages.** When the feature surfaces a state to users, write the exact message for each state: what happened, then what to do about it. Say where it shows (toast, persistent state on the element, inline under content) and its level (error / warning / info).
- **Placement.** Save the spec in the feature folder under the repo's filename pattern. Don't write into the repo itself unless the user asks.

## Glossary and ADR drafts (when needed)
If the feature introduces new domain terms, or decides something an ADR should record (a new data rule, a change to an accepted ADR), write `GLOSSARY-draft.md` and/or `ADR-drafts.md` next to the spec, in the repo's own glossary/ADR format. Drafts only: the dev team adopts them.

## Revisions
When decisions change after the spec exists, rewrite the spec and ticket so they match the current prototype. If the change is large, write a new dated spec and mark the old one `Superseded by <file>` at the top. Say in both files which other outputs (Figma, video) are out of date.

## Test points
Propose the highest-level seams possible (fewer is better; one is ideal). They're usually:
1. the request validation/preparation module
2. the domain data structure's module
3. a pure decision function, e.g. "should X show"

Use the repo's existing test style and name the prior-art tests. If the repo has no component tests, say that the logic must live in plain modules. Check the seams with the user.

## Publishing
Save both files in the feature folder. Give the ticket text in the chat too, so it's ready to paste. The profile's tracker setting decides the rest: if it's local only or empty, don't ask where it goes. Post to a tracker (ClickUp, Linear, GitHub…) only when the profile or the user names one, and confirm first every time: creating a ticket is an outward action.
