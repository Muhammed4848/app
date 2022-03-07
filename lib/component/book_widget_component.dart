import 'package:flutter/material.dart';
import 'package:granth_flutter/models/response/book_detail.dart';
import 'package:granth_flutter/screens/book_description_screen.dart';
import 'package:granth_flutter/screens/book_description_screen2.dart';
import 'package:granth_flutter/utils/constants.dart';
import 'package:granth_flutter/utils/widgets.dart';
import 'package:nb_utils/nb_utils.dart';

// ignore: must_be_immutable
class BookItemWidget extends StatelessWidget {
  final BookDetail? bookDetail;
  double width;

  BookItemWidget({this.bookDetail, this.width = 170});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          InkWell(
            child: Container(
              decoration: boxDecorationWithShadow(
                borderRadius: radiusOnly(topLeft: 8, topRight: 8, bottomLeft: 8, bottomRight: 8),
                spreadRadius: 2,
                blurRadius: 2,
                border: Border.all(color: Colors.white, width: 2.0),
                offset: Offset(3, 2),
              ),
              child: cachedImage(
                bookDetail!.frontCover,
                fit: BoxFit.fill,
                height: 250,
                width: 170,
                radius: 0,
              ).cornerRadiusWithClipRRectOnly(topLeft: 8, topRight: 8, bottomLeft: 8, bottomRight: 8),
            ),
            onTap: () {
              if (getIntAsync(DETAIL_PAGE_VARIANT, defaultValue: 2) == 1) {
                BookDescriptionScreen(bookDetail: bookDetail).launch(context);
              } else {
                BookDescriptionScreen2(bookDetail: bookDetail).launch(context);
              }
            },
            radius: 8.0,
          ),
          10.height,
          Text(
            bookDetail!.name.toString().validate().capitalizeFirstLetter(),
            style: boldTextStyle(color: context.theme.textTheme.headline6!.color, size: 16),
            textAlign: TextAlign.center,
            maxLines: 1,
          ),
          4.height,
          Text(
            bookDetail!.authorName.toString().validate().capitalizeFirstLetter(),
            style: primaryTextStyle(size: 13, color: context.theme.textTheme.subtitle2!.color),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
