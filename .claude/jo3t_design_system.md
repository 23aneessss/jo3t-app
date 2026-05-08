# JO3T — Design System
> Version 1.0 | Living document — update with every design decision

---

## 1. Design Philosophy

JO3T is not a food delivery app. It's a social discovery app. The visual language must reflect that distinction.

- **Warm, not loud.** Orange is the brand but never aggressive. It should feel like afternoon sun, not a fast food sign.
- **Content-first.** Photos and reviews take center stage. The UI is scaffolding, not decoration.
- **Tactile.** Every interaction should feel physical — cards that lift, sheets that snap, buttons that press. Animation is functional, not cosmetic.
- **Local.** The design nods to Algeria without being folksy. Clean and modern, but with warmth.

---

## 2. Color Palette

### Primary

| Token | Hex | Usage |
|---|---|---|
| `brand.primary` | `#E8520A` | CTAs, active states, brand marks |
| `brand.primaryLight` | `#FFF0E8` | Tinted backgrounds, chips, badges |
| `brand.primaryDark` | `#B33E06` | Pressed state on primary buttons |

### Neutral

| Token | Hex | Usage |
|---|---|---|
| `neutral.900` | `#0F0F0F` | Primary text |
| `neutral.700` | `#3A3A3A` | Secondary headings |
| `neutral.500` | `#6B6B6B` | Body copy, subtitles |
| `neutral.300` | `#B0B0B0` | Placeholders, disabled |
| `neutral.100` | `#F2F2F2` | Dividers, subtle backgrounds |
| `neutral.50` | `#FAFAFA` | Page background |
| `neutral.0` | `#FFFFFF` | Card surfaces |

### Semantic

| Token | Hex | Usage |
|---|---|---|
| `semantic.success` | `#1A9C5B` | Open status, confirmed state |
| `semantic.warning` | `#D97706` | Closing soon, moderate rating |
| `semantic.error` | `#DC2626` | Closed status, errors |
| `semantic.info` | `#2563EB` | Informational badges |

### Score Colors (JO3T Rating System)
Ratings are 1–10. Color interpolates across the range.

| Score | Color | Hex |
|---|---|---|
| 1–4 | Red | `#DC2626` |
| 5–6 | Amber | `#D97706` |
| 7–8 | Orange | `#E8520A` |
| 9–10 | Green | `#1A9C5B` |

---

## 3. Typography

Font: **Plus Jakarta Sans** (Google Fonts, free)
Why: Geometric, warm, highly legible at small sizes, excellent Arabic fallback pairing.

### Type Scale

| Token | Size | Weight | Line Height | Usage |
|---|---|---|---|---|
| `text.display` | 32px | 700 | 1.2 | Hero titles, splash screen |
| `text.h1` | 24px | 700 | 1.3 | Screen titles |
| `text.h2` | 20px | 600 | 1.3 | Section headings |
| `text.h3` | 17px | 600 | 1.4 | Card titles, place names |
| `text.body` | 15px | 400 | 1.6 | Reviews, descriptions |
| `text.bodyMedium` | 15px | 500 | 1.6 | Labels, meta information |
| `text.caption` | 13px | 400 | 1.5 | Timestamps, secondary meta |
| `text.captionMedium` | 13px | 500 | 1.5 | Badges, chips, tags |
| `text.micro` | 11px | 500 | 1.4 | Tab labels only |

### Arabic / French Support

- Arabic (Darija written in Latin): render in Plus Jakarta Sans, RTL not required for Darija
- French: native support, no modifications
- Future Arabic (formal): use **Cairo** font as fallback

---

## 4. Spacing System

8pt grid system. All spacing values are multiples of 4 or 8.

| Token | Value | Usage |
|---|---|---|
| `space.2` | 2px | Micro gaps (icon to label) |
| `space.4` | 4px | Tight internal padding |
| `space.8` | 8px | Component internal padding |
| `space.12` | 12px | Card internal padding |
| `space.16` | 16px | Standard section padding |
| `space.20` | 20px | Card vertical padding |
| `space.24` | 24px | Section top margins |
| `space.32` | 32px | Large section separation |
| `space.48` | 48px | Screen-level vertical rhythm |

Screen horizontal margin: **16px** on both sides (standard), **20px** on large phones.

---

## 5. Border Radius

| Token | Value | Usage |
|---|---|---|
| `radius.sm` | 6px | Chips, small badges |
| `radius.md` | 10px | Buttons, input fields |
| `radius.lg` | 14px | Cards |
| `radius.xl` | 20px | Bottom sheets, modals |
| `radius.full` | 999px | Avatars, pill tags, FAB |

---

## 6. Elevation & Shadows

JO3T uses minimal, purposeful shadows. Never decorative.

| Level | CSS equivalent | Usage |
|---|---|---|
| `elevation.0` | No shadow | Flat elements, dividers |
| `elevation.1` | `0 1px 3px rgba(0,0,0,0.08)` | Cards at rest |
| `elevation.2` | `0 4px 12px rgba(0,0,0,0.10)` | Cards on hover / lifted |
| `elevation.3` | `0 8px 24px rgba(0,0,0,0.12)` | Bottom sheets, modals |
| `elevation.4` | `0 16px 40px rgba(0,0,0,0.14)` | Full-screen overlays |

---

## 7. Iconography

Library: **Lucide Icons** (MIT license, 1,000+ icons, perfect stroke weight)

- Stroke width: **1.5px** always
- Default size: **22px** in nav, **20px** inline, **18px** in chips
- Color: inherits from parent context (never hardcoded)

Key icons used in JO3T:

| Context | Icon name |
|---|---|
| Restaurants | `utensils` |
| Cafés | `coffee` |
| Patisserie | `cake` |
| Street food | `sandwich` |
| Juice bars | `glass-water` |
| Location | `map-pin` |
| Search | `search` |
| Rating/Score | `star` (filled) |
| Save | `bookmark` |
| Add review | `pen-line` |
| Map view | `map` |
| Profile | `user-round` |
| Settings | `settings-2` |
| Share | `share-2` |
| Followers | `users-round` |

---

## 8. Components

### 8.1 Place Card (horizontal, feed)

Structure:
- Left: square image (72×72px, radius.md, object-fit cover)
- Right column:
  - Place name (text.h3)
  - Category + wilaya (text.caption, neutral.500)
  - Score badge + distance (inline row)
- Tap: navigate to Place Profile with hero transition

States: rest → pressed (scale 0.98, 80ms) → navigate

### 8.2 Place Card (vertical, featured)

Structure:
- Full cover image (aspect ratio 4:3, radius.lg)
- Gradient overlay (bottom 40%, rgba black 0→0.6)
- Place name overlaid (text.h2, white)
- Score badge top-right on image
- Below image: category chip + distance

### 8.3 Score Badge

Circular badge, 36×36px (large) or 28×28px (small).
- Background: score color (see §2 Score Colors) at 15% opacity
- Text: score color, text.h3 or text.bodyMedium
- Border: 1px solid score color at 30% opacity

Example: Score 8.5 → orange badge

### 8.4 Category Chip

Horizontal pill. Icon left + label.
- Background: neutral.100 (unselected) / brand.primaryLight (selected)
- Text: neutral.700 (unselected) / brand.primary (selected)
- Border: 1px solid neutral.200 (unselected) / brand.primary at 20% (selected)
- Height: 34px, padding horizontal 12px

### 8.5 Review Card

- Avatar (40px circle) + name + wilaya badge
- Score badge (small, right-aligned)
- Review text (text.body, max 3 lines collapsed)
- Photo strip (if photos, horizontal scroll of 60px squares)
- Timestamp (text.caption, neutral.300)

### 8.6 Bottom Sheet

- Drag handle: 36×4px, radius.full, neutral.200, centered, 12px from top
- Background: white, radius.xl (top corners only)
- elevation.3
- Snap points: 40% height (preview), 85% height (expanded)

### 8.7 Primary Button

- Height: 52px
- Background: brand.primary
- Text: white, text.bodyMedium
- Radius: radius.md
- Pressed: brand.primaryDark + scale(0.97)
- Loading: show `CircularProgressIndicator` (white, strokeWidth 2)

### 8.8 Map Pin

Custom pin instead of Google default:
- Shape: teardrop (bottom point)
- Fill: brand.primary
- Inner icon: category icon (white, 14px)
- Selected state: larger (1.3x scale) + elevation.2 drop shadow

---

## 9. Motion & Animation

### Principles
- **Duration**: fast UI feedback = 80–150ms. Page transitions = 280–350ms. Never exceed 400ms.
- **Easing**: Use `Curves.easeOutCubic` for entrances, `Curves.easeInCubic` for exits, `Curves.easeInOutCubic` for state changes.
- **Purpose**: Every animation communicates something. No spins for loading if a skeleton does the job.

### Animation Catalog

| Element | Animation | Duration | Curve |
|---|---|---|---|
| Page push | Slide up + fade in | 320ms | easeOutCubic |
| Page pop | Slide down + fade out | 280ms | easeInCubic |
| Card tap | Scale 0.98 | 80ms | easeInOutCubic |
| Bottom sheet appear | Slide up from bottom | 350ms | easeOutCubic |
| Score badge entry | Scale 0→1 + fade | 400ms | elasticOut (slight bounce) |
| Place card scroll entry | Fade up (translateY 12px → 0) | 280ms | easeOutCubic |
| Hero image transition | SharedElement transition | 350ms | easeInOutCubic |
| Map pin tap | Scale 1→1.3 | 200ms | easeOutBack |
| Skeleton → content | Crossfade | 200ms | linear |

### Flutter packages to use

| Package | Purpose |
|---|---|
| `animations` (flutter team) | SharedAxis, FadeThrough, OpenContainer transitions |
| `flutter_animate` | Chainable, declarative animations on any widget |
| `lottie` | Splash screen animation, empty states |
| `shimmer` | Skeleton loading screens |
| `hero` (built-in) | Place card → detail screen image transition |

---

## 10. Dark Mode

JO3T supports dark mode from day one.

| Light token | Dark equivalent |
|---|---|
| `neutral.50` (background) | `#0F0F0F` |
| `neutral.0` (card) | `#1A1A1A` |
| `neutral.100` (dividers) | `#2A2A2A` |
| `neutral.900` (text) | `#F0F0F0` |
| `neutral.500` (secondary text) | `#909090` |
| `brand.primary` | unchanged (`#E8520A`) |
| `brand.primaryLight` | `#2A1A12` (dark tint) |

Score colors and semantic colors remain unchanged in dark mode.

---

## 11. Imagery Guidelines

- All place photos: 4:3 aspect ratio minimum, JPEG compressed to max 800KB
- Avatar photos: 1:1, circular crop, max 200KB
- Cover image on Place Profile: full-bleed, 16:9 preferred
- Photo quality: reject if width < 400px or if blur score below threshold (use ML Kit on upload)
- Placeholder: warm gray gradient (neutral.100 → neutral.50), never a broken image icon

---

## 12. Accessibility

- Minimum tap target: 44×44px (Apple HIG / Material standard)
- Color contrast: all text meets WCAG AA minimum (4.5:1 for body, 3:1 for large text)
- The score badge color alone is never the only indicator — always show the number
- All icons in navigation have semantic labels for screen readers
- Font scaling: UI respects system font size settings up to 130% without breaking layout

---

*This document is a contract between design and engineering. Any component deviation must be documented here.*
