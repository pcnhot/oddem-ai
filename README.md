# ODDEM — Flutter MVP

ODDEM is a Saudi **AI + AR interior design and furniture shopping** app. This
repository contains the Flutter mobile MVP (iOS/Android), Arabic‑first and RTL,
built with clean architecture and Riverpod and a backend‑ready data layer.

## Highlights

- 🇸🇦 **Saudi‑first**: Arabic RTL UI, SAR pricing, Saudi cities.
- 🎨 **Brand palette**: `#34404C`, `#1E3246`, `#FFFFFF`, `#DCDCDC`, `#969696`.
- 🧱 **Clean architecture**: `app / core / features / shared`.
- 🧩 **Riverpod** for state management.
- 🔌 **Backend‑ready**: every feature talks to a repository interface; mock
  implementations are the only seam a real API has to replace.
- 🤖 **AI Designer** recommends products by room type, budget, style and
  dimensions, including **StrictMode** (change only one item, keep the rest).
- 🛠️ **Installation ETA** is computed **only at checkout** from the selected
  city + supplier availability, shown as an approximate range (never a fixed
  promise). No Base44, no fixed‑hours install claim.

## Project structure

```
lib/
  app/            # MaterialApp, router, bottom-nav shell
  core/           # theme, constants, utils (no feature deps)
  features/
    splash/ onboarding/ auth/ home/ catalog/ ai_designer/
    planner/ ar/ favorites/ cart/ checkout/ account/ help/
      data/         # repository interface + mock implementation
      presentation/ # screens + Riverpod providers
  shared/
    models/       # Product, Category, Supplier, CartItem, Order, ...
    data/         # MockData (single in-memory source of truth)
    widgets/      # ProductCard, AppImage, EmptyState, ...
```

Each feature follows `data/` (repositories) + `presentation/` (screens +
providers). Data models live in `shared/models`. When the backend is ready,
swap each `Mock*Repository` for an API client in the corresponding
`*RepositoryProvider` — no UI changes required.

## Getting started

```bash
flutter pub get
flutter run          # run on a device/emulator
flutter test         # run unit tests
```

> Requires Flutter 3.3+ (Dart 3). The app bundles no image/font assets yet, so
> product images render a branded placeholder until assets/URLs are wired in.
> To use the Arabic font referenced in the theme, add Tajawal/Cairo to
> `assets/fonts/` and declare it under `flutter: fonts:` in `pubspec.yaml`.

## Implementation order (how this MVP was built)

1. **Foundation** — `pubspec.yaml`, lint rules, `core/theme` (colors, text
   styles, theme), `core/constants`, `core/utils`.
2. **Domain models** — `shared/models` (Product with SKU/supplier/price/
   dimensions/colors/material/stock/GLB/USDZ, Category, Supplier, CartItem,
   RoomDimensions, AiDesignRequest/Result, Order + InstallationEstimate).
3. **Mock data** — `shared/data/mock_data.dart` (products, categories,
   suppliers).
4. **Repositories + providers** — catalog, auth, cart, favorites, AI designer,
   checkout. Interfaces first, mock implementations behind providers.
5. **Reusable widgets** — `shared/widgets` (ProductCard, AppImage, EmptyState,
   SectionHeader, QuantitySelector).
6. **Screens** — splash → onboarding → auth → home → catalog → product detail →
   AI designer (+ photo upload, dimensions) → 2D planner / AR placeholders →
   favorites → cart → checkout → order confirmation → account → help.
7. **Routing + shell** — `app/router.dart` (go_router with a 5‑tab
   `StatefulShellRoute`) and `app/main_shell.dart`.
8. **App + entry** — `app/app.dart` (RTL + Arabic locale + theme) and
   `main.dart` (`ProviderScope`).
9. **Tests** — `test/cart_test.dart` smoke tests for cart logic.

## Backend integration checklist

- Implement `CatalogRepository`, `AuthRepository`, `AiDesignerRepository`,
  `CheckoutRepository` against your API and override the matching
  `*RepositoryProvider`.
- Keep the `Product` JSON contract (see `assets/data/products.json`).
- Wire AR placeholders to a real viewer using `glbUrl` (Android) /
  `usdzUrl` (iOS).
- Implement image picking in `RoomPhotoUploadScreen` (e.g. `image_picker`).
