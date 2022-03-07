import 'package:flutter/material.dart';

class Language {
  int id;
  String name;
  String languageCode;
  String flag;

  Language(this.id, this.name, this.languageCode, this.flag);

  static List<Language> getLanguages() {
    return <Language>[
      Language(1, 'Kurdish', 'ar', 'assets/flags/ic_arabic.png'),
      Language(0, 'English', 'en', 'assets/flags/ic_us.png'),


      /*
       Language(2, 'Spanish', 'es', 'assets/flags/ic_spain.png'),
      Language(3, 'Afrikaans', 'af', 'assets/flags/ic_south_africa.png'),
      Language(4, 'French', 'fr', 'assets/flags/ic_france.png'),
      Language(5, 'German', 'de', 'assets/flags/ic_germany.png'),
      Language(6, 'Indonesian', 'id', 'assets/flags/ic_indonesia.png'),
      Language(7, 'Portuguese', 'pt', 'assets/flags/ic_portugal.png'),
      Language(8, 'Turkish', 'tr', 'assets/flags/ic_turkey.png'),
      Language(9, 'Arabic', 'ar', 'assets/flags/ic_arabic.png'),
      Language(10, 'Gujarati', 'gu', 'assets/flags/ic_india.png'),
      Language(11, 'Vietnam', 'vi', 'assets/flags/ic_vi.png'),
      Language(12, 'Dutch', 'nl', 'assets/flags/ic_nl.png'),

       */
    ];
  }

  static List<String> languages() {
    List<String> list = [];

    getLanguages().forEach((element) {
      list.add(element.languageCode);
    });

    return list;
  }

  static List<Locale> languagesLocale() {
    List<Locale> list = [];

    getLanguages().forEach((element) {
      list.add(Locale(element.languageCode, ''));
    });

    return list;
  }
}
