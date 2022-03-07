import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:granth_flutter/component/book_product_component.dart';
import 'package:granth_flutter/component/home_drawer_component.dart';
import 'package:granth_flutter/component/horizontal_list.dart';
import 'package:granth_flutter/component/slider_component.dart';
import 'package:granth_flutter/models/response/author.dart';
import 'package:granth_flutter/models/response/book_detail.dart';
import 'package:granth_flutter/models/response/category.dart';
import 'package:granth_flutter/models/response/dashboard_response.dart';
import 'package:granth_flutter/models/response/notification_payload.dart';
import 'package:granth_flutter/models/response/slider.dart';
import 'package:granth_flutter/network/common_api_calls.dart';
import 'package:granth_flutter/network/rest_apis.dart';
import 'package:granth_flutter/screens/author_detail_screen.dart';
import 'package:granth_flutter/screens/author_list_screen.dart';
import 'package:granth_flutter/screens/book_description_screen.dart';
import 'package:granth_flutter/screens/book_description_screen2.dart';
import 'package:granth_flutter/screens/category_book_screen.dart';
import 'package:granth_flutter/screens/search_book_screen.dart';
import 'package:granth_flutter/screens/view_all_book_screen.dart';
import 'package:granth_flutter/utils/constants.dart';
import 'package:granth_flutter/utils/resources/images.dart';
import 'package:granth_flutter/utils/widgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../app_localizations.dart';

class HomeScreen extends StatefulWidget {
  static String tag = '/HomeScreen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AfterLayoutMixin<HomeScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Color> gradientColor2 = <Color>[Color(0xFFA71831), Color(0xFFDE0B33), Color(0xFF1e3c72), Color(0xFF8360c3), Color(0xFF1e130c)];
  List<Color> gradientColor1 = <Color>[Color(0xFFBEA372), Color(0xFFFd988d), Color(0xFF22a5298), Color(0xFF2ebf91), Color(0xFF9a8478)];

  var mIsFirstTime = true;
  var cartCount = 0;
  var isUserLogin = false;

  @override
  void afterFirstLayout(BuildContext context) async {
    if (mIsFirstTime) {
      //_bannerAd = createBannerAd()..load();

      LiveStream().on(CART_COUNT_ACTION, (value) {
        if (!mounted) {
          return;
        }
        setState(() {
          cartCount = value as int;
          LiveStream().emit("updateCart", true);
        });
      });
      LiveStream().on(CART_ITEM_CHANGED, (value) {
        if (!mounted) {
          return;
        }
        fetchCartData(context);
      });
      LiveStream().on(WISH_DATA_ITEM_CHANGED, (value) {
        if (!mounted) {
          return;
        }
        fetchWishListData(context);
      });
      if (mounted) {
        if (isMobile) {
          OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) async {
            Map<String, dynamic>? data = result.notification.rawPayload;
            if (data != null) {
              var payload = NotificationPayload.fromJson(data);
              onReadNotification(payload.notificationId);
              if (payload.type != null && payload.type.toString().isNotEmpty) {
                if (payload.type == "book_added") {
                  if (getIntAsync(DETAIL_PAGE_VARIANT) == 1) {
                    BookDescriptionScreen(bookDetail: BookDetail(bookId: payload.bookId)).launch(context);
                  } else {
                   BookDescriptionScreen2(bookDetail: BookDetail(bookId: payload.bookId)).launch(context);
                  }
                }
              }
            }
          });
        }
      }
      isUserLogin = await getBool(IS_LOGGED_IN);
      // fetchDashboardData();
      if (isUserLogin) {
        fetchCartData(context);
        fetchWishListData(context);
      }
      mIsFirstTime = false;
    }
  }

  @override
  void initState() {
    500.milliseconds.delay.then((value) => setStatusBarColor(context.scaffoldBackgroundColor));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Widget noInternetError = Container(
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset(
            icon_antenna,
            width: 120,
            height: 120,
          ),
          Text(
            keyString(context, "error_network_no_internet"),
            style: primaryTextStyle(color: context.theme.textTheme.headline6!.color, size: 20),
          ).paddingTop(10),
          MaterialButton(
            padding: EdgeInsets.fromLTRB(30, 8.0, 30, 8.0),
            textColor: Colors.white,
            child: Text(keyString(context, "lbl_try_again"), style: primaryTextStyle(color: context.theme.textTheme.headline6!.color)),
            color: Colors.amber,
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(5.0),
              side: BorderSide(color: Colors.amber),
            ),
            onPressed: () {
              setState(() {});
            },
          ).paddingTop(12.0)
        ],
      ),
    );

    Widget noData = Container(
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset(
            no_data,
            width: 180,
            height: 180,
          ),
          Text(keyString(context, "no_book_available"), style: primaryTextStyle(color: context.theme.textTheme.subtitle2!.color, size: 22)).paddingTop(12.0),
        ],
      ),
    );
    Widget slider(List<HomeSlider>? mSliderList) {
      return HomeSliderWidget(mSliderList).paddingTop(60);
    }

    Widget categoryList(List<Category> mCategories) {
      return HorizontalListWidget(
        itemCount: mCategories.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              CategoryBooks(
                type: 'category',
                title: mCategories[index].name,
                categoryId: mCategories[index].categoryId.toString(),
              ).launch(context);
            },
            child: Container(
              alignment: Alignment.center,
              height: 60,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  gradient: LinearGradient(
                    colors: [gradientColor1[index % gradientColor1.length], gradientColor2[index % gradientColor2.length]],
                  )),
              child: Text(mCategories[index].name, style: boldTextStyle(color: Colors.white), maxLines: 3, textAlign: TextAlign.center),
            ),
          );
        },
      );
    }
    Widget authorList(List<AuthorDetail> mBestAuthorList) {
      return HorizontalListWidget(
        itemCount: mBestAuthorList.length,
        spacing: 16,
        itemBuilder: (context, index) {
          return Container(
            width: 80,
            child: Column(
              children: <Widget>[
                InkWell(
                  radius: context.width() * 0.1,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: (mBestAuthorList[index].image != null ? NetworkImage(mBestAuthorList[index].image) : AssetImage(ic_profile)) as ImageProvider<Object>?,
                  ),
                  onTap: () {
                    AuthorDetailScreen(authorDetail: mBestAuthorList[index]).launch(context);
                  },
                ),
                6.height,
                Text(
                  mBestAuthorList[index].name,
                  style: boldTextStyle(color: context.theme.textTheme.headline6!.color, size: 12),
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      );
    }



    Widget containerBody(DashboardResponse dashboardResponse) {
      bool mIsTopSearchBook = dashboardResponse.topSearchBook != null && dashboardResponse.topSearchBook!.isNotEmpty;
      bool mIsRecommendedBook = dashboardResponse.recommendedBook != null && dashboardResponse.recommendedBook!.isNotEmpty;
      bool mIsTopSellBook = dashboardResponse.topSellBook != null && dashboardResponse.topSellBook!.isNotEmpty;
      bool mIsTopAuthor = dashboardResponse.topAuthor != null && dashboardResponse.topAuthor!.isNotEmpty;
      bool mIsCategoryBook = dashboardResponse.categoryBook != null && dashboardResponse.categoryBook!.isNotEmpty;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //Collections
          horizontalHeading(context, keyString(context, "lbl_collections"), showViewAll: false).visible(mIsCategoryBook),
          categoryList(dashboardResponse.categoryBook!).visible(mIsCategoryBook),
          //Top Search Book

          horizontalHeading(context, keyString(context, "top_search_books"), callback: () {
            ViewAllBooks(type: type_top_search, title: keyString(context, "top_search_books")).launch(context);
          }).visible(mIsTopSearchBook),
          BookProductComponent(dashboardResponse.topSearchBook).visible(mIsTopSearchBook),
          //Best Author
/*
          horizontalHeading(context, keyString(context, "best_author"), callback: () {
            AuthorsListScreen().launch(context);
          }).visible(mIsTopAuthor),
          authorList(dashboardResponse.topAuthor!).visible(mIsTopAuthor),

 */
          //Recommended Books

          horizontalHeading(context, keyString(context, "recommended_books"), callback: () {
            ViewAllBooks(type: type_recommended, title: keyString(context, "recommended_books")).launch(context);
          }).visible(mIsRecommendedBook),
          BookProductComponent(dashboardResponse.recommendedBook).visible(mIsRecommendedBook),
          //Popular Books

          horizontalHeading(context, keyString(context, "popular_books"), callback: () {
            ViewAllBooks(type: type_popular, title: keyString(context, "popular_books")).launch(context);
          }).visible(mIsRecommendedBook),
          BookProductComponent(dashboardResponse.popularBook, isHorizontal: true).visible(mIsRecommendedBook),
          //Top Selling

          horizontalHeading(context, keyString(context, "lbl_top_selling"), callback: () {
            ViewAllBooks(type: type_top_sell, title: keyString(context, "lbl_top_selling")).launch(context);
          }).visible(mIsTopSellBook),
          BookProductComponent(dashboardResponse.topSellBook).visible(mIsTopSellBook),
        ],
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: context.scaffoldBackgroundColor,
      body: SafeArea(
        child: FutureBuilder<DashboardResponse>(
          future: getDashboard(),
          builder: (_, snap) {
            if (!snap.hasData) return Loader();

            if (snap.hasError) {
              Widget error = noData;

              if (snap.error is SocketException) {
                error = noInternetError;
              }

              return snapWidgetHelper(snap, checkHasData: true, errorWidget: error);
            }
            setValue(IS_PAYPAL_ENABLED, snap.data!.isPayPalEnabled!);
            setValue(IS_PAYTM_ENABLED, snap.data!.isPayTmEnabled!);
            return NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    expandedHeight: snap.hasData
                        ? snap.data!.slider!.isNotEmpty
                            ? (MediaQuery.of(context).size.width * 0.55) + 60
                            : 60
                        : 0,
                    floating: false,
                    pinned: true,
                    titleSpacing: 0,
                    leading: InkWell(
                      child: Container(
                        padding: EdgeInsets.all(16),
                        child: SvgPicture.asset(
                          icon_menu,
                          color: context.theme.iconTheme.color,
                        ),
                      ),
                      onTap: () {
                        _scaffoldKey.currentState!.openDrawer();
                      },
                      radius: 12.0,
                    ),
                    backgroundColor: context.scaffoldBackgroundColor,
                    actionsIconTheme: context.theme.iconTheme,
                    actions: <Widget>[
                      InkWell(
                        child: Container(
                          width: 40,
                          height: 40,
                          padding: EdgeInsets.all(10.0),
                          child: SvgPicture.asset(
                            icon_search,
                            color: context.theme.iconTheme.color,
                          ),
                        ),
                        onTap: () {
                          SearchScreen().launch(context);
                        },
                        radius: 12.0,
                      ),
                      cartIcon(context, cartCount).visible(isUserLogin)
                    ],
                    title: Text(
                      keyString(context, "app_name"),
                      style: boldTextStyle(color: context.theme.textTheme.headline6!.color, size: 20),
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      background: snap.hasData
                          ? snap.data!.slider!.isNotEmpty
                              ? slider(snap.data!.slider)
                              : SizedBox()
                          : SizedBox(),
                    ),
                  ),
                ];
              },
              body: RefreshIndicator(
                onRefresh: () async {
                  setState(() {});
                  return Future.value(false);
                },
                child: SingleChildScrollView(
                  child: snap.hasData ? containerBody(snap.data!) : Loader(),
                ),
              ),
            );
          },
        ),
      ),
      drawer: HomeDrawer(),
    );
  }
}
