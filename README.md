# Feature to Dev

A reusable AI workflow for turning a feature idea into a reviewed prototype and a developer handoff. It makes product decisions explicit, checks the existing design system and codebase, and records what remains uncertain.

## What it does

Interview about scope and behaviour → inspect available evidence → build a clickable HTML prototype → obtain approval → prepare the requested ticket, detailed specification, reference frames, optional Figma screens and captioned walkthrough.

`GRILL.md` is the decision log: agreed choices, open questions and output locations. A project profile supplies local conventions without embedding them in the skill. Developers still review technical proposals; a prototype does not prove production readiness or accessibility compliance.

## Use

Place this folder, named `feature-to-dev`, in your skill-enabled assistant’s personal or project skills directory. For Claude Code, the personal location is `~/.claude/skills/feature-to-dev/`. Start with: “Use feature-to-dev to help define this feature.” You can request one stage only.

Read [SKILL.md](SKILL.md) for the workflow. The guides in `references/` cover project settings, prototyping, accessibility, specifications and video. Sub-agents and Figma are optional; unavailable capabilities have sequential or local alternatives.

The rendering helpers require Bash and Chrome/Chromium; walkthroughs also require ffmpeg/ffprobe. The contrast helper requires Python 3. Inspect local HTML before rendering: it executes JavaScript. Keep browser sandboxing enabled and run as a non-root user. Output files can be overwritten, so use a dedicated output folder. State IDs accept only letters, digits, underscores and hyphens. Tour card HTML must be trusted author-written markup.

This distribution contains the generic skill and helpers only. Supply your own authorized project context; do not commit client data, credentials, proprietary assets or restricted fonts. No client project, Portal adaptation or pre-rendered media is bundled.

## Validation and license

Packaging and targeted helper checks are documented for this release; full end-to-end assistant, Figma and video workflows have not been validated in this review. The original MIT license and attribution are preserved in [LICENSE](LICENSE).
