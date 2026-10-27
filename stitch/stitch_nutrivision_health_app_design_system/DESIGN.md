---
name: NutriVision Clinical Intelligence
colors:
  surface: '#faf8ff'
  surface-dim: '#d2d9f4'
  surface-bright: '#faf8ff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f2f3ff'
  surface-container: '#eaedff'
  surface-container-high: '#e2e7ff'
  surface-container-highest: '#dae2fd'
  on-surface: '#131b2e'
  on-surface-variant: '#3c4a42'
  inverse-surface: '#283044'
  inverse-on-surface: '#eef0ff'
  outline: '#6c7a71'
  outline-variant: '#bbcabf'
  surface-tint: '#006c49'
  primary: '#006c49'
  on-primary: '#ffffff'
  primary-container: '#10b981'
  on-primary-container: '#00422b'
  inverse-primary: '#4edea3'
  secondary: '#006398'
  on-secondary: '#ffffff'
  secondary-container: '#5bb8fe'
  on-secondary-container: '#00476e'
  tertiary: '#9d4300'
  on-tertiary: '#ffffff'
  tertiary-container: '#ff7e2d'
  on-tertiary-container: '#622700'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#6ffbbe'
  primary-fixed-dim: '#4edea3'
  on-primary-fixed: '#002113'
  on-primary-fixed-variant: '#005236'
  secondary-fixed: '#cce5ff'
  secondary-fixed-dim: '#93ccff'
  on-secondary-fixed: '#001d31'
  on-secondary-fixed-variant: '#004b73'
  tertiary-fixed: '#ffdbca'
  tertiary-fixed-dim: '#ffb690'
  on-tertiary-fixed: '#341100'
  on-tertiary-fixed-variant: '#783200'
  background: '#faf8ff'
  on-background: '#131b2e'
  surface-variant: '#dae2fd'
typography:
  display:
    fontFamily: Plus Jakarta Sans
    fontSize: 40px
    fontWeight: '700'
    lineHeight: 48px
    letterSpacing: -0.02em
  display-mobile:
    fontFamily: Plus Jakarta Sans
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.015em
  headline-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 30px
    fontWeight: '700'
    lineHeight: 38px
    letterSpacing: -0.015em
  headline-lg-mobile:
    fontFamily: Plus Jakarta Sans
    fontSize: 24px
    fontWeight: '700'
    lineHeight: 32px
    letterSpacing: -0.01em
  headline-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 22px
    fontWeight: '600'
    lineHeight: 28px
    letterSpacing: -0.01em
  headline-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 24px
    letterSpacing: '0'
  body-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
    letterSpacing: '0'
  body-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
    letterSpacing: '0'
  body-sm:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '400'
    lineHeight: 16px
    letterSpacing: 0.01em
  label-lg:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
    letterSpacing: 0.01em
  label-md:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
    letterSpacing: 0.02em
  label-sm:
    fontFamily: Inter
    fontSize: 11px
    fontWeight: '600'
    lineHeight: 14px
    letterSpacing: 0.04em
  metric-num:
    fontFamily: Plus Jakarta Sans
    fontSize: 26px
    fontWeight: '700'
    lineHeight: 30px
    letterSpacing: -0.02em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 1rem
  gutter-tablet: 1.5rem
  gutter-desktop: 2rem
  margin: 1rem
  margin-tablet: 2rem
  margin-desktop: 3rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 1rem
  space-lg: 1.5rem
  space-xl: 2rem
---

## Brand & Style

This design system blends **Modern Clinical Precision** with **Organic Wellness Vitality**. It serves patients, wellness seekers, and clinical dietitians who require real-time computer vision food analysis, glycemic load modeling, and micro-nutrient diagnostics.

### Emotional Posture
- **Empowering, Not Restrictive:** Visuals prioritize holistic vitality, nutrient abundance, and positive reinforcement over punitive caloric deficits.
- **Clinical Rigor & High Fidelity:** Every metric, macronutrient breakdown, and diagnostic score displays razor-sharp visual balance, inspiring deep trust in AI bio-telemetry.
- **Biophilic Precision:** Crisp structural containers are balanced with vibrant organic botanical greens and energetic citrus accents, eliminating cold hospital vibes without drifting into whimsical lifestyle tropes.

### Aesthetic Execution
The UI relies on refined multi-layer tonal containment, subtle frosted glass telemetry backplates (`backdrop-blur-md`), whisper-quiet translucent borders, and high-legibility typographic hierarchies tailored for real-time camera overlays, cross-platform Flutter canvases, and complex metabolic health dashboards.

## Colors

The color system provides explicit parity across Light and Dark operating modes. All text and interactive pairings adhere strictly to WCAG AAA visual contrast thresholds on their target backgrounds.

### Light Palette (Telemetry Day)
- **Primary Organic Green:** `#10B981` (Base), `#059669` (Interactive Hover/Active, AAA text accessible on `#F8FAFC`), `#D1FAE5` (Subtle Badge/Surface Tint)
- **Secondary Clinical Blue:** `#0284C7` (Base), `#0369A1` (Focus/Data Emphasis), `#E0F2FE` (Surface Tint)
- **Tertiary Metabolic Orange:** `#F97316` (Base Energy & High Priority Nutrient Alerts), `#EA580C` (Pressed state), `#FFEDD5` (Soft background warning)
- **Surfaces & Layout:** Canvas `#F8FAFC`, Elevated Card `#FFFFFF`, Recessed Wells `#F1F5F9`
- **Structural Outlines:** `#E2E8F0` (Default), `#CBD5E1` (Hover/Dividers)
- **Text & Contrast:** Primary `#0F172A`, Secondary/Muted `#475569`, Tertiary Supporting `#94A3B8`

### Dark Palette (Telemetry Nocturne)
- **Primary Organic Green:** `#34D399` (Vibrant text/icons), `#10B981` (Base button fills), `#064E3B` (Container wash)
- **Secondary Clinical Blue:** `#38BDF8` (Bright telemetry highlights), `#0284C7` (Standard action fills), `#082F49` (Container wash)
- **Tertiary Metabolic Orange:** `#FB923C` (High-contrast warnings), `#C2410C` (Container wash)
- **Surfaces & Layout:** Deep Canvas `#0B1120`, Surface Elev-1 `#0F172A`, Surface Elev-2 (Cards) `#1E293B`, Surface Elev-3 (Overlays/Modals) `#334155`
- **Structural Outlines:** `#334155` (Base borders), `#475569` (Card highlight borders)
- **Text & Contrast:** Primary `#F8FAFC`, Secondary/Muted `#94A3B8`, Tertiary Supporting `#64748B`

### Semantic System States
- **Success (Glycemic Target Reached / Optimal Balance):** Light `#059669` / Dark `#34D399`
- **Warning (Allergen Trace / High Sodium Detected):** Light `#D97706` / Dark `#FBBF24`
- **Error (Severe Allergen / Scan Timeout):** Light `#DC2626` / Dark `#F87171`
- **Info (AI Confidence Calibration / Micronutrient Sync):** Light `#0284C7` / Dark `#38BDF8`

## Typography

The type system pairs **Plus Jakarta Sans** for expressive, modern headings and metric displays with **Inter** for dense clinical tabular figures, nutrition labels, and diagnostic descriptions.

### Arabic (RTL) Localization Engine
When switching to Arabic localization:
- **Headlines & Metric Data:** Map dynamically to **Cairo** (`Cairo Bold` / `Cairo SemiBold`). Set tracking to `0` or slightly positive (`+0.01em`) to maintain fluid letter connections.
- **Body & Technical Microcopy:** Map to **Tajawal** (`Tajawal Regular` / `Tajawal Medium`), adjusting line heights up by `+2px` across all body tiers to accommodate taller vertical ascenders and descenders.

### Typographic Principles
- All numeric calorie, macro, and micro readouts enforce tabular numerical figures (`font-variant-numeric: tabular-nums` / `FontFeature.tabularFigures()`) to prevent layout shifts during live camera AR-scanning.
- Uppercase text transformations are reserved strictly for small metadata chips and labels (`label-sm`), never exceeding 14 characters.

## Layout & Spacing

A strict **8px layout grid** (with a granular 4px sub-grid for internal micro-badges, icon padding, and telemetry rings) orchestrates all spacing.

### Responsive Breakpoints & Structural Flow
- **Mobile (< 640px):** 4-column layout, `16px` outer canvas margins, `16px` gutter. Critical visual controls, scanner viewfinders, and bottom navigation sheets maintain an explicit minimum `44px × 44px` interactive touch target.
- **Tablet (640px - 1024px):** 8-column layout, `32px` outer margins, `24px` gutter. Utilizes master-detail split screens for camera viewfinder stream and nutritional telemetry cards.
- **Desktop / Clinical Dashboard (> 1024px):** 12-column fixed-max layout (`max-w-7xl` / `1280px` centered), `48px` outer margins, `32px` gutter. Accommodates extensive weekly glycemic trend visualizations and dietary longitudinal cohorts.

### Spatial Rhythm Rules
- Component internal padding uses `space-md` (`16px`) for standard cards and `space-lg` (`24px`) for prominent metric summaries.
- Vertical space between discrete diagnostic sections on mobile must measure at least `space-xl` (`32px`) to ensure distinct cognitive breaks for the patient.

## Elevation & Depth

Visual hierarchy uses a refined **Tonal Layering** system augmented with subtle, chromatic ambient lighting. Deep black drop-shadows are strictly prohibited.

### Elevation Hierarchy (Light Mode)
- **Level 0 (Base Canvas):** Flat `#F8FAFC`.
- **Level 1 (Surface Cards & Lists):** Pure `#FFFFFF` surface accompanied by a 1px perimeter border (`#E2E8F0`) and an ambient shadow: `0 1px 3px 0 rgba(15, 23, 42, 0.04), 0 1px 2px -1px rgba(15, 23, 42, 0.03)`.
- **Level 2 (Active Nutritional Modules & Focus Cards):** `#FFFFFF` with outline `#CBD5E1`, elevated by: `0 10px 15px -3px rgba(15, 23, 42, 0.05), 0 4px 6px -4px rgba(15, 23, 42, 0.03)`.
- **Level 3 (Sticky AR Telemetry Overlays & Modals):** Frosted Glass: `rgba(255, 255, 255, 0.85)` with `backdrop-filter: blur(12px)`, border `1px solid rgba(255, 255, 255, 0.60)`, elevated by `0 20px 25px -5px rgba(2, 132, 199, 0.08)`.

### Elevation Hierarchy (Dark Mode)
- **Level 0 (Base Canvas):** `#0B1120`.
- **Level 1 (Surface Cards):** `#0F172A` paired with perimeter border `1px solid #1E293B`.
- **Level 2 (Elevated Telemetry Nodes):** `#1E293B` paired with perimeter border `1px solid #334155` and a slight diffuse green tint shadow: `0 10px 25px -5px rgba(16, 185, 129, 0.06)`.
- **Level 3 (Viewfinder Modals & Floating Action Panes):** `#1E293B` at 90% opacity with `backdrop-filter: blur(16px)` and perimeter border `1px solid rgba(51, 65, 85, 0.8)`.

## Shapes

The design uses balanced, biological roundness to promote human approachability. 

### Geometric Rules
- **Base Corner Radius (`rounded-md`):** `8px` for internal small controls, micro-badges, and inner form fields.
- **Card & Dialog Radius (`rounded-2xl`):** `16px` (`1rem`) for health telemetry cards, image recognition cards, dietary list rows, and modal dialogs.
- **Interactive Buttons & Filter Chips:** Fully pill-shaped (`rounded-full` / `9999px`) to visually separate actionable commands from static data containers.
- **Data Rings & Camera Reticles:** Seamless concentric circles with stroke caps set to `stroke-linecap: round`.

## Components

### Buttons & Interactive Controls
- **Primary Action (Scan Meal / Confirm Intake):** Pill-shaped (`rounded-full`), min-height `48px`, horizontal padding `24px`. Background `#10B981` (Hover: `#059669`), text `#FFFFFF` (`label-lg`). Includes active micro-scale transition (`scale-98`).
- **Secondary Action (Manual Entry / Share):** Pill-shaped, min-height `48px`, background `transparent`, border `1.5px solid #0284C7`, text `#0284C7` (Dark mode: text `#38BDF8`, border `#38BDF8`).
- **Ghost/Tertiary Action:** Min-height `44px`, padding `12px 16px`, text `#475569` (Dark: `#94A3B8`), hover background `rgba(15, 23, 42, 0.04)`.

### Chips & Filter Pills
- **Nutrient Tag Chips (e.g., "High Fiber", "Low GI"):** Height `32px`, padding `4px 12px`, radius `rounded-full`.
  - Neutral state: Background `#F1F5F9`, border `1px solid #E2E8F0`, text `#475569`.
  - Active Selected state: Background `#E0F2FE`, border `1px solid #0284C7`, text `#0369A1` (Dark: Background `#082F49`, border `#0284C7`, text `#38BDF8`).

### Data Lists & Dietary Item Rows
- **List Structure:** Multi-column layout with min-height `64px`, outer padding `12px 16px`, border-radius `16px`, separated by `8px` vertical spacing (never single-pixel divider lines).
- **RTL Considerations:** The leading visual icon (food thumbnail or macro indicator) automatically flips position to the right margin, maintaining `16px` gutter from the textual calorie description.

### Input Fields & Search Bars
- **Height & Style:** `48px` minimum height, border-radius `12px`. Light background `#FFFFFF`, border `1.5px solid #CBD5E1`. 
- **Focus State:** Border color shifts to `#10B981` with a `0 0 0 3px rgba(16, 185, 129, 0.15)` focus ring.
- **RTL Support:** Trailing unit indicators (e.g., "g", "kcal", "mg") anchor to the left side in RTL contexts with localized Arabic numerals.

### Health Cards & Telemetry Pods
- **Card Enclosure:** Radius `16px`, padding `20px`. Must contain clear semantic division: Header (Label + Info Icon), Core Value (`metric-num` paired with small unit baseline label), and Target Status Bar.
- **Caloric & Macro Circular Gauges:** Stroke thickness `8px`, track background `#E2E8F0` (Dark: `#334155`), active track green `#10B981`, blue `#0284C7`, orange `#F97316`.

### Checkboxes & Segmented Toggles
- **Toggles:** Native switch height `28px`, width `52px`, thumb `24px` white pill. Active track fills with `#10B981`.
- **Checkboxes:** `20px × 20px` with `6px` radius (`rounded-md`). Checked state fills `#10B981` with crisp white SVG checkmark. Target boundary remains padded to `44px × 44px` minimum hit-box.