# Accessibility and pattern checks

Two checks, at two moments. Both report problems the user can act on, never a generic lecture.

## 1. Pattern research (during grill round 1)

Run it when the interaction pattern is new to the product (first snooze, first pinning, first onboarding flow) or touches input, navigation or time limits. Skip it for small changes to an existing screen.

Find, with sources:
- How 3 to 5 well-regarded products handle the same pattern: entry point, defaults, undo, empty and error states. Note where they agree (a convention users already know) and where they differ (a real decision).
- The accessibility requirements the pattern raises (see the checklist below), stated for this feature, not in general.
- Known pitfalls: what users complain about in reviews, forums or support pages.

Use it in two places: the ➡️ recommendations in the grill (cite the convention when you lean on it) and the acceptance criteria in the ticket. Never let it overrule the product's own design system or a decision the user made.

## 2. Accessibility review (before the validation gate)

Review the prototype against the checklist. Fix what you can in the prototype, then list what remains under "Calls I made: confirm or change" and carry the rest into the ticket's acceptance criteria. Use `scripts/contrast.py` for colour pairs instead of guessing.

## Checklist (WCAG 2.2 AA)

| Check | What to verify in this feature | WCAG |
|---|---|---|
| Keyboard | Every action works without a mouse; hover-only actions have a keyboard path (a shortcut alone isn't enough, it needs a focusable control) | 2.1.1 |
| Focus | Focus is visible, moves in a logical order, goes into a menu or dialog when it opens and back to the trigger when it closes | 2.4.3, 2.4.7 |
| Names | Icon-only buttons have an accessible name; inputs have labels | 4.1.2, 1.3.1 |
| Text contrast | 4.5:1 for normal text, 3:1 for large text (24px, or 18.5px bold) | 1.4.3 |
| UI contrast | 3:1 for icons, borders of inputs, focus rings and state indicators | 1.4.11 |
| Colour alone | Status, warnings and selection never rely on colour alone (add text or an icon) | 1.4.1 |
| Target size | Pointer targets at least 24×24 px, or enough spacing around them | 2.5.8 |
| Status messages | Toasts, "saved", errors and counts are announced to screen readers (`aria-live` or `role="status"`) without moving focus | 4.1.3 |
| Time limits | Anything that disappears on a timer (an undo toast) can be reached again, paused or extended, or the action can be undone another way | 2.2.1 |
| Hover and focus content | Tooltips and popovers can be dismissed without moving the pointer (Esc), can be hovered, and stay until dismissed | 1.4.13 |
| Motion | Animations respect `prefers-reduced-motion` | 2.3.3 (AAA, cheap to meet) |
| Mobile | Gesture-only actions (swipe) have a visible alternative | 2.5.1 |
| Language | Copy fits in every shipped language (French runs about 20% longer than English) | n/a |
