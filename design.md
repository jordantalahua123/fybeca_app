# Design system — Fybeca Tarjeta Empresarial

This documents the visual language used across the app: where each token came
from, how it's implemented, and how each screen maps to the reference design
(the `localhost:4200/login` web mockups the app is based on). If you're adding
a new screen, start here before hardcoding a color or a spacing value.

## Source of truth

Colors are **not guessed**. They were extracted directly from Fybeca's live
production CSS (`fybeca.com`) and by sampling pixels from the official logo
PNG served from that site — not from the internal web mockup screenshots
(which are a prototype, not brand guidelines). Typography is likewise taken
from the production site's `font-family` declarations. If the brand palette
ever changes, re-extract from the live site rather than eyeballing screenshots.

## Color palette

All tokens live in `lib/core/theme/app_colors.dart`. Never hardcode a hex
value in a widget — reference `AppColors.x`.

| Token | Hex | Source | Used for |
|---|---|---|---|
| `primaryNavy` | `#203A5D` | fybeca.com custom CSS, confirmed by logo pixel sample (`#1F3C68`) | Brand color: logo, headers, virtual card background, primary text on light surfaces, secondary actions |
| `primaryBlue` | `#2558A4` | fybeca.com CSS (links, borders) | Tertiary accent |
| `accentCyan` | `#00C7EB` | fybeca.com CSS (most frequent accent — search button, link hovers) | Info accent |
| `brandRed` | `#E40520` | fybeca.com CSS + logo dot pixel sample (`#ED192D`) | **Primary action color** — every primary CTA ("Ingresar a mi cuenta", "Generar código de seguridad", "Volver a generar") is red, matching the reference mockups |
| `brandOrange` | `#FF8700` | fybeca.com CSS (badges/pills) | Warning semantic |
| `brandGreen` | `#0B6040` | fybeca.com CSS (table headers) | Success semantic |
| `textPrimary` | `#212529` | fybeca.com CSS | Default body text |
| `textSecondary` | `#5C5C5C` | fybeca.com CSS | Secondary/muted text |
| `mutedBlueGray` | `#888FA4` | fybeca.com CSS | Icons, disabled/tertiary text |
| `surfaceLight` | `#F5F5F5` | fybeca.com CSS | Form field fill, subtle card backgrounds |
| `border` | `#DEE2E6` | fybeca.com CSS | Hairlines, unselected card borders |

`ColorScheme.primary = brandRed`, `secondary = primaryNavy`,
`tertiary = primaryBlue` (see `app_theme.dart`) — this is why every
`ElevatedButton` in the app is red by default without each page having to say
so.

## Typography

Source: `font-family` declarations on fybeca.com (`Ubuntu` for nearly all UI
text — buttons, banners, breadcrumbs; `Montserrat Bold` for select emphasized
headings). Loaded via `google_fonts` (no bundled font assets needed).

`lib/core/theme/app_text_styles.dart`:

| Style | Font | Size | Weight | Used for |
|---|---|---|---|---|
| `displayLarge` | Montserrat | 32 | 700 | Big numeric displays (the 8-digit security code) |
| `headline` | Ubuntu | 24 | 700 | Screen titles ("Ingresa a tus tarjetas", "Muéstralo al dependiente") |
| `title` | Ubuntu | 18 | 500 | Card/section titles |
| `body` | Ubuntu | 15 | 400 | Default text |
| `bodySecondary` | Ubuntu | 14 | 400 | Muted/supporting text |
| `button` | Ubuntu | 16 | 500 | Button labels |
| `caption` | Ubuntu | 12 | 400 | Labels, hints, timestamps |

## Layout conventions

- **Corner radius**: 12px for buttons/inputs, 16px for cards, 18–20px for the
  virtual card and page-level containers.
- **Primary CTA**: full-width (`Size.fromHeight(52)`), never inline-sized,
  except the compact "Generar código" button inside `ConveniosPage`'s bottom
  bar (constrained by the row layout there).
- **Content width**: forms are wrapped in `ConstrainedBox(maxWidth: 420)` and
  centered — the app targets phones, but this keeps things sane on tablets/web.
- **Empty/error/loading states are first-class**, not afterthoughts: every
  BLoC-driven screen (`HomePage`, `ConveniosPage`, `SecurityCodePage`)
  explicitly renders a loading spinner, an error panel, and (for convenios) an
  empty state — because the reference design's "Mockups interactivos: Con
  convenios / Sin convenios" toggle calls out both states as first-class
  product states, not edge cases.

## Components (`lib/core/widgets/`)

- **`AppLogo`** — self-contained navy badge with the "Fybeca" wordmark
  (Ubuntu bold) and the "Única en tu vida" tagline (Montserrat italic,
  approximating the script tagline in the real logo — there is no bundled
  script font, so this is a deliberate simplification, not a pixel-perfect
  trace). Carries its own navy background, so it can sit on any page
  background.
- **`AppButton`** — primary (`ElevatedButton`) or `outlined: true`
  (`OutlinedButton`), with a built-in `isLoading` spinner state. Always use
  this instead of raw `ElevatedButton`/`OutlinedButton` for CTAs so loading
  states stay consistent.
- **`AppTextField`** — wraps `TextFormField` with the shared
  `InputDecorationTheme` (filled, no visible border until focused/error).
- **`VirtualCard`** (`features/tarjeta/presentation/widgets/`) — the navy
  gradient card with chip, masked number, and available credit. Used on Home
  for the aggregate total; reusable if a per-convenio card view is added later.

## Screen-by-screen mapping to the reference mockups

The reference is a **desktop web app**; this is a **mobile app**, so layouts
were adapted, not traced 1:1. Below is what changed and why.

**Navigation model** (added after the initial pivot, not in the original
mockups): the reference is a single scrolling page with an interactive
"Con convenios / Sin convenios" mockup toggle. The app instead uses a
standard mobile pattern — a bottom `NavigationBar` with three destinations
(Inicio, Convenios, Código) switching between tab bodies kept alive in an
`IndexedStack` — so the three functional screens below are reachable at any
time without back-stacking through them. Since generating a code without
having chosen a convenio doesn't make sense, tapping "Código" before a code
has ever been generated shows an `AlertDialog` explaining the 3 steps
(elegir convenio → generar código → mostrarlo al pagar) with a button that
jumps straight to the Convenios tab, instead of either silently blocking the
tab or landing on a confusing empty screen.

### 1. Login (`features/auth/presentation/pages/login_page.dart`)

Reference: two-column desktop layout (dark hero copy on the left, white login
card on the right). **Adapted to**: a single navy-background column — logo
badge + tagline up top, white card (red top border accent, matching the
mockup's card) below with the form. The desktop hero copy ("Tu cupo
empresarial, siempre contigo") survives as a one-line subtitle under the logo
instead of a full hero section, since a mobile login screen shouldn't need
marketing copy before the form.

Fields: `Número de identificación` (cédula, numeric keyboard) +
`Contraseña` (obscured, with a `Ver`/`Ocultar` text toggle — the mockup uses
the same "Ver" label, not an eye icon, so that was kept literally). The demo
access hint box ("Acceso de demostración… Completar datos") is tappable and
autofills both fields — same affordance as the reference.

No Google/Microsoft/registration UI exists on this screen — the reference
design doesn't have it either (corporate-provisioned access only).

### 2. Inicio tab (`features/home/presentation/pages/home_page.dart`)

Reference: a marketing/landing page with a large promotional virtual card
showing `$851.25`. That number is not arbitrary — it's the **sum of the three
convenios** shown later in the flow ($250.00 + $480.75 + $120.50). The app
reproduces this deliberately: `ConveniosLoaded.cupoTotal` sums every
convenio's available credit, and `HomePage` renders that total in a
`VirtualCard`, so the number is always internally consistent with the
convenios list rather than a hardcoded figure. Its "Generar código de
seguridad" CTA switches the shell to the Convenios tab (`onGenerateCodeTap`
callback from `MainShell`) rather than pushing a route — you still have to
pick a convenio there before a code can exist.

### 3. Convenios tab (`features/tarjeta/presentation/pages/convenios_page.dart`)

Direct match to the reference "Selecciona tu convenio" screen: one card per
convenio (label, name, masked card number, available credit, selection
state), an "N activos" chip, and a sticky bottom bar with "¿Listo para
comprar?" + the CTA that generates the code. Selecting a card updates
`ConveniosBloc`'s `selectedConvenioId`; the bottom CTA calls `onGenerate`
(wired by `MainShell` to dispatch `SecurityCodeGenerateRequested` and switch
to the Código tab) with the currently `selected` convenio.

### 4. Código tab (`features/tarjeta/presentation/pages/security_code_page.dart`)

Direct match to the reference "Muéstralo al dependiente" screen: 8-digit code
split into two groups of 4 (tap to copy — added as a small mobile-native
affordance, not in the original desktop mockup, but a natural fit for a
number the user needs to relay verbally or hand to a cashier), a live
`mm:ss` countdown, "Volver a generar" / "Simular uso en caja" actions, and the
selected-convenio detail panel + "Protección del código" info box below (the
reference has this panel beside the code on desktop; here it's stacked below,
since there's no room for a side-by-side layout on a phone). Before any code
has been generated, this tab isn't reachable directly — see "Navigation
model" above.

## What's simulated vs. real at this stage

Everything is a working, navigable UI backed by in-memory mocks
(`AuthMockDataSource`, `TarjetaMockDataSource`) — there is no network call
anywhere yet. Specifically simulated:

- Login only recognizes one hardcoded employee (CI `1720123456`).
- The 3 convenios and their available credit are hardcoded.
- The security code is a random 8-digit string with a real 5-minute countdown
  (the countdown logic itself is real, just not backed by a server-issued
  expiry).
- "Simular uso en caja" just marks the code as used locally — no real
  transaction, no server call.

When the Spring Boot backend is ready, only the `*RemoteDataSource`
implementations need to change (see CLAUDE.md's Architecture section) — the
BLoCs, pages, and this design system stay exactly as they are.
