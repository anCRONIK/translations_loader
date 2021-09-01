import 'dart:collection';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../domain/repositories/translation_file_repository.dart';

/// Implementation which reads JSON and properties files from assets directory. This implementation uses just [languageCode] of the [Locale].
/// Which means that for locale [en_US] it will bea searching for file [en.json] and [en.properties]
class TranslationFileRepositoryImpl extends TranslationFileRepository {
  final String _translationFolderAssetsPath;

  /// [_translationFolderAssetsPath] is location of the translations folder inside assets folder, for example [assets/i18n].
  TranslationFileRepositoryImpl(this._translationFolderAssetsPath)
      : assert(_translationFolderAssetsPath.isNotEmpty,
            'translations folder assets path is empty');

  @override
  Future<Map<String, String>> loadTranslationFileByLocale(Locale locale) async {
    // try loading json file
    try {
      final String text = await rootBundle.loadString(_toJsonPathFromLocale(
          locale)); //throws [FlutterError] if data is null (not loaded)
      return Future.value(_loadFromJson(text));
    } catch (e) {
      developer.log(
          'Error while loading translations from json file. It probably does not exists. Trying with properties file.',
          error: e,
          level: 500,
          name: "translations_loader");
    }

    // there is no json file
    final String text =
        await rootBundle.loadString(_toPropertiesPathJsonFromLocale(locale));
    return Future.value(_loadFromProperties(text));
  }

  @override
  Future<Map<String, String>> loadTranslationFileByName(String fileName) async {
    final String text = await rootBundle.loadString(fileName);
    if (fileName.toLowerCase().endsWith("json")) {
      return Future.value(_loadFromJson(text));
    }
    return Future.value(_loadFromProperties(text));
  }

  /// Create JSON file path
  String _toJsonPathFromLocale(Locale locale) {
    return '$_translationFolderAssetsPath/${locale.languageCode}.json';
  }

  /// Create properties file path
  String _toPropertiesPathJsonFromLocale(Locale locale) {
    return '$_translationFolderAssetsPath/${locale.languageCode}.properties';
  }

  /// Method for converting properties file text to [Map]
  static Map<String, String> _loadFromProperties(String text) {
    final properties = <String, String>{};
    final lines = text.split('\n');
    for (var line in lines) {
      line = line.trim().replaceAll('\r', '');
      if (line.isEmpty || line.startsWith('#')) {
        break;
      }
      try {
        final entry = line.split('=');
        properties[entry[0]] = entry[1];
      } catch (e) {
        throw 'Not valid line. The text is : $line';
      }
    }

    return properties;
  }

  /// Method for loading translations from JSON file
  static Map<String, String> _loadFromJson(String text) {
    return _toTranslationKeysRecursive(
        HashMap<String, String>(), json.decode(text) as Map);
  }

  /// Recursive method to create proper keys
  static Map<String, String> _toTranslationKeysRecursive(
      Map<String, String> translationKeys, Map translationMap,
      [String? previousKeyPath]) {
    if (translationMap.isNotEmpty) {
      translationMap.forEach((key, value) {
        String currentKeyPath = key.toString();
        if (null != previousKeyPath) {
          currentKeyPath = '$previousKeyPath.$key';
        }
        if (value is Map) {
          _toTranslationKeysRecursive(translationKeys, value, currentKeyPath);
        } else {
          translationKeys[currentKeyPath] = value.toString();
        }
      });
    }
    return translationKeys;
  }
}
