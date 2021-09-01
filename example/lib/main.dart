import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:translations_loader/translations_loader.dart';

const defaultLocale = Locale("en", "US");
const supportedLocales = [
  defaultLocale,
  Locale.fromSubtags(languageCode: "hr")
];

///Class which extends Get Translations
class ApplicationTranslations extends Translations {
  final Map<String, Map<String, String>> _translationKeys;

  ApplicationTranslations(this._translationKeys);

  @override
  Map<String, Map<String, String>> get keys => _translationKeys;
}

/// Main method
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(GetMaterialApp(
      translations: ApplicationTranslations(
          await TranslationsLoader.loadTranslations(
              "assets/i18n")), //can add supported locales param
      locale: Get.deviceLocale,
      fallbackLocale: defaultLocale,
      supportedLocales: supportedLocales,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const MyHomePage()));
}

///Some default page
class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('app.bar.title'.tr),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'page.home.current_lang'.tr +
                  ': ' +
                  'lang.${Get.locale?.languageCode}'.tr,
            ),
            Card(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialButton(
                      child: Text('lang.en'.tr),
                      onPressed: () => {Get.updateLocale(supportedLocales[0])}),
                  MaterialButton(
                      child: Text('lang.hr'.tr),
                      onPressed: () => {Get.updateLocale(supportedLocales[1])})
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
