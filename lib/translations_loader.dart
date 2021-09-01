library translations_loader;

import 'dart:ui';

import 'src/data/repositories/translation_file_repository_impl.dart';
import 'src/translations_loader_methods.dart';

/// Use to load assets translations. You need to provide valid assets folder path, otherwise, you will get exception.
/// You should call use this class only once, on application start just to load translations
class TranslationsLoader {
  /// [assetsTranslationsPath] path to the folder, inside assets, which contains translation files. With [supportedLocales] you can provide
  /// which locales should be loaded. If you do not provide this, all files inside that folder are loaded.
  static Future<Map<String, Map<String, String>>> loadTranslations(
      String assetsTranslationsPath,
      [List<Locale>? supportedLocales]) async {
    if (assetsTranslationsPath.isEmpty) {
      throw Exception("Given assetsTranslationsPath is empty!");
    }

    final repository = TranslationFileRepositoryImpl(assetsTranslationsPath);

    if (null != supportedLocales && supportedLocales.isNotEmpty) {
      return loadTranslationsForLocales(supportedLocales, repository);
    } else {
      return loadAllTranslationsFromAssets(assetsTranslationsPath, repository);
    }
  }
}
