import 'dart:ui';

/// Repository for loading translation file as [Map]
abstract class TranslationFileRepository {
  /// Method for loading translation file for given locale [locale] as map. Implementation can fully use locale or just country code.
  /// No exception should be handled by this implementation and any error should be propagated to upper layer.
  Future<Map<String, String>> loadTranslationFileByLocale(Locale locale);

  /// Method for loading translation file with its name.
  /// No exception should be handled by this implementation and any error should be propagated to upper layer.
  Future<Map<String, String>> loadTranslationFileByName(String fileName);
}
