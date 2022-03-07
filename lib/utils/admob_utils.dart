import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:granth_flutter/utils/resources/strings.dart';
import 'package:nb_utils/nb_utils.dart';

BannerAd createBannerAd() {
  return BannerAd(
    request: AdRequest(),
    adUnitId: Platform.isAndroid ? android_banner_id : ios_banner_id,
    size: AdSize.banner,
    listener: BannerAdListener(),
  );
}

Future<InterstitialAd?> createInterstitialAd() async {
  InterstitialAd? interstitialAd;
  await InterstitialAd.load(
    adUnitId: Platform.isAndroid ? android_interstitial_id : ios_interstitial_id,
    request: AdRequest(),
    adLoadCallback: InterstitialAdLoadCallback(
      onAdLoaded: (InterstitialAd ad) {
        print('$ad loaded');
        ad.show();
      },
      onAdFailedToLoad: (LoadAdError error) {
        throw error.message;
      },
    ),
  );
  log(interstitialAd);
  return interstitialAd;

}


/*

import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:granth_flutter/utils/resources/strings.dart';

BannerAd createBannerAd() {
  return BannerAd(
    request: AdRequest(),
    adUnitId: Platform.isAndroid ? android_banner_id : ios_banner_id,
    size: AdSize.banner,
    listener: AdListener(
      onAdLoaded: (ad) {},
    ),
  );
}

InterstitialAd createInterstitialAd() {
  return InterstitialAd(
    request: AdRequest(),
    adUnitId: Platform.isAndroid ? android_interstitial_id : ios_interstitial_id,
    listener: AdListener(onAdLoaded: (ad) {}),
  );
}

 */

