import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:granth_flutter/utils/admob_utils.dart';
import 'package:granth_flutter/utils/constants.dart';
import 'package:granth_flutter/utils/resources/images.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';
import '../app_localizations.dart';

class AboutApp extends StatefulWidget {
  static String tag = '/AboutApp';

  @override
  _AboutAppState createState() => _AboutAppState();
}

class _AboutAppState extends State<AboutApp> {
 // BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
  //  _bannerAd = createBannerAd()..load();
  }

  @override
  void dispose() {
  //  _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(keyString(context, "about_us"), elevation: 0, color: context.scaffoldBackgroundColor, textColor: context.theme.textTheme.headline6!.color),
      body: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(app_icon, alignment: Alignment.center, height: 150, width: 150).cornerRadiusWithClipRRect(10),
                16.height,
                FutureBuilder<PackageInfo>(
                  future: PackageInfo.fromPlatform(),
                  builder: (_, snap) {
                    if (snap.hasData) {
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.copyright, size: 14),
                              4.width,
                              Text('2020 ${snap.data!.appName.validate()}', style: primaryTextStyle(color: context.theme.textTheme.headline6!.color)),
                            ],
                          ),
                          6.height,
                          Text('${keyString(context, 'version')} ${snap.data!.version.validate()}', style: primaryTextStyle(color: context.theme.textTheme.headline6!.color)),
                        ],
                      );
                    }
                    return SizedBox();
                  },
                ),
                16.height,
                Text(
                  'دەزگای چاپ و پەخشی کانی عیرفان لە مانگی ٨ی ٢٠١٢ەوە دەستی کردووە بە خزمەتی کتێبخانەی کوردی و، لەو ماوەیەدا چەندین کتێبی منداڵان و لاوان و پێگەیشتووانی پێشکەش کردووە.',
                  style: primaryTextStyle(color: context.theme.textTheme.subtitle2!.color),
                ),
                32.height,
                AppButton(
                  text: keyString(context, 'lbl_buy_now'),
                  textStyle: primaryTextStyle(color: Colors.white),
                  color: context.primaryColor,
                  onTap: () {
                    launch("https://codecanyon.net/item/granth-flutter-ebook-app-admin-panel/26129119?s_rank=13");
                 },
               ),
             ],
           ),
         ),
         /*
         (_bannerAd != null && isAdsLoading)
             ? Positioned(
                 bottom: 0,
                 left: 0,
                 right: 0,
                 child: AdWidget(ad: _bannerAd!).withWidth(AdSize.banner.width.toDouble()).withHeight(
                       AdSize.banner.height.toDouble(),
                     ),

               )

             : SizedBox(),

          */
       ],
     ),
   );
  }
}
