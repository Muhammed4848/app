// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AppStore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AppStore on AppStoreBase, Store {
  final _$isDarkModeAtom = Atom(name: 'AppStoreBase.isDarkMode');

  @override
  bool get isDarkMode {
    _$isDarkModeAtom.reportRead();
    return super.isDarkMode;
  }

  @override
  set isDarkMode(bool value) {
    _$isDarkModeAtom.reportWrite(value, super.isDarkMode, () {
      super.isDarkMode = value;
    });
  }

  final _$selectedLanguageCodeAtom =
      Atom(name: 'AppStoreBase.selectedLanguageCode');

  @override
  String get selectedLanguageCode {
    _$selectedLanguageCodeAtom.reportRead();
    return super.selectedLanguageCode;
  }

  @override
  set selectedLanguageCode(String value) {
    _$selectedLanguageCodeAtom.reportWrite(value, super.selectedLanguageCode,
        () {
      super.selectedLanguageCode = value;
    });
  }

  final _$isNotificationOnAtom = Atom(name: 'AppStoreBase.isNotificationOn');

  @override
  bool get isNotificationOn {
    _$isNotificationOnAtom.reportRead();
    return super.isNotificationOn;
  }

  @override
  set isNotificationOn(bool value) {
    _$isNotificationOnAtom.reportWrite(value, super.isNotificationOn, () {
      super.isNotificationOn = value;
    });
  }

  final _$playerIdAtom = Atom(name: 'AppStoreBase.playerId');

  @override
  String get playerId {
    _$playerIdAtom.reportRead();
    return super.playerId;
  }

  @override
  set playerId(String value) {
    _$playerIdAtom.reportWrite(value, super.playerId, () {
      super.playerId = value;
    });
  }

  final _$samplePageIndexAtom = Atom(name: 'AppStoreBase.samplePageIndex');

  @override
  int get samplePageIndex {
    _$samplePageIndexAtom.reportRead();
    return super.samplePageIndex;
  }

  @override
  set samplePageIndex(int value) {
    _$samplePageIndexAtom.reportWrite(value, super.samplePageIndex, () {
      super.samplePageIndex = value;
    });
  }

  final _$readBookPageIndexAtom = Atom(name: 'AppStoreBase.readBookPageIndex');

  @override
  int get readBookPageIndex {
    _$readBookPageIndexAtom.reportRead();
    return super.readBookPageIndex;
  }

  @override
  set readBookPageIndex(int value) {
    _$readBookPageIndexAtom.reportWrite(value, super.readBookPageIndex, () {
      super.readBookPageIndex = value;
    });
  }

  final _$setDarkModeAsyncAction = AsyncAction('AppStoreBase.setDarkMode');

  @override
  Future<void> setDarkMode(bool aIsDarkMode) {
    return _$setDarkModeAsyncAction.run(() => super.setDarkMode(aIsDarkMode));
  }

  final _$setLanguageAsyncAction = AsyncAction('AppStoreBase.setLanguage');

  @override
  Future<void> setLanguage(String aSelectedLanguageCode,
      {BuildContext? context}) {
    return _$setLanguageAsyncAction
        .run(() => super.setLanguage(aSelectedLanguageCode, context: context));
  }

  final _$setPlayerIdAsyncAction = AsyncAction('AppStoreBase.setPlayerId');

  @override
  Future<void> setPlayerId(String val, {bool isInitializing = false}) {
    return _$setPlayerIdAsyncAction
        .run(() => super.setPlayerId(val, isInitializing: isInitializing));
  }

  final _$AppStoreBaseActionController = ActionController(name: 'AppStoreBase');

  @override
  void setNotification(bool val) {
    final _$actionInfo = _$AppStoreBaseActionController.startAction(
        name: 'AppStoreBase.setNotification');
    try {
      return super.setNotification(val);
    } finally {
      _$AppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSamplePage(int aIndex) {
    final _$actionInfo = _$AppStoreBaseActionController.startAction(
        name: 'AppStoreBase.setSamplePage');
    try {
      return super.setSamplePage(aIndex);
    } finally {
      _$AppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setReadBookPage(int aIndex) {
    final _$actionInfo = _$AppStoreBaseActionController.startAction(
        name: 'AppStoreBase.setReadBookPage');
    try {
      return super.setReadBookPage(aIndex);
    } finally {
      _$AppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isDarkMode: ${isDarkMode},
selectedLanguageCode: ${selectedLanguageCode},
isNotificationOn: ${isNotificationOn},
playerId: ${playerId},
samplePageIndex: ${samplePageIndex},
readBookPageIndex: ${readBookPageIndex}
    ''';
  }
}
