# HO gids 2022
> Gids voor de Herfstontmoeting van Scouts en Gidsen Vlaanderen.

Om aanpassingen aan nieuws, het programma of de kaart te maken, zie [HANDLEIDING.md](/HANDLEIDING.md).

## Installatie
1. Installeer flutter: [Get started](https://docs.flutter.dev/get-started/install).
2. De app source code zit in `lib/` en `assets/`.
3. Als je IDE dit niet doet, run `flutter pub get`.

## Development
1. Het is aangeraden om [VSCode](https://code.visualstudio.com/) te gebruiken met de [Flutter extensie](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter).
2. Anders kan je gebruik maken van `flutter run` ([meer documentatie](https://docs.flutter.dev/get-started/test-drive?tab=terminal))
3. De data voor de kaart kan bewerkt worden met een [GeoJson editor](https://geojson.io/).

### Automatisch genereren van bestanden
Enkele delen van de app worden automatisch gegenereerd. Bij het aanpassen van de configuratie (in `pubspec.yaml`) of bron bestanden moeten volgende commands uitgevoerd worden:
1. [Launcher icons](https://pub.dev/packages/flutter_launcher_icons): `flutter pub run flutter_launcher_icons`
2. [Splash screens](https://pub.dev/packages/flutter_native_splash): `flutter pub run flutter_native_splash:create`
3. [Json parsers](https://pub.dev/packages/json_serializable): `flutter pub run build_runner watch --delete-conflicting-outputs`

Voor de notification icon moet Android Studio gebruikt worden. De source is `assets/icons/notification.png`. Volg dan de stappen [hier](https://developer.android.com/studio/write/create-app-icons#create-notification).

## Deployment
1. [Instructions voor Android](https://docs.flutter.dev/deployment/android)
2. [Instructions voor iOS](https://docs.flutter.dev/deployment/ios)
