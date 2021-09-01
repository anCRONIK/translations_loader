library translations_loader;

import 'dart:collection';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:ui';

import 'package:flutter/services.dart';

import 'domain/repositories/translation_file_repository.dart';

/// Method to load all translation files from given path [assetsTranslationsPath] using given repository implementation [repository]
Future<Map<String, Map<String, String>>> loadAllTranslationsFromAssets(
    String assetsTranslationsPath, TranslationFileRepository repository) async {
  final Map<String, Map<String, String>> translationKeys =
      HashMap<String, Map<String, String>>();

  final manifestJson = await rootBundle.loadString('AssetManifest.json');
  final translationFiles = json
      .decode(manifestJson)
      .keys
      .where((String key) => key.startsWith(assetsTranslationsPath));

  for (final String fileFullPath in translationFiles) {
    final String fileName = fileFullPath
        .substring(assetsTranslationsPath.length)
        .replaceAll("/", "");
    final String localeAsString = fileName.split(".")[0];
    translationKeys[localeAsString] = HashMap<String, String>();

    try {
      translationKeys[localeAsString] =
          await repository.loadTranslationFileByName(fileFullPath);
    } catch (e) {
      developer.log('Error while loading translations for file $fileFullPath',
          error: e, level: 1000, name: "translations_loader");
    }
  }

  return translationKeys;
}

/// Method to load translation files for given locale list [locales] using given repository implementation [repository]
Future<Map<String, Map<String, String>>> loadTranslationsForLocales(
    List<Locale> locales, TranslationFileRepository repository) async {
  final Map<String, Map<String, String>> translationKeys =
      HashMap<String, Map<String, String>>();

  for (final locale in locales) {
    final String localeAsString = locale.toString();
    translationKeys[localeAsString] = HashMap<String, String>();

    try {
      translationKeys[localeAsString] =
          await repository.loadTranslationFileByLocale(locale);
    } catch (e) {
      developer.log('Error while loading translations from file $locale',
          error: e, level: 1000, name: "translations_loader");
    }
  }
  return translationKeys;
}
