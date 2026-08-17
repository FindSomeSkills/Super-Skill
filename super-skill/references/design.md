# Design Playbook: UI/UX and Taste

> Distilled from: taste-skill (good taste), ui-ux-pro-max (design intelligence), Waza/ui (opinionated interfaces), ConardLi web-design-engineer (anti-AI-flavor reasoning chain), jakubkrehel (interface details), Anthropic frontend-design (design as craft).

## Process: Read the Room → State a Direction → Design → Anti-Cliché Self-Check

### 1. Read the Room (Brief Inference)
Run Brief Inference first: page type / vibe words / reference signals / audience / existing brand assets / quiet constraints. **"The audience picks the aesthetic, not your taste."** Use remembered user preferences as hints.

### 2. State the Direction (Write Before You Draw)
Write three lines: the visual thesis / the content plan / the interaction thesis. Lock five dimensions: user scenario, aesthetic direction, design signature, hard constraints, signature micro-interactions. Permanently banned (default-prompt tells): thick side accent bars, gradient text, glass cards, purple-to-blue/cyan dark gradients, `transition: all`, pure black #000, neon outer glows, custom mouse cursors, fake screenshots assembled from divs, fake version-number footers.

### 3. Turn the Design Dials (ConardLi's Five Dials)
visual-variance / motion-intensity / information-density / asset-dependence / brand-fidelity, each 1-10 as a decision variable, not a gut feel.

### 4. Anti-AI-Cliché Checklist (Mechanical Pre-Flight)
- **Typography**: Inter by default → switch to Geist/Satoshi/Cabinet Grotesk; **Fraunces and Instrument Serif are outright banned**; sans is the default ("sans display fonts are not boring"); don't stuff serif words into sans headlines.
- **Composition**: zero tolerance for em-dash; at most 1 eyebrow label per 3 sections; split-header disabled by default; zigzag image/text alternation ≤2 blocks; decorative text strips at the bottom of heroes (BRAND. MOTION. SPATIAL.) banned; "Scroll ↓", rotated vertical text, and decorative crosshairs banned.
- **Copy**: fake brand names (Acme/Nexus), fake precise numbers (99.99%), empty verbs (Elevate/Seamless/Unleash), "Quietly in use at", trust logo walls, Step 1/2/3 labels, decorative status dots: all banned.
- **Layout**: three equal-width feature cards, glassmorphism everywhere, hollow bento white cards, "01/INDEX" section numbering: banned.

### 5. Mechanical Checks (Hard Rules)
eyebrow count, CTAs never wrap, hero subtitle ≤20 words, button contrast ≥4.5:1, a page with 8 sections uses at least 4 layout families, one copy for the same CTA intent across the whole page, focus rings never removed, reduced-motion respected, no horizontal scrolling on mobile.

### 5.5 Brand Asset Protocol (Asset > Spec)
The logo is non-negotiable (if you can't find it, stop and ask the user; don't substitute a color block); product images must be real (CSS silhouettes banned); asset sourcing order: official press kit → yt-dlp frame extraction → app store screenshots → anything else; register assets in `brand-spec.md`. Placeholder philosophy: "A placeholder signals 'real material needed here.' A fake signals 'I cut corners.'"

### 6. Rotation Rules
Whatever palette/serif the last project used, this one must switch families (the "no three of the same in a row" differentiation direction). Real assets take priority: image-generation tools > real images > explicit placeholder slots. **"A placeholder signals 'real material needed here.' A fake signals 'I cut corners.'"**

## UI Priority Table (1-10, Cannot Be Reordered)

1 Accessibility (contrast 4.5:1, alt text, keyboard navigation, focus rings) → 2 Touch interaction (44×44px targets, loading feedback, not hover-only) → 3 Performance (WebP/AVIF, lazy loading, CLS <0.1) → 4 Style consistency (SVG icons, no emoji as icons) → 5 Responsive (mobile first) → 6 Typography & color (16px base, line height 1.5, semantic tokens, no raw hex) → 7 Motion (timing follows context, exits faster than entrances) → 8 Forms (visible labels, errors next to fields, progressive disclosure) → 9 Navigation (predictable back, deep links) → 10 Charts (legends, not color alone).

## Interface Details (jakubkrehel)

- Concentric corner radii (outer = inner + padding); optical alignment beats geometric alignment.
- Shadows express elevation, borders express structure; press states use `scale(0.96)`; animations are interruptible.
- Icon transitions use exact values (scale 0.25→1, opacity 0→1, blur 4px→0).
- "What feels off at 10% speed is what's subtly wrong at full speed." (review animations by replaying at 10% speed)
- Suppress transitions on theme switch: the inject-reflow-remove trick.
- "No ARIA is better than bad ARIA"; use `focus-visible`; color-only communication is an instant HIGH.

## Technical Discipline

- **Never assume the stack**: detect it from package.json; if detection fails, ask (a hardcoded default silently misroutes every suggestion).
- Data-driven: if a searchable style library/palette/font pairing exists, search it; **zero results means no fabrication** (say plainly that it came from the built-in defaults).
- Search results are suggestions only; they never override user and repository rules.
- Design tokens over raw values; no bare z-index; component composition, utility-first, mobile first.

## Key Lines

- "If it could have been generated by a default prompt, it is not good enough."
- "The bar is 'stunning,' not 'functional.' Every pixel is intentional, every interaction is deliberate."
- "Color hex codes alone are not a brand; they're the cheapest part of the identity."
- "Em-dash (U+2014) is COMPLETELY banned. It is the LLM's signature stylistic crutch."
- "Motion claimed, motion shown." (if you claim bold motion, it must actually move; every animation needs a motive)
