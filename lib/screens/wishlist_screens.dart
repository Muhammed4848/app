import 'package:flutter/material.dart';
import 'package:granth_flutter/models/response/book_detail.dart';
import 'package:granth_flutter/models/response/wishlist_response.dart';
import 'package:granth_flutter/screens/book_description_screen.dart';
import 'package:granth_flutter/screens/book_description_screen2.dart';
import 'package:granth_flutter/utils/common.dart';
import 'package:granth_flutter/utils/constants.dart';
import 'package:granth_flutter/utils/resources/colors.dart';
import 'package:granth_flutter/utils/widgets.dart';
import 'package:nb_utils/nb_utils.dart';

import '../app_localizations.dart';

class WishlistScreen extends StatefulWidget {
  static String tag = '/WishlistScreen';

  @override
  _WishlistScreenState createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen>
    with AfterLayoutMixin<WishlistScreen> {
  List<WishListItem> list = [];
  bool mIsFirstTime = true;

  @override
  void afterFirstLayout(BuildContext context) async {
    if (mIsFirstTime) {
      LiveStream().on(WISH_LIST_DATA_CHANGED, (value) {
        if (mounted) {
          setState(() {
            list.clear();
            list.addAll(value as Iterable<WishListItem>);
          });
        }
      });
      LiveStream().on(CART_COUNT_ACTION, (value) {
        if (!mounted) {
          return;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: context.scaffoldBackgroundColor,
        iconTheme: context.theme.iconTheme,
        centerTitle: true,
        actions: <Widget>[
          cartIcon(context, getIntAsync(CART_COUNT))
              .visible(getBoolAsync(IS_LOGGED_IN)),
        ],
        title: Column(
          children: <Widget>[
            Text(keyString(context, "lbl_wish_list"),
                    style: boldTextStyle(
                        color: context.theme.textTheme.headline6!.color))
                .paddingTop(12.0),
            2.height,
            Text(list.length.toString() + ' ' + keyString(context, "lbl_books"),
                style: primaryTextStyle(color: textColorSecondary, size: 14)),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 16),
        child: FutureBuilder<List<WishListItem>?>(
          future: wishListItems(),
          builder: (_, snap) {
            if (list.isEmpty) {
              list.addAll(snap.data!);
            }
            if (snap.hasData) {
              return Wrap(
                runSpacing: 16,
                spacing: 8,
                children: list.map(
                  (e) {
                    WishListItem data = list[list.indexOf(e)];
                    return InkWell(
                      onTap: () {
                        if (getIntAsync(DETAIL_PAGE_VARIANT, defaultValue: 2) ==
                            1) {
                          BookDescriptionScreen(
                                  bookDetail: BookDetail(bookId: data.book_id))
                              .launch(context);
                        } else {
                          BookDescriptionScreen2(
                                  bookDetail: BookDetail(bookId: data.book_id))
                              .launch(context);
                        }
                      },
                      child: Container(
                        width: context.width() / 2 - 8,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              decoration: boxDecorationWithShadow(
                                borderRadius: radiusOnly(
                                    topLeft: 8,
                                    topRight: 8,
                                    bottomLeft: 8,
                                    bottomRight: 8),
                                spreadRadius: 2,
                                blurRadius: 2,
                                backgroundColor: context.cardColor,
                                border:
                                    Border.all(color: Colors.white, width: 2.0),
                                offset: Offset(3, 2),
                              ),
                              child: cachedImage(
                                data.front_cover,
                                fit: BoxFit.fill,
                                height: 250,
                                width: 170,
                                radius: 0,
                              ).cornerRadiusWithClipRRectOnly(
                                  topLeft: 8,
                                  topRight: 8,
                                  bottomLeft: 8,
                                  bottomRight: 8),
                            ),
                            10.height,
                            Text(
                              data.name
                                  .toString()
                                  .validate()
                                  .capitalizeFirstLetter(),
                              style: boldTextStyle(
                                  color:
                                      context.theme.textTheme.headline6!.color,
                                  size: 16),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                            ),
                            4.height,
                            Text(
                              data.author_name
                                  .toString()
                                  .validate()
                                  .capitalizeFirstLetter(),
                              style: primaryTextStyle(
                                  size: 13,
                                  color:
                                      context.theme.textTheme.subtitle2!.color),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ).toList(),
              );
            }
            return snapWidgetHelper(snap);
          },
        ),
      ),
      /* body: SingleChildScrollView(child: wishlist()),*/
    );
  }
}
