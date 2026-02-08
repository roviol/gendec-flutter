# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Gendec (Generador de Fracciones) is a Flutter app that converts periodic decimals into their generatrix fractions. The UI is in Spanish. Migrated from an Ionic/Angular project.

## Common Commands

```bash
flutter pub get                    # Install dependencies
flutter run                        # Run in debug mode
flutter test                       # Run all tests
flutter test test/calculator_test.dart  # Run a single test file
flutter test --coverage            # Run tests with coverage report
flutter analyze                    # Run static analysis (linting)
flutter build apk --release        # Build Android APK
flutter build ios --debug --no-codesign  # Build iOS (simulator)
```

## Architecture

Single-screen app with a simple three-layer structure:

- **`lib/main.dart`** — App entry point, `GendecApp` widget, and `HomePage` (the only screen). Uses `StatefulWidget` with `setState()` for state management. No routing library.
- **`lib/services/calculator_service.dart`** — `CalculatorService` contains all business logic. The `calcula(double decimal, int periodo)` method splits a decimal into integer, ante-period, and period parts, then computes the numerator/denominator of the generatrix fraction. Uses a restricted `_safeEval()` that only handles addition/subtraction.
- **`lib/models/calculation_result.dart`** — `CalculationResult` data class. The `resultado` field is `dynamic`: it holds an `int` on success or a `String` error message on failure. The `hasError` getter checks `resultado is String`.

## Testing

- Tests live in `test/calculator_test.dart` — unit tests for `CalculatorService` only (no widget tests).
- 5 test cases covering: no-period fractions, period 1 and 2, error when period exceeds decimal length, integer result.

## CI/CD

Two GitHub Actions workflows (`.github/workflows/`), both triggered on push to main and PRs:

- **`android.yml`** — Analyzes, tests, builds APK + AAB. Uses Java 17 / Flutter 3.19.0. Reads signing secrets (`KEYSTORE_BASE64`, `KEYSTORE_PASSWORD`, `KEY_PASSWORD`, `KEY_ALIAS`); falls back to debug signing without them.
- **`ios.yml`** — Analyzes, tests, builds IPA (signed) or simulator build (unsigned). Uses signing secrets (`IOS_P12_BASE64`, `IOS_P12_PASSWORD`, `IOS_MOBILEPROVISION_BASE64`, `IOS_TEAM_ID`, `IOS_BUNDLE_ID`, `IOS_PROVISIONING_PROFILE_NAME`). Injects signing settings directly into `project.pbxproj` via Perl. Falls back to `flutter build ios --debug --no-codesign` without secrets.

Both workflows run `flutter analyze` and `flutter test --coverage` as gates before building. See `SIGNING_SETUP.md` for secret configuration details.

## Key Conventions

- Material Design 3 with blue color seed
- Dart SDK >=3.0.0 <4.0.0, Flutter SDK >=3.19.0
- Android: applicationId `com.racoya.gendec`, minSdk 21
- Linting via `flutter_lints` with `avoid_print`, `prefer_const_constructors`, `prefer_const_declarations` rules
- Commit messages use conventional commits (`fix:`, `feat:`, `chore:`, `test:`)
