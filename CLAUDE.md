# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project overview

**Fybeca — Tarjeta Empresarial** is the mobile counterpart of Fybeca's internal
"Tarjeta Empresarial" web portal: an employee benefits app. Corporate employees
log in with their cédula (national ID) and a company-assigned password, see the
total credit available across the corporate agreements ("convenios") they're
enrolled in (Fybeca, Sana Sana, employee card, etc.), pick one, and generate an
8-digit, 5-minute, single-use security code to show at checkout.

There is **no self-registration and no social login** — access is provisioned
by the company, matching the reference web portal (`localhost:4200/login` in
the original mockups).

**Current stage:** front-end only. Every data source is an in-memory mock
(`*MockDataSource`) — there is no network layer wired up yet. The goal at this
stage is a fully navigable app with the real visual design; screens show
realistic data and real loading/error states, but nothing persists past a hot
restart. The backend will be **Spring Boot** (decided by the company) — not
Node.js/Firebase — so no backend client exists yet; when it's ready, only the
`*RemoteDataSource` implementations change (see Architecture below).

## Common commands

```bash
flutter pub get              # install dependencies
flutter run                  # run on a connected device/emulator
flutter run -d chrome        # run in Chrome (fastest loop for UI work)
flutter analyze              # static analysis — must be clean before committing
flutter test                 # widget tests
dart format lib test         # format (CI-equivalent formatting)
flutter build apk            # Android release build
```

There is no `flutter build ios` target verified yet (not tested on this repo).

## Architecture: Clean Architecture + BLoC, feature-first

```
lib/
  core/                     # shared across all features
    theme/                  # AppColors, AppTextStyles, AppTheme — the only place colors/fonts are defined
    di/locator.dart         # get_it service locator — every dependency is wired here
    error/                  # Failure (domain-facing) and Exception (data-facing) types
    usecases/usecase.dart   # UseCase<Success, Params> base contract
    utils/validators.dart   # shared form validators
    widgets/                # AppButton, AppTextField, AppLogo — reusable, theme-driven
  features/
    auth/
      data/                 # UserModel, AuthMockDataSource, AuthRepositoryImpl
      domain/                # UserEntity, AuthRepository (interface), use cases
      presentation/          # AuthBloc, LoginPage, AuthWrapper
    tarjeta/                 # convenios + security code
      data/ domain/ presentation/
    home/
      presentation/pages/home_page.dart   # "Inicio" tab content (aggregate virtual card)
    shell/
      presentation/pages/main_shell.dart  # authenticated shell: bottom nav + shared BLoCs
  app.dart                  # MaterialApp + root AuthBloc
  main.dart                 # setupLocator() + runApp()
```

Each feature is self-contained and split into three layers:

- **domain** — entities and repository *interfaces* only. Zero Flutter imports,
  zero knowledge of mocks, JSON, or HTTP. This is what BLoCs depend on.
- **data** — implements the domain repository interface using one or more
  `*RemoteDataSource`/`*LocalDataSource`. Currently every remote data source is
  a `*MockDataSource` (in-memory, `Future.delayed` to simulate latency).
- **presentation** — BLoC (events/states) + pages/widgets. Never imports
  anything from `data/`.

**Why this matters for future work:** swapping the mock for the real Spring
Boot API is a one-file change per feature — replace the `*RemoteDataSource`
registration in `core/di/locator.dart` (e.g. `AuthMockDataSource` →
`AuthApiDataSource`) — because everything above the data layer only talks to
interfaces. Don't shortcut this by making a BLoC or page reach into a
`*MockDataSource` directly.

### Dependency injection

Everything is registered in `core/di/locator.dart` via `get_it`, called once
in `main()` before `runApp()`. Repositories and use cases are
`registerLazySingleton`; BLoCs are `registerFactory` (a fresh instance per
screen/subtree — see navigation note below).

### Navigation: a bottom-nav shell, not pushed routes

Once authenticated, the app is **one screen** — `MainShell`
(`features/shell/presentation/pages/main_shell.dart`) — with a
`NavigationBar` (Inicio / Convenios / Código) switching between three bodies
kept alive in an `IndexedStack`. There is **no `Navigator.push`** between
these three; switching tabs is just `setState(() => _index = ...)`. This was
a deliberate pivot away from the earlier push-based flow (see "Provider-scope
gotcha" below for why) and is also what makes state survive tab switches for
free — `IndexedStack` keeps every tab's widget (and its `BlocBuilder`
subscriptions) mounted, it just hides the inactive ones.

`HomePage`, `ConveniosPage`, and `SecurityCodePage` are **tab bodies, not
screens** — none of them has its own `Scaffold`/`AppBar`/`BlocProvider`.
`MainShell` owns `ConveniosBloc` and `SecurityCodeBloc` as `late final`
fields (created once in `initState`, closed in `dispose`) and shares both
with every tab via `MultiBlocProvider(providers: [BlocProvider.value(...), ...])`
wrapping the `IndexedStack`. If you add a fourth tab, follow this pattern:
plain body widget, no own Scaffold, reads shared BLoCs via `context.read`/
`context.watch`, and any inter-tab action (e.g. "go generate a code") is a
callback passed in from `MainShell`, not a `Navigator.push`.

**The gate before "Código":** you can't jump to the code tab without having
picked a convenio and generated a code first. `MainShell._onDestinationSelected`
intercepts the tap on index 2: if `SecurityCodeBloc.state is SecurityCodeInitial`,
it shows an `AlertDialog` with the 3 steps instead of switching tabs (see
`_showStepsRequiredDialog`). Once a code exists (active, expired, or used),
direct taps go straight through — the gate is "has a code ever been
generated", not "is a convenio explicitly selected" (there's always a default
selection once convenios load, so that alone can't be the gate).

**Provider-scope gotcha (historical, keep in mind for any *new* pushed
route):** `Navigator.of(context).push(...)` pushes onto the **root** Navigator
owned by `MaterialApp`, which sits *above* any `BlocProvider` a tab/page
declares for itself. Early in this pivot, `ConveniosPage` was a pushed route
that assumed it could `context.read<ConveniosBloc>()` from an ancestor
`BlocProvider` declared in `HomePage` — it couldn't, because a pushed route
is a sibling on the root Navigator, not a descendant of whatever provider a
page declared for its own subtree. That threw `ProviderNotFoundException` at
runtime, and was only caught by driving the app in a real browser (`flutter
analyze` does not catch it). The fix at the time was "every pushed page
provides its own BLoC instance"; the *current* fix was removing the pushes
entirely in favor of the shell. If you ever reintroduce a genuinely separate
pushed screen (e.g. a settings page), give it its own `BlocProvider` at the
top of its `build()` rather than assuming it inherits one.

### Auth flow

`AuthBloc` lives at the app root (`app.dart`), created once and kept alive for
the whole session — this is the one BLoC that's intentionally shared across
the entire navigation stack, because `AuthWrapper` (`features/auth/presentation/pages/auth_wrapper.dart`)
needs it to decide between `LoginPage` and `MainShell`. It has 5 states:
`AuthInitial` → `AuthSessionChecking` (startup only) → `AuthAuthenticated` /
`AuthUnauthenticated` / `AuthFailureState` / `AuthLoading` (login-in-flight).
`AuthSessionChecking` is deliberately separate from `AuthLoading` so that
submitting the login form doesn't blow away the `LoginPage` and its form state
by swapping in the root splash screen — only `AuthWrapper` treats
`AuthSessionChecking` as "show splash"; `AuthLoading` is handled locally by
`LoginPage`'s own `BlocBuilder` on the submit button.

Demo credentials (mock only): CI `1720123456` / password `Fybeca2026` — tap
"Completar datos" on the login screen to autofill them.

### Tarjeta feature (convenios + security code)

- `ConveniosBloc` and `SecurityCodeBloc` are both owned by `MainShell` (one
  instance of each for the whole authenticated session, not per-tab) and
  shared with `HomePage`/`ConveniosPage`/`SecurityCodePage` via
  `BlocProvider.value`. `SecurityCodeBloc` owns a `Timer.periodic` that ticks
  the countdown every second and cancels itself in `close()` — don't add a
  second timer source (e.g. a `StatefulWidget` ticker) for the same countdown.
- `ConveniosBloc` loads the list of convenios and tracks which one is
  currently selected (`ConveniosLoaded.selectedConvenioId`).
  `ConveniosLoaded.cupoTotal` sums every convenio's `cupoDisponible` — this is
  what the Home dashboard card displays as the aggregate available credit.
- `SecurityCodeActive`/`SecurityCodeExpired`/`SecurityCodeUsed` all carry the
  `convenioId` the code was generated for (not just `SecurityCodeActive`).
  `SecurityCodePage` resolves the `ConvenioEntity` to display by looking up
  that id in `ConveniosBloc`'s current list — deliberately *not* by reading
  `ConveniosLoaded.selectedConvenioId`, so the code screen still shows the
  right convenio even if the user changes their selection on the Convenios
  tab without regenerating.
- `TarjetaMockDataSource` hardcodes the 3 convenios from the reference design
  (Tarjeta de Empleados $250.00, Convenio Empresarial Fybeca $480.75, Convenio
  Empresarial Sana Sana $120.50 — total $851.25, which matches the aggregate
  card shown in the original web mockup).

## Design system

See [design.md](design.md) for the full color palette (with sourcing), type
scale, and component reference. In short: colors and fonts are **never**
hardcoded in a page — always go through `AppColors` / `AppTextStyles` /
`Theme.of(context)` in `core/theme/`, so a rebrand or dark mode is a
single-file change.

## Verifying UI changes

This repo has no project-specific `run` skill yet. To visually verify a
change without a device/emulator:

```bash
flutter run -d web-server --web-port=8765 --web-hostname=127.0.0.1
```

Flutter web renders to a `<canvas>` (CanvasKit) — there is no accessible DOM
text to query. Screenshot-and-inspect (e.g. via a headless Playwright script)
is the only reliable way to verify a screen; waiting for DOM text content will
hang. Always check the browser console for uncaught exceptions in addition to
screenshotting — a provider-scope bug like the one above renders as a full-screen
red error page, not a silent failure.

If you test on an Android emulator and the app is killed right after launch
with no Dart stack trace in `adb logcat`, check for
`lowmemorykiller: ... reason: min watermark is breached even after kill` —
that's the emulator running out of RAM, not an app bug. Raise the AVD's RAM
(Device Manager → edit AVD → Additional settings → RAM / VM heap size) or use
a "Google APIs" (no Play Store) system image instead of "Google Play".

## Conventions

- **Clean Architecture layering is not optional.** `domain/` has no Flutter or
  package imports beyond `dartz`/`equatable`. `data/` never imports anything
  from `presentation/`. `presentation/` never imports from `data/`.
- **One BLoC per part-file trio**: `x_bloc.dart` declares `part 'x_event.dart'`
  and `part 'x_state.dart'` — follow the existing files as the template for
  any new BLoC.
- **Every `UseCase`** implements `UseCase<Success, Params>` from
  `core/usecases/usecase.dart` and returns `Either<Failure, Success>`.
- **Money is `double`, formatted with `toStringAsFixed(2)`** at the widget
  level (no currency/formatting package yet — introduce one only if real
  currency edge cases show up).
- **Mock data sources simulate latency** (`Future.delayed`) so loading states
  are visible and testable; keep doing this when adding new mocks rather than
  resolving instantly.
