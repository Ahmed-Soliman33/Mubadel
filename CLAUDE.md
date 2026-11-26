# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Mubadel (مُبدل): Flutter (Android + iOS) marketplace for swapping/selling used items in Egypt. Backend is Supabase (Auth, Postgres, Storage, Realtime). Arabic (default, RTL) + English (LTR). `PRD.md` (Egyptian Arabic) is the source of truth for scope, the full SQL schema/RLS/RPCs (§8.3), screen specs and the acceptance checklist (§11). `design/` holds the Figma exports (WhatsApp-named JPEGs; mapping to PRD §2 is by content: logo, splash, design system, login, signup, home, details, make-offer, add-product, profile, chat).

## Commands

Config comes from `env.json` (git-ignored; copy `env.example.json`) via `--dart-define-from-file`. Without it the app shows `ConfigErrorScreen`.

```
flutter run --dart-define-from-file=env.json
flutter build apk --release --dart-define-from-file=env.json   # keys are baked in at build time
flutter analyze                       # must stay at zero issues
flutter gen-l10n                      # after changing lib/l10n/*.arb
flutter test                          # smoke test only
flutter test test/path_test.dart      # single file
PREVIEW=1 flutter test test/preview --update-goldens   # renders every screen (ar+en, fake data) to test/preview/out/*.png
W=360 PREVIEW=1 flutter test test/preview --update-goldens   # same at another width; fails on any RenderFlex overflow
```

Gradle needs JDK 17 (JDK 25 breaks it): `flutter config --jdk-dir=/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home`. First Android build downloads SDK/NDK/CMake and takes ~25 min.

## Architecture

- Riverpod (`Notifier`/`FutureProvider`/`StreamProvider`), go_router, `supabase_flutter`. `lib/core/` = config, theme, router, shared widgets, formatters. `lib/features/<auth|home|products|offers|chat|favorites|profile>/{data,presentation}`: `data` has models + a `*Repository` (all Supabase calls) + providers; screens only talk to providers.
- Router (`core/router/app_router.dart`): auth guard via `redirect` + `refreshListenable` on `onAuthStateChange`. A `ShellRoute` hosts the 5-tab bottom nav (`/home /favorites /add /messages /profile`); product/offer/chat/user/settings are stack routes without the nav. Splash handles auto-login and "remember me" (unchecked → `signOut` on next launch).
- Realtime pattern: list providers call `refreshOnTableChange(ref, table, channelName)` (`offers/data/offer_providers.dart`) which subscribes to Postgres changes and `invalidateSelf()`s. Chat messages use `supabase.from('messages').stream(...)` so `read_at` updates also flow (✓✓). The nav badge = unread messages + pending incoming offers (`chat/data/unread_badge_provider.dart`).
- Offer lifecycle (`pending → accepted → completed`, plus rejected/cancelled) lives in Postgres RPCs; chat banners, call button and the review prompt are all driven by the linked offer's status.
- Strings: `lib/l10n/app_ar.arb` is the template, `app_en.arb` the translation; access via `context.l10n` (`core/utils/l10n_labels.dart`, which also has enum label extensions). No hard-coded user-facing strings.
- Fonts: Cairo is bundled in `assets/google_fonts/` and `GoogleFonts.config.allowRuntimeFetching = false`, so file names must match google_fonts' `Cairo-<Weight>.ttf` convention.

## Rules that are easy to get wrong

- **Never `select('*')` on `profiles`** (column grants hide `phone`/`address`). Use `ProfileLite.columns`; own full profile via RPC `get_my_profile`, peer phone via `get_peer_phone`.
- **Offer state changes only through RPCs** (`accept_offer`, `reject_offer`, `cancel_offer`, `complete_offer`). Offers are inserted directly (RLS validates); conversations are created only by RPC (`start_conversation`, `accept_offer`).
- Image upload: compress to 1280px/q75, path `{auth.uid}/{uuid}.jpg`, buckets `product-images` and `avatars` (`ProductRepository.uploadImage`). Max 6 images per product.
- Use directional APIs (`EdgeInsetsDirectional`, `AlignmentDirectional`, `PositionedDirectional`). The back button is deliberately on the physical left in both locales (`PageHeader`, chat header).
- Unified listing labels: `both` = "بيع أو تبديل", `swap` = "للتبديل فقط", `sale` = "للبيع فقط".
- Android release needs `INTERNET` in the main manifest (the Flutter template only adds it for debug); already added.
- The preview harness overrides repositories/providers with fakes and a `SupabaseClient` created with `autoRefreshToken: false` (otherwise a pending timer fails the test). Providers that open realtime channels must be overridden there.
