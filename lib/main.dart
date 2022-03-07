import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
//import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:granth_flutter/models/language_model.dart';
import 'package:granth_flutter/screens/splash_screen.dart';
import 'package:granth_flutter/store/AppStore.dart';
import 'package:granth_flutter/utils/common.dart';
import 'package:granth_flutter/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'app_localizations.dart';
import 'app_theme.dart';

AppStore appStore = AppStore();
Language? language;
List<Language> languages = Language.getLanguages();
AppLocalizations? appLocalizations;
int mAdShowCount = 0;
OneSignal oneSignal = OneSignal();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: true);

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
//  FirebaseAdMob.instance.initialize(appId: Platform.isAndroid?android_appid:ios_appid);
  await initialize();
 // MobileAds.instance.initialize();

  if (getBoolAsync(IS_DARK_THEME)) {
    appStore.setDarkMode(true);
  } else {
    appStore.setDarkMode(false);
  }

  appStore.setLanguage(getStringAsync(LANGUAGE, defaultValue: defaultLanguage));
  appStore.setNotification(getBoolAsync(IS_NOTIFICATION_ON, defaultValue: true));

  await OneSignal.shared.setAppId(oneSignalAppId);
  log(getStringAsync(PLAYER_ID));

  OneSignal.shared.setNotificationWillShowInForegroundHandler((OSNotificationReceivedEvent event) {
    event.complete(event.notification);
  });

  await saveOneSignalPlayerId();
  oneSignal.disablePush(false);

  oneSignal.consentGranted(true);
  oneSignal.requiresUserPrivacyConsent();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [AppLocalizations.delegate, GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate],
        localeResolutionCallback: (locale, supportedLocales) => locale,
        locale: Locale(appStore.selectedLanguageCode ),
        supportedLocales: Language.languagesLocale(),
        home: SplashScreen(),
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: appStore.isDarkMode ? ThemeMode.dark : ThemeMode.light,
        builder: scrollBehaviour(),
        navigatorKey: navigatorKey,
      ),
    );
  }
}
