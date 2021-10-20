import 'dart:collection';
import 'dart:convert';

/// Method for converting properties file text to [Map]
Map<String, String> loadFromProperties(String text) {
  final properties = <String, String>{};
  final lines = text.split('\n');
  for (var line in lines) {
    line = line.trim().replaceAll('\r', '');
    if (line.isEmpty || line.startsWith('#')) {
      continue;
    }
    final indexOfSeparator = line.indexOf('=');
    if (indexOfSeparator <= 0) {
      throw Exception('Not valid line. The text is : $line');
    }
    properties[line.substring(0, indexOfSeparator)] =
        line.substring(indexOfSeparator + 1);
  }

  return properties;
}

/// Method for loading translations from JSON file
Map<String, String> loadFromJson(String text) {
  return _toTranslationKeysRecursive(
      HashMap<String, String>(), json.decode(text) as Map);
}

/// Recursive method to create proper keys
Map<String, String> _toTranslationKeysRecursive(
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
