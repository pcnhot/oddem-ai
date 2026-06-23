# CLAUDE.md — ODEEM Execution Rules

This is the operational control file for the ODEEM repository. Claude Code MUST follow it on every task in this repository. No guessing. No assumptions. Verify before acting.

---

## 1. Project Identity

ODEEM is a Saudi mobile app for furniture and interior design.

Core pillars:
- AI Interior Designer
- AR Preview
- Product List
- Real Saudi market products later

Strategic path:
- Phase 1: Supplier MVP after Q1 2026
- Phase 2: Full platform in 2027
- Phase 3: GCC expansion

---

## 2. Current Goal

Build a reviewable MVP shell within 7 days.

The first build must open, run, and demonstrate the core flow with local mock data only. Functional is more important than polish.

---

## 3. Approved System Decision

- GitHub is the source of truth.
- Claude Code is the executor.
- ChatGPT is the reviewer and planning layer.
- n8n is secondary operations only.
- n8n is not the build engine and not the command center for coding.

---

## 4. Zero-Human Build First

The first working shell must avoid permission blockers.

Hard rule for the first PR:
- No Firebase.
- No Google Auth.
- No Supabase.
- No Slack.
- No external API keys.
- No external secrets.
- No backend dependency.

Everything must be local or mock so the first build can run without setup outside the repository.

Real integrations come later and must be added behind abstractions so they can replace mock implementations cleanly.

---

## 5. Required Architecture

Use Feature-First Clean Architecture plus Riverpod.

```text
lib/
├── core/
│   ├── theme/
│   ├── routing/
│   ├── errors/
│   └── utils/
├── features/
│   └── <feature>/
│       ├── domain/
│       │   ├── entities/
│       │   ├── repositories/
│       │   └── usecases/
│       ├── data/
│       │   ├── models/
│       │   ├── datasources/
│       │   └── repositories/
│       └── presentation/
│           ├── screens/
│           ├── widgets/
│           └── providers/
└── main.dart
```

Architecture rules:
- Riverpod only for state management.
- Do not use Bloc.
- Do not use Provider.
- Do not use setState for app state.
- Domain layer must not import data or presentation.
- Entities live in domain.
- Models live in data.
- Repository interfaces live in domain.
- Repository implementations live in data.
- Features must be self-contained under `features/<feature>`.

---

## 6. Anti-Guessing Rules

1. Never guess package names, APIs, file paths, config, or dependency versions.
2. Read the repository before editing.
3. Read `pubspec.yaml` before adding dependencies.
4. If a package or API is unknown, verify it before using it.
5. If a CLAUDE.md rule conflicts with a request, follow CLAUDE.md and state the conflict.
6. If a task is ambiguous, state the ambiguity and the chosen assumption before coding.
7. Never claim done without evidence.
8. A task is not done unless `flutter analyze` and `flutter test` pass.
9. One feature per PR.
10. Do not bundle unrelated changes.

---

## 7. Issue to PR Rules

- One Issue equals one branch equals one PR.
- Branch format: `feature/<issue-number>-<short-name>`.
- PR description must include:
  - What changed
  - Issue closed using `Closes #N`
  - Verification evidence
- PR must pass `flutter analyze` with zero errors.
- PR must pass `flutter test`.
- Do not merge your own PR without review.

---

## 8. Required Commands

```bash
flutter pub get
flutter analyze
flutter test
flutter run
dart format .
flutter build apk --debug
```

A task is incomplete unless `flutter analyze` and `flutter test` pass.

---

## 9. First Screens for MVP Shell

Build the first shell in this order:

1. Local mock auth screen
   - Fake login only
   - No Firebase
   - No Google Auth
   - No external secrets

2. Home screen
   - Entry point after mock login
   - Navigation to the MVP pillars

3. AI Designer stub
   - User enters room description
   - App returns a mock design concept
   - No real AI API in first PR

4. Product List mock
   - Display mock furniture/product list from local data
   - Keep data structure ready for real supplier products later

5. AR Preview placeholder
   - Placeholder screen only
   - No ARKit/ARCore dependency in first PR unless already available and non-blocking

---

## 10. Hard Product Constraints

- No Base44.
- No fixed installation promise.
- Mobile-first only.
- Flutter for iOS and Android.
- No desktop scope for now.
- Real Saudi products come later.
- Use mock data first, structured for replacement.
- Backend comes later.
- Keep pillars: AI Designer, AR Preview, Product List.

---

## 11. Acceptance Criteria for First PR

The first PR is accepted only if all are true:

- [ ] Flutter app opens and runs on emulator without crash.
- [ ] FFCA plus Riverpod structure is in place.
- [ ] Local mock auth screen exists.
- [ ] Home screen exists.
- [ ] AI Designer stub screen exists.
- [ ] Product List screen with mock data exists.
- [ ] AR Preview placeholder screen exists.
- [ ] No Firebase.
- [ ] No Google Auth.
- [ ] No Supabase.
- [ ] No Slack.
- [ ] No external secrets.
- [ ] No external API keys.
- [ ] `flutter analyze` passes with zero errors.
- [ ] `flutter test` passes.
- [ ] `CLAUDE.md` remains at repository root.

---

## 12. Stop Conditions

Stop and report before coding if:
- The repository is not a Flutter project and a new Flutter project must be initialized.
- The required files conflict with existing app structure.
- A requested integration requires credentials, secrets, paid services, or human setup.
- A request violates Zero-Human Build First.

---

## 13. Next Execution Target

Start from GitHub Issue #6:

`Bootstrap: CLAUDE.md + Flutter MVP shell with local mock flow`

Claude Code must implement the local shell first, then open a PR that closes Issue #6.
