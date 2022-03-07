import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:granth_flutter/network/common_api_calls.dart';
import 'package:granth_flutter/screens/about_app_screen.dart';
import 'package:granth_flutter/screens/cart_screen.dart';
import 'package:granth_flutter/screens/change_password_screen.dart';
import 'package:granth_flutter/screens/feedback_screen.dart';
import 'package:granth_flutter/screens/library_screen.dart';
import 'package:granth_flutter/screens/profile_screen.dart';
import 'package:granth_flutter/screens/setting_screen.dart';
import 'package:granth_flutter/screens/sign_in_screen.dart';
import 'package:granth_flutter/screens/transaction_history_screen.dart';
import 'package:granth_flutter/screens/wishlist_screens.dart';
import 'package:granth_flutter/utils/common.dart';
import 'package:granth_flutter/utils/constants.dart';
import 'package:granth_flutter/utils/resources/images.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:share/share.dart';

import '../app_localizations.dart';

class HomeDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeDrawerState();
  }
}

class HomeDrawerState extends State<HomeDrawer> {
  late Color color;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    setStatusBarColor(color);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setStatusBarColor(Theme.of(context).primaryColor);
    color = context.scaffoldBackgroundColor;
    Widget profileWidget() => Container(
          alignment: Alignment.bottomLeft,
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(12.0, 40, 12.0, 40),
          color: Theme.of(context).primaryColor,
          child: getBoolAsync(IS_LOGGED_IN)
              ? GestureDetector(
                  onTap: () {
                    finish(context);
                    ProfileScreen().launch(context);
                  },
                  child: Row(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: (getStringAsync(USER_PROFILE).isNotEmpty ? NetworkImage(getStringAsync(USER_PROFILE)) : AssetImage(ic_profile)) as ImageProvider<Object>?,
                        radius: 40,
                      ),
                      16.width,
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(getStringAsync(USERNAME), style: boldTextStyle(color: Colors.white)),
                            8.height,
                            Text(getStringAsync(USER_EMAIL), style: primaryTextStyle(color: Colors.white)),
                          ],
                        ),
                      ).expand()
                    ],
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    finish(context);
                    SignInScreen().launch(context);
                  },
                  child: Text(keyString(context, "lbl_login"), style: boldTextStyle(size: 24, color: Colors.white))),
        );
    Widget body() => Column(
          children: <Widget>[
            profileWidget(),
            SettingItemWidget(
              titleTextColor: context.theme.textTheme.headline6!.color,
              leading: SvgPicture.asset(
                icon_home,
                width: 20,
                height: 20,
                color: context.theme.iconTheme.color,
              ),
              title: keyString(context, "lbl_dashboard"),
              onTap: () {
                finish(context);
              },
            ),
            SettingItemWidget(
              titleTextColor: context.theme.textTheme.headline6!.color,
              leading: SvgPicture.asset(
                icon_book,
                width: 20,
                height: 20,
                color: context.theme.iconTheme.color,
              ),
              title: keyString(context, "lbl_my_library"),
              onTap: () {
                finish(context);
                LibraryScreen().launch(context);
              },
            ),
            SettingItemWidget(
              titleTextColor: context.theme.textTheme.headline6!.color,
              leading: SvgPicture.asset(
                icon_cart,
                width: 20,
                height: 20,
                color: context.theme.iconTheme.color,
              ),
              title: keyString(context, "lbl_my_cart"),
              onTap: () {
                finish(context);
                CartScreen().launch(context);
              },
            ).visible(getBoolAsync(IS_LOGGED_IN)),
            Divider(height: 10, color: viewLineColor),
            Column(
              children: <Widget>[
                SettingItemWidget(
                  titleTextColor: context.theme.textTheme.headline6!.color,
                  leading: SvgPicture.asset(
                    icon_bookmark,
                    width: 20,
                    height: 20,
                    color: context.theme.iconTheme.color,
                  ),
                  title: keyString(context, "lbl_wish_list"),
                  onTap: () {
                    finish(context);
                    WishlistScreen().launch(context);
                  },
                ),
                SettingItemWidget(
                  titleTextColor: context.theme.textTheme.headline6!.color,
                  leading: SvgPicture.asset(
                    icon_bank,
                    width: 20,
                    height: 20,
                    color: context.theme.iconTheme.color,
                  ),
                  title: keyString(context, "lbl_transaction_history"),
                  onTap: () {
                    finish(context);
                    TransactionHistoryScreen().launch(context);
                  },
                ),
                SettingItemWidget(
                  titleTextColor: context.theme.textTheme.headline6!.color,
                  leading: SvgPicture.asset(
                    icon_password,
                    width: 20,
                    height: 20,
                    color: context.theme.iconTheme.color,
                  ),
                  title: keyString(context, "lbl_change_password"),
                  onTap: () {
                    finish(context);
                    ChangePasswordScreen().launch(context);
                  },
                ),
                SettingItemWidget(
                  titleTextColor: context.theme.textTheme.headline6!.color,
                  leading: SvgPicture.asset(
                    icon_logout,
                    width: 20,
                    height: 20,
                    color: context.theme.iconTheme.color,
                  ),
                  title: keyString(context, "lbl_logout"),
                  onTap: () async {
                    showConfirmDialogCustom(context, onAccept: (c) {
                      finish(context);
                      doLogout(context);
                    }, title: keyString(context, "msg_logout"), positiveText: keyString(context, 'lbl_logout'), negativeText: keyString(context, 'aRate_lbl_Cancel'));
                  },
                ),
                Divider(
                  height: 20,
                ),
              ],
            ).visible(getBoolAsync(IS_LOGGED_IN)),
            SettingItemWidget(
              titleTextColor: context.theme.textTheme.headline6!.color,
              leading: SvgPicture.asset(
                icon_settings,
                width: 20,
                height: 20,
                color: context.theme.iconTheme.color,
              ),
              title: keyString(context, "settings"),
              onTap: () {
                finish(context);
                SettingScreen().launch(context);
              },
            ),
            SettingItemWidget(
              titleTextColor: context.theme.textTheme.headline6!.color,
              leading: SvgPicture.asset(
                icon_share,
                width: 20,
                height: 20,
                color: context.theme.iconTheme.color,
              ),
              title: keyString(context, "lbl_share_app"),
              onTap: () {
                Share.share('https://www.irfanpublishing.com/');
              },
            ),
            SettingItemWidget(
              titleTextColor: context.theme.textTheme.headline6!.color,
              leading: SvgPicture.asset(
                icon_rate,
                width: 20,
                height: 20,
                color: context.theme.iconTheme.color,
              ),
              title: keyString(context, "lbl_rate_app"),
              onTap: () {
                launchUrl(playStoreBaseURL + "https://www.irfanpublishing.com/");
              },
            ),
            SettingItemWidget(
              titleTextColor: context.theme.textTheme.headline6!.color,
              leading: SvgPicture.asset(
                icon_shield,
                width: 20,
                height: 20,
                color: context.theme.iconTheme.color,
              ),
              title: keyString(context, "lbl_privacy_policy"),
              onTap: () {
                launchUrl("https://irfanpublishing.com/%d9%be%db%95%db%8c%d9%88%db%95%d9%86%d8%af%db%8c%da%a9%d8%b1%d8%af%d9%86/");
              },
            ),
            SettingItemWidget(
              titleTextColor: context.theme.textTheme.headline6!.color,
              leading: SvgPicture.asset(
                icon_contract,
                width: 20,
                height: 20,
                color: context.theme.iconTheme.color,
              ),
              title: keyString(context, "lbl_terms_amp_condition"),
              onTap: () {
                launchUrl("https://irfanpublishing.com/%d9%be%db%95%db%8c%d9%88%db%95%d9%86%d8%af%db%8c%da%a9%d8%b1%d8%af%d9%86/");
              },
            ),
            SettingItemWidget(
              titleTextColor: context.theme.textTheme.headline6!.color,
              leading: SvgPicture.asset(
                icon_blog,
                width: 20,
                height: 20,
                color: context.theme.iconTheme.color,
              ),
              title: keyString(context, "lbl_feedback"),
              onTap: () {
                finish(context);
                FeedbackScreen().launch(context);
              },
            ),
            SettingItemWidget(
              titleTextColor: context.theme.textTheme.headline6!.color,
              leading: SvgPicture.asset(
                icon_info,
                width: 20,
                height: 20,
                color: context.theme.iconTheme.color,
              ),
              title: keyString(context, "lbl_about_app"),
              onTap: () {
                finish(context);
                AboutApp().launch(context);
              },
            ),
            16.height,
          ],
        );
    return Drawer(
      elevation: 8,
      child: Container(
        color: context.scaffoldBackgroundColor,
        child: SafeArea(
          child: SingleChildScrollView(
            child: body(),
          ),
        ),
      ),
    );
  }
}
