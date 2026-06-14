---
name: redesign-tailwind
description: >
  Redesign CKAN templates (header, footer, home page, snippets, etc.) using
  Tailwind CSS with the tw- prefix and Font Awesome icons, following the
  visual style already established for this CKAN deployment (Kota Kendari
  open data portal). Use this skill whenever the user asks to redesign,
  restyle, or rebuild the look of a CKAN page/template/snippet.
---

# Redesign CKAN Templates with Tailwind

This project is migrating CKAN's default Bootstrap/legacy-CSS templates to a
custom design built with **Tailwind CSS (prefix `tw-`)** and **Font Awesome**
icons. Already-redesigned references: [header.html](../../../ckan/templates/header.html),
[footer.html](../../../ckan/templates/footer.html), and
[home/index.html](../../../ckan/templates/home/index.html) + its snippets in
[home/snippets/](../../../ckan/templates/home/snippets/).

## Tooling setup (already configured — do not duplicate)

- Tailwind is loaded via the **Tailwind Play CDN** in
  [base.html](../../../ckan/templates/base.html) (around line 104):
  - `prefix: 'tw-'` — every Tailwind utility class must be written as
    `tw-<utility>` (e.g. `tw-flex`, `tw-text-sm`, hover variants become
    `hover:tw-bg-white/10`).
  - `corePlugins: { preflight: false }` — Tailwind's reset is disabled, so
    existing CKAN base styles still apply unless overridden.
  - Font is `Inter` (Google Fonts), already wired to `body`/`.tw-font-sans`.
  - No Tailwind plugins (e.g. typography/`prose`) are loaded — **never use
    `tw-prose`** classes; style markdown output manually with arbitrary
    variants like `[&_h1]:tw-text-white`.
- Font Awesome is loaded via `{% asset 'vendor/fontawesome' %}` in
  `base.html`. Use `fa-solid fa-<icon>` classes for icons.

## Color palette (Kota Kendari portal)

| Color | Hex | Usage |
|---|---|---|
| Dark navy | `#0D3748` | header account bar, hero gradient start |
| Teal/blue | `#185A75` | primary buttons, links, footer bg, hero gradient end |
| Sky blue | `#38bdf8` | accent highlights, headings |
| Light cyan | `#7dd3ee` | badges, small accents, dividers |
| Pale blue | `#bde3f0` / `#e0f4fb` | muted body text on dark backgrounds |
| Amber | `#fbbf24` | secondary accent labels (e.g. location tags, "+" suffixes) |
| Green | `#34d399` | "live/active" status dots |

Use `style="color: #...; background-color: #..."` for these exact hex
values (arbitrary values like `tw-text-[#185A75]` also work but inline
`style` is the existing convention for brand colors in header/footer).

## Workflow for redesigning a template

1. **Read the current template** and any snippets it includes.
2. **Check if snippets are shared** with other pages (e.g.
   `snippets/group_item.html`, `snippets/organization_item.html`,
   `snippets/package_list.html`). If a snippet is reused elsewhere and still
   uses Bootstrap, **do not rewrite it in place** — either:
   - leave it untouched and build a new self-contained Tailwind block in the
     page-specific template/snippet instead (this is what was done for
     `home/snippets/featured_group.html` / `featured_organization.html`), or
   - ask the user before changing a shared snippet's markup.
3. **Strip legacy classes**: remove Bootstrap grid (`container`, `row`,
   `col-md-*`), CKAN module classes (`module`, `card`, `box`, `module-*`,
   `homepage`, `hero`, etc.) and replace with Tailwind layout utilities
   (`tw-max-w-6xl tw-mx-auto tw-px-4`, `tw-grid tw-grid-cols-1 lg:tw-grid-cols-2
   tw-gap-8`, etc.). Watch out for legacy CSS rules (e.g. `.hero:after`) that
   may still apply via class name even after removing other classes —
   prefer dropping the old class name entirely rather than layering Tailwind
   on top of it.
4. **Replace icon fonts** (`fa fa-*`, glyphicons) with `fa-solid fa-*`.
5. **Keep all i18n**: preserve `{{ _("...") }}` / `{% trans %}...{% endtrans %}`
   wrappers for any user-facing text, including new text you add.
6. **Preserve template blocks** (`{% block ... %}`) — they may be overridden
   by docs/tutorials or extensions (see comments like "this block is used as
   an example in the theming tutorial").
7. **Respect dynamic data**: don't hardcode values that come from CKAN config
   or helpers (e.g. `g.site_intro_text`, `g.package_count`,
   `h.get_featured_groups()`, `search_facets`). If a design mockup shows
   static numbers/text, wire them to the real helper/variable instead.
8. For decorative imagery with no existing asset, prefer an inline/static
   **SVG** placed under `ckan/public/base/images/` (no image-generation tool
   is available) — see `hero-abstract.svg` for the abstract hero background
   pattern.
9. Use `tw-animate-pulse` / `tw-animate-ping` for subtle live-indicator
   animations (Tailwind's built-in animation utilities work fine with the
   `tw-` prefix, no plugin needed).

## Common layout primitives used so far

- Page container: `tw-max-w-6xl tw-mx-auto tw-px-4`
- Section spacing: `tw-py-12 md:tw-py-16`
- Card: `tw-bg-white tw-rounded-2xl tw-shadow-sm tw-border tw-border-gray-100 tw-p-6`
- Pill/badge: `tw-inline-flex tw-items-center tw-gap-2 tw-px-4 tw-py-1.5 tw-rounded-full tw-text-xs tw-font-semibold tw-uppercase`
- Full-viewport hero: `tw-min-h-screen tw-flex tw-items-center`
