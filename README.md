# Gendec - Generador de Fracciones

Aplicación Flutter para calcular fracciones generatrices a partir de decimales.

## Características

- Convierte decimales periódicos a fracciones
- Calcula el período y anteperíodo
- Genera la fracción generatriz completa

## Instalación

```bash
flutter pub get
flutter run
```

## Construcción

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release --no-codesign
```

## GitHub Actions

El proyecto incluye workflows para:
- **Android Build**: Compila y genera APK en cada push a main
- **iOS Build**: Compila y genera IPA en cada push a main

## Licencia

MIT
