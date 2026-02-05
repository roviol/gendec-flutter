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

## Key Conventions

- Material Design 3 with blue color seed
- Dart SDK >=3.0.0 <4.0.0, Flutter SDK >=3.19.0
- Linting via `flutter_lints` with `avoid_print`, `prefer_const_constructors`, `prefer_const_declarations` rules
- CI runs `flutter analyze` and `flutter test --coverage` on every push to main and on PRs (see `.github/workflows/`)
