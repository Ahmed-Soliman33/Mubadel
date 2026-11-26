# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Current state

The repo contains `PRD.md` (written in Egyptian Arabic, ~770 lines) and a `design/` folder of Figma exports. There is no Flutter project or git history yet. `PRD.md` is the source of truth: it contains the full Supabase SQL script (§8.3), screen specs (§6), design tokens (§3) and the acceptance checklist (§11). Read the relevant section before building a feature.

The files in `design/` are WhatsApp-named JPEGs (`WhatsApp Image 2026-11-26 at 1.50.4x AM (n).jpeg`), not the `00_logo.jpg` … `10_chat.jpg` names the PRD §2 assumes. Open the images to identify which screen each is before mapping them. Follow them pixel-for-pixel for anything the PRD doesn't specify, and copy the logo to `assets/images/logo.png` (as PNG) when scaffolding.

## What Mubadel is

Flutter (Android + iOS) marketplace app for swapping/selling used items in Egypt. Backend is Supabase (Auth, Postgres, Storage, Realtime). Single user type (every user is buyer and seller). Arabic (default, RTL) and English (LTR). Currency EGP. Out of scope (Phase 2): online payments, push notifications, chat images, admin dashboard, counter-offers, blocking/reporting (PRD §9).

## Commands (once the project is scaffolded)

Config is supplied via `env.json` at the project root (git-ignored) containing `SUPABASE_URL` and `SUPABASE_ANON_KEY`, read via `--dart-define-from-file`. Never use or commit the `service_role` key.

```
flutter run --dart-define-from-file=env.json
flutter build apk --release --dart-define-from-file=env.json
flutter analyze            # must pass with no errors
flutter gen-l10n           # regenerate after editing lib/l10n/app_ar.arb / app_en.arb
flutter test test/path_test.dart   # single test file
```

## Architecture

- Stack: `flutter_riverpod` (state), `go_router` (a `ShellRoute` hosts the 5-tab bottom nav: home, favorites, add, messages, profile; everything else is a stack route without bottom nav), `supabase_flutter`, gen-l10n, `google_fonts` (Cairo), `image_picker` + `flutter_image_compress`.
- Layout: `lib/core/` (config/env, theme, router, shared widgets, formatters) plus `lib/features/<auth|home|products|offers|chat|favorites|profile>/` each split into `data/` and `presentation/`.
- Auth guard: any non-auth route without a session redirects to `/login`. Splash skips to Home if a session exists. "Remember me" unchecked means `signOut` on next app launch.

### Offer lifecycle (core domain logic, lives in Postgres)

`pending → accepted → completed`, with `rejected` / `cancelled` branches. Accepting reserves the involved products, auto-rejects competing pending offers on them, and creates or links a conversation. Completing marks products `swapped`/`sold` and increments `swaps_count`. Cancelling an accepted offer returns products to `available`. Chat, call button, banners and the review prompt are all driven by the linked offer's status.

## Rules that are easy to get wrong

- **Never `select('*')` on `profiles`.** Column-level grants hide `phone` and `address` from the public. Select only the granted columns (`id, full_name, city, avatar_url, is_verified, rating_avg, rating_count, swaps_count, created_at`). Use RPC `get_my_profile` for the user's own full profile and `get_peer_phone(conversation_id)` for the counterpart's phone (only works after accepted/completed).
- **Offer state changes go only through RPCs** (`accept_offer`, `reject_offer`, `cancel_offer`, `complete_offer`), never direct updates. Offers are *inserted* directly (RLS validates ownership and availability). Conversations are created only via RPC (`start_conversation`, `accept_offer`). Unread state uses `mark_conversation_read`.
- Offer `cash_amount` means the sender's extra cash for swaps, and the product price for buy requests.
- Image upload: compress to 1280px width at quality 75; storage path must be `{auth.uid}/{uuid}.jpg` (storage RLS checks the first folder equals the uid). Buckets: `product-images`, `avatars`. Max 6 images per product, the first is the cover.
- Use directional APIs everywhere (`EdgeInsetsDirectional`, `AlignmentDirectional`); mirror arrow icons by direction. Must have no overflow at 360px in both RTL and LTR.
- Every screen needs loading, empty, and error (with retry) states; lists need pull-to-refresh.
- Unified listing-type labels: `both` = "بيع أو تبديل", `swap` = "للتبديل فقط", `sale` = "للبيع فقط".
- Number formatting: Arabic uses Hindi digits via `NumberFormat.decimalPattern('ar_EG')` with "ج.م"; English uses `EGP 12,500`.
- PRD §3 lists deliberate corrections to the Figma designs (forgot-password link is green, signup button reads "سجّل دخول", no video icon in chat header, offer screen has no bottom nav). Apply them.
- Supabase dashboard setup (PRD §8.1): email provider on, "Confirm email" off, min password length 6, and the Reset Password email template must show `{{ .Token }}` (the app uses an OTP flow via `verifyOTP(type: OtpType.recovery)`, not a link).
