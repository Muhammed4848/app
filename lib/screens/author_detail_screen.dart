import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:granth_flutter/component/book_widget_component.dart';
import 'package:granth_flutter/models/response/author.dart';
import 'package:granth_flutter/models/response/book_detail.dart';
import 'package:granth_flutter/models/response/book_list.dart';
import 'package:granth_flutter/network/rest_apis.dart';
import 'package:granth_flutter/utils/widgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:readmore/readmore.dart';

import '../app_localizations.dart';

// ignore: must_be_immutable
class AuthorDetailScreen extends StatefulWidget {
  static String tag = '/AuthorDetailScreen';
  AuthorDetail? authorDetail;

  AuthorDetailScreen({this.authorDetail});

  @override
  AuthorDetailScreenState createState() => AuthorDetailScreenState();
}

class AuthorDetailScreenState extends State<AuthorDetailScreen> with TickerProviderStateMixin<AuthorDetailScreen> {
  int totalBooks = 0;
  int page = 1;
  bool isLastPage = false;

  List<BookDetail> list = [];
  bool isList = false;
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
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        iconTheme: context.theme.iconTheme,
        backgroundColor: context.scaffoldBackgroundColor,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: NotificationListener(
          onNotification: (dynamic n) {
            if (!isLastPage && isReady) {
              if (n is ScrollEndNotification) {
                page++;
                isReady = false;

                setState(() {});
              }
            }
            return !isLastPage;
          },
          child: FutureBuilder<BookListResponse>(
            future: getBookList(page, widget.authorDetail!.author_id),
            builder: (context, snap) {
              if (snap.hasData) {
                if (page == 1) list.clear();

                list.addAll(snap.data!.data!);

                isReady = true;
                totalBooks = snap.data!.pagination!.totalItems.validate();

                isLastPage = snap.data!.pagination!.totalItems.validate() <= list.length;
                return SingleChildScrollView(
                  child: Container(
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  decoration: boxDecorationWithShadow(
                                    borderRadius: radius(8),
                                  ),
                                  child: cachedImage(widget.authorDetail!.image, height: 200, width: 150, fit: BoxFit.fill).cornerRadiusWithClipRRect(8),
                                ),
                                16.width,
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(widget.authorDetail!.name, style: boldTextStyle(size: 22, color: context.theme.textTheme.headline6!.color)),
                                    16.height,
                                    Text(keyString(context, "lbl_description"), style: boldTextStyle(color: context.theme.textTheme.headline6!.color)).withWidth(80),
                                    6.width,
                                    Text(widget.authorDetail!.designation.toString().capitalizeFirstLetter(), style: primaryTextStyle(color: context.theme.textTheme.subtitle2!.color)),
                                    16.height,
                                    Text(keyString(context, "lbl_address"), style: boldTextStyle(color: context.theme.textTheme.headline6!.color)).withWidth(80),
                                    6.width,
                                    Text(widget.authorDetail!.address, style: primaryTextStyle(color: context.theme.textTheme.subtitle2!.color)),
                                    16.height,
                                    Text(keyString(context, "lbl_education"), style: boldTextStyle(color: context.theme.textTheme.headline6!.color)).withWidth(80),
                                    6.width,
                                    Text(widget.authorDetail!.education, style: primaryTextStyle(color: context.theme.textTheme.subtitle2!.color)),
                                  ],
                                ).expand()
                              ],
                            ),
                            16.height,
                            ReadMoreText(
                              widget.authorDetail!.description,
                              style: primaryTextStyle(color: context.theme.textTheme.subtitle2!.color),
                            ),
                            16.height,
                            Text("${keyString(context, "lbl_publishBook")} (${totalBooks.toString()})", style: boldTextStyle(color: context.theme.textTheme.headline6!.color)),
                            16.height,
                            Wrap(
                              spacing: 16,
                              runSpacing: 16,
                              children: list.map((e) {
                                BookDetail data = list[list.indexOf(e)];
                                return BookItemWidget(
                                  bookDetail: data,
                                  width: context.width() / 2 - 24,
                                );
                              }).toList(),
                            )
                          ],
                        ),
                        if (snap.connectionState == ConnectionState.waiting) Loader(),
                      ],
                    ),
                  ),
                );
              }
              return snapWidgetHelper(snap);
            },
          ),
        ),
      ),
    );
  }
}
