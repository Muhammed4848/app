import 'package:flutter/material.dart';
import 'package:granth_flutter/component/book_grid_list_widget.dart';
import 'package:granth_flutter/models/response/book_detail.dart';
import 'package:granth_flutter/models/response/dashboard_response.dart';
import 'package:granth_flutter/network/rest_apis.dart';
import 'package:granth_flutter/utils/constants.dart';
import 'package:granth_flutter/utils/widgets.dart';
import 'package:nb_utils/nb_utils.dart';

// ignore: must_be_immutable
class ViewAllBooks extends StatefulWidget {
  static String tag = '/ViewAllBooks';
  var type;
  var title;
  var categoryId = '';
  ViewAllBooks({this.type, this.title, this.categoryId = ''});

  @override
  _ViewAllBooksState createState() => _ViewAllBooksState();
}

class _ViewAllBooksState extends State<ViewAllBooks> {
  List<BookDetail> list = [];

  int page = 1;
  bool isList = false;
  bool isLastPage = false;
  bool isReady = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: (dynamic n) {
        if (!isLastPage && isReady) {
          if (n is OverscrollNotification) {
            page++;
            isReady = false;
            setState(() {});
          }
        }
        return false;
      },
      child: FutureBuilder<DashboardResponse>(
        future: getViewAllBookNextPage(widget.type, page, categoryId: widget.categoryId),
        builder: (_, snap) {
          if (snap.hasData) {
            if (page == 1) list.clear();

            if (!isLastPage) {
              list.addAll(snap.data!.data!);
            }

            isReady = true;

            isLastPage = page == snap.data!.pagination!.totalPages;
            log(isLastPage);
          }

          return Scaffold(
            backgroundColor: context.scaffoldBackgroundColor,
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: context.scaffoldBackgroundColor,
              iconTheme: context.theme.iconTheme,
              centerTitle: true,
              actions: <Widget>[cartIcon(context, getIntAsync(CART_COUNT)).visible(getBoolAsync(IS_LOGGED_IN))],
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(widget.title.toString().validate(), style: boldTextStyle(size: 18, color: context.theme.textTheme.headline6!.color)),
                  2.height,
                  snap.hasData
                      ? Text(
                          snap.data!.pagination!.totalItems.validate().toString(),
                          style: primaryTextStyle(size: 14, color: context.theme.textTheme.subtitle2!.color),
                        )
                      : Offstage(),
                ],
              ),
            ),
            body: Stack(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: 24),
                  child: BookGridListWidget(list, totalDivision: 2),
                ),
                if (snap.connectionState == ConnectionState.waiting) Loader(),
              ],
            ),
          );
        },
      ),
    );
  }
}
