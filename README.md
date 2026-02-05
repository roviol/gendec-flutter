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

#### Simulador (sin cuenta de Apple Developer)
```bash
flutter build ios --debug --simulator --no-codesign
```

#### IPA para dispositivo físico

Para instalar en un iPhone físico se necesita un archivo `.ipa` firmado.

**Requisitos:**
- [Apple Developer Account](https://developer.apple.com) ($99/año)
- Certificado de distribución (se genera desde el portal de Apple Developer)
- Provisioning Profile (vincula app + certificado + dispositivos)
- App ID registrado (`com.racoya.gendec`)

**Generar el `.ipa`:**
```bash
flutter build ipa --release --export-options-plist=ios/ExportOptions.plist
```
El archivo queda en `build/ios/ipa/`.

#### Alternativa gratuita para testing local

Si solo querés probar en tu propio iPhone sin publicar:

1. Conectar el iPhone a tu Mac por USB
2. Abrir `ios/Runner.xcworkspace` en Xcode
3. Usar una Apple ID gratuita (sin los $99) como "Personal Team" en Signing & Capabilities
4. Darle Run directamente al dispositivo desde Xcode

Esto genera un build de desarrollo que dura 7 días y solo funciona en tu dispositivo.

## GitHub Actions

El proyecto incluye workflows para:
- **Android Build**: Compila y genera APK en cada push a main
- **iOS Build**: Compila y genera IPA en cada push a main

## Licencia

MIT
