import 'package:flutter_test/flutter_test.dart';
import 'package:translations_loader/src/data/util/translation_text_parser.dart';

String propertiesText = """
app.name=Testna aplikacija
app.version=1
app.bar.title=Moj naslov
lang.hr=Hrvatski
# some comment
lang.en=Engleski

page.home.current_lang=Trenutni jezik je
""";

String jsonText = """
{
  "app": {
    "name": "Test application",
    "version": "1",
    "bar": {
      "title": "My title"
    }
  },
  "lang": {
    "hr": "Croatian",
    "en": "English"
  },
  "page":{
    "home": {
      "current_lang": "Current language is"
    }
  }
}
""";

void main() {
  group('.properties reading test', () {
    test('empty string given, return empty map', () async {
      // arrange
      // act
      final map = loadFromProperties("");
      // assert
      expect(map.length, 0);
    });

    test('properties file not properly formatted, throw exception', () {
      // arrange
      String text = "roki=kreso\r\npero\r\nkey=value";
      // act
      expect(() => loadFromProperties(text), throwsException);
      // assert
    });

    test('properties properly formatted, return proper map', () {
      // arrange
      // act
      final map = loadFromProperties(propertiesText);
      // assert
      expect(map.length, 6);
      expect(map["lang.en"], "Engleski");
      expect(map["page.home.current_lang"], "Trenutni jezik je");
    });
  });

  group('.json reading test', () {
    test('empty string given, throw exception', () {
      // arrange
      // act
      // assert
      expect(() => loadFromJson(""), throwsException);
    });

    test('file not properly formatted, throw exception', () {
      // arrange
      String text = '"{"key":"value""';
      // act
      expect(() => loadFromJson(text), throwsException);
      // assert
    });

    test('file properly formatted, return proper map', () {
      // arrange
      // act
      final map = loadFromJson(jsonText);
      // assert
      expect(map.length, 6);
      expect(map["lang.en"], "English");
    });
  });
}
