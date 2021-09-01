Simple library for loading translations from assets folder. Library should be used with _GetX_ or some similar framework
as it just loads files as `Map<String, String>`.

Two file formats of translation files are supported:
- `json`
- `properties`

## Features

- simplified internationalization
- supported `json` and `properties` files
- all keys from json file are converted as `object1.object2.value` so that they are the same as in `properties` file

## Getting started

You need to configure assets folder with your translation files. For instance:

```yaml
flutter:
  uses-material-design: true

  assets:
    - assets/i18n/
```

Inside that folder you need to put all your translation files. Library does NOT use _countryCode_ of the _Locale_, just _languageCode_.

For example:

_en.json_
```json
{
  "app": {
    "name": "Test application",
    "version": "1",
    "bar": {
      "title": "My title"
    }
  }
}    
```

_hr.properties_
```properties
app.name=Testna aplikacija
app.version=1
app.bar.title=Moj naslov
```

And that is it, you just need to configure library inside main application and you'll have all your translations.

__NOTE__: You need to include _flutter_localization_ in your pubspec:

```yaml
#....
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter

  cupertino_icons: ^1.0.3
#....
```

## Usage

To get translations, you just need to use static method `loadTranslations` inside `TranslationsLoader` class. For instance: `TranslationsLoader.loadTranslations("assets/i18n")`.

To use this library with GetX library, you need to implement `Translations` class:

```dart
class ApplicationTranslations extends Translations {
  final Map<String, Map<String, String>> _translationKeys;

  ApplicationTranslations(this._translationKeys);

  @override
  Map<String, Map<String, String>> get keys => _translationKeys;
}
```

Then you can use it when setting your `GetMaterialApp`:
```dart
Future<void> main() async {
  // ...

  runApp(GetMaterialApp(
    translations: ApplicationTranslations(await TranslationsLoader.loadTranslations("assets/i18n")),
    locale: Get.deviceLocale,
    fallbackLocale: defaultLocale,
    supportedLocales: supportedLocales,
    localizationsDelegates: const [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    // .....
  ));
}
```

## Additional information
![alt text](example.gif "Example")