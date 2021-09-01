import 'dart:collection';
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:translations_loader/src/domain/repositories/translation_file_repository.dart';
import 'package:translations_loader/src/translations_loader_methods.dart';
import 'package:translations_loader/translations_loader.dart';

const supportedLocales = [
  Locale.fromSubtags(languageCode: "en"),
  Locale.fromSubtags(languageCode: "hr")
];

const appKey = "app";
const assetsPath = "assets/i18n";

class TranslationFileRepositoryMock implements TranslationFileRepository {
  final hrMap = HashMap<String, String>();
  final enMap = HashMap<String, String>();

  @override
  Future<Map<String, String>> loadTranslationFileByLocale(Locale locale) {
    if (locale.languageCode == supportedLocales[0].languageCode) {
      return Future.value(enMap);
    } else {
      return Future.value(hrMap);
    }
  }

  @override
  Future<Map<String, String>> loadTranslationFileByName(String fileName) {
    if (fileName == "en.json") {
      return Future.value(enMap);
    } else {
      return Future.value(hrMap);
    }
  }

  TranslationFileRepositoryMock() {
    hrMap[appKey] = "aplikacija";
    enMap[appKey] = "application";
  }
}

void main() {
  final repository = TranslationFileRepositoryMock();

  group('error testing', () {
    test('given assets path is empty, throw exception', () {
      // arrange
      // act
      // assert
      expect(TranslationsLoader.loadTranslations(""), throwsException);
    });
    testWidgets('no translation files present, throw exception',
        (tester) async {
      // arrange
      // act
      final translations =
          await loadAllTranslationsFromAssets(assetsPath, repository);
      // assert
      expect(translations.isEmpty, true);
    });
  });

  group('success testing', () {
    test('repository returns value, return valid map', () async {
      // arrange
      // act
      final translations =
          await loadTranslationsForLocales(supportedLocales, repository);
      // assert
      expect(translations.isNotEmpty, true);
      expect(translations["en"], {appKey: "application"});
    });
  });
}
