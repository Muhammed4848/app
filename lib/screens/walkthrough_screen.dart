import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:granth_flutter/app_localizations.dart';
import 'package:granth_flutter/screens/home_screen.dart';
import 'package:granth_flutter/utils/constants.dart';
import 'package:granth_flutter/utils/resources/images.dart';
import 'package:nb_utils/nb_utils.dart';

class WalkthroughScreen extends StatefulWidget {
  static var tag = "/OnBoarding";

  @override
  WalkThroughScreenState createState() => WalkThroughScreenState();
}

class WalkThroughScreenState extends State<WalkthroughScreen> {
  int currentIndexPage = 0;

  PageController pageController = PageController();

  List<WalkThrough> list = [];
  @override
  void initState() {

    super.initState();
    500.milliseconds.delay.then((value) => setStatusBarColor(context.scaffoldBackgroundColor));
    list.add(WalkThrough(subTitle: "لێرە سەرجەم بەرهەمەکانی دەزگای کانی عیرفان بەردەستن.", walkImg: icon_walk1));
    list.add(WalkThrough(subTitle: "لەگەڵ چەندین تایبەتمەندیی ناوازەی ئەم بەرنامەیە، خوێندنەوەی کتێب بەچێژتر دەبێت.", walkImg: icon_walk2));
    list.add(WalkThrough(title: 'چێژ لە خوێندنەوە وەربگرە', walkImg: icon_walk3, isLast: true));
   // list.add(WalkThrough(title: 'Welcome to Granth', subTitle: "Lorem Ipsum is simply dummy text of the printing and typesetting industry.simply duumy text ", walkImg: icon_walk4, isLast: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      alignment: Alignment.topRight,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              PageView(
                controller: pageController,
                children: list.map((e) {
                  WalkThrough data = list[list.indexOf(e)];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(e.walkImg!, height: context.height() * 0.6, width: context.height() * 0.6, fit: BoxFit.fitWidth),
                      16.height,
                      Text(e.title.validate(), style: boldTextStyle(color: context.theme.textTheme.headline6!.color, size: 18)),
                      16.height,
                      Text(e.subTitle.validate(), style: primaryTextStyle(color: context.theme.textTheme.headline6!.color), maxLines: 3, textAlign: TextAlign.center)
                    ],
                  ).paddingOnly(left: 16, right: 16);
                }).toList(),
                onPageChanged: (i) {
                  currentIndexPage = i;
                  setState(() {});
                },
              ),
              Positioned(
                bottom: 30,
                right: 0,
                left: 0,
                child: Column(
                  children: [
                    DotIndicator(
                      pageController: pageController,
                      pages: list,
                      indicatorColor: context.primaryColor,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text( keyString(context, 'skip')),
                          decoration: boxDecorationRoundedWithShadow(30),
                          padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                        ).onTap(() async {
                          await setValue(IS_ONBOARDING_LAUNCHED, true);

                          HomeScreen().launch(context, isNewTask: true);
                        }),
                        Container(
                          child: Text(currentIndexPage != 2 ? keyString(context, 'next') : keyString(context, 'finish')),
                          decoration: boxDecorationRoundedWithShadow(30),
                          padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                        ).onTap(() async {
                          if (currentIndexPage == 2) {
                            await setValue(IS_ONBOARDING_LAUNCHED, true);

                            HomeScreen().launch(context, isNewTask: true);
                          } else {
                            pageController.animateToPage(currentIndexPage + 1, duration: Duration(milliseconds: 300), curve: Curves.linear);
                          }
                        }),
                      ],
                    ).paddingOnly(left: 16, right: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}

class WalkThrough extends StatelessWidget {
  final String? title;
  final String? subTitle;
  final bool isLast;
  final String? walkImg;

  WalkThrough({Key? key, this.title, this.subTitle, this.isLast = false, this.walkImg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width(),
      height: context.height(),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: context.width() * 0.15, left: context.width() * 0.1, right: context.width() * 0.1),
            height: context.height() * 0.5,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[SvgPicture.asset(walkImg!, width: context.width() * 0.6, height: context.width() * 0.6)],
            ),
          ),
          SizedBox(height: context.width() * 0.1),
          Text(title!, style: boldTextStyle(color: context.theme.textTheme.headline6!.color, size: 18)),
          Padding(
            padding: const EdgeInsets.only(left: 28.0, right: 28.0),
            child: Text(subTitle!, style: primaryTextStyle(color: context.theme.textTheme.headline6!.color), maxLines: 3, textAlign: TextAlign.center),
          )
        ],
      ),
    );
  }
}
