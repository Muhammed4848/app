import 'package:flutter/material.dart';
import 'package:granth_flutter/app_localizations.dart';
import 'package:granth_flutter/utils/resources/colors.dart';
import 'package:nb_utils/nb_utils.dart';

class DetailViewTabBar extends StatefulWidget {
  @override
  _DetailViewTabBarState createState() => _DetailViewTabBarState();
}

class _DetailViewTabBarState extends State<DetailViewTabBar> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: context.scaffoldBackgroundColor,
            iconTheme: context.theme.iconTheme,
            centerTitle: true,
            bottom: PreferredSize(
              preferredSize: Size(double.infinity, 50),
              child: Align(
                alignment: Alignment.topLeft,
                child: TabBar(
                  isScrollable: false,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorColor: context.theme.textTheme.headline6!.color,
                  labelPadding: EdgeInsets.only(left: 10, right: 10),
                  tabs: [
                    Tab(child: Text(keyString(context, "lbl_samples"), style: boldTextStyle(color: context.theme.textTheme.headline6!.color))),
                    Tab(child: Text(keyString(context, "lbl_purchased"), style: boldTextStyle(color: context.theme.textTheme.headline6!.color))),
                    Tab(child: Text(keyString(context, "lbl_downloaded"), style: boldTextStyle(color: context.theme.textTheme.headline6!.color))),
                  ],
                ),
              ),
            ),
            title: Text(keyString(context, "lbl_my_library"), style: boldTextStyle(color: context.theme.textTheme.headline6!.color, size: 22))),
        body: TabBarView(
          children: [
            Container(color: red),
            Container(color: Colors.blue),
            Container(color: green),
          ],
        ),
      ),
    );
  }
}
