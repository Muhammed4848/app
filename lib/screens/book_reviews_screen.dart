import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:granth_flutter/models/response/book_detail.dart';
import 'package:granth_flutter/models/response/book_rating.dart';
import 'package:granth_flutter/models/response/book_rating_list.dart';
import 'package:granth_flutter/network/rest_apis.dart';
import 'package:granth_flutter/utils/constants.dart';
import 'package:granth_flutter/utils/counting_text.dart';
import 'package:granth_flutter/utils/widgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:readmore/readmore.dart';

import '../app_localizations.dart';

// ignore: must_be_immutable
class BookReviews extends StatefulWidget {
  static String tag = '/BookReviews';
  BookDetail? bookDetail;

  BookReviews({this.bookDetail});

  @override
  BookReviewsState createState() => BookReviewsState();
}

class BookReviewsState extends State<BookReviews> {
  List<BookRating> list = [];
  double fiveStar = 0;
  double fourStar = 0;
  double threeStar = 0;
  double twoStar = 0;
  double oneStar = 0;
  bool isLoading = false;

  showLoading(bool show) {
    setState(() {
      isLoading = show;
    });
  }

  setRating(List<BookRating> listing) {
    fiveStar = 0;
    fourStar = 0;
    threeStar = 0;
    twoStar = 0;
    oneStar = 0;
    listing.forEach((review) {
      switch (review.rating) {
        case 5:
          fiveStar++;
          break;
        case 4:
          fourStar++;
          break;
        case 3:
          threeStar++;
          break;
        case 2:
          twoStar++;
          break;
        case 1:
          oneStar++;
          break;
      }
    });
    fiveStar = (fiveStar * 100) / listing.length;
    fourStar = (fourStar * 100) / listing.length;
    threeStar = (threeStar * 100) / listing.length;
    twoStar = (twoStar * 100) / listing.length;
    oneStar = (oneStar * 100) / listing.length;
    print(fiveStar);
  }

  Widget reviewText(double rating, {int size = 15, fontSize = 18, fontFamily = font_medium}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          rating.toString(),
          style: primaryTextStyle(color: context.theme.textTheme.headline6!.color, size: size),
        ),
        4.width,
        Icon(Icons.star, color: Colors.amber, size: size.toDouble())
      ],
    );
  }

  Widget ratingProgress(value, color) {
    return Expanded(
      child: LinearPercentIndicator(
        lineHeight: 10.0,
        percent: value / 100,
        linearStrokeCap: LinearStrokeCap.roundAll,
        backgroundColor: Colors.grey.withOpacity(0.2),
        animation: true,
        animationDuration: 700,
        progressColor: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(keyString(context, "lbl_reviews"), color: context.scaffoldBackgroundColor, textColor: context.theme.textTheme.headline6!.color),
      body: Container(
          padding: EdgeInsets.all(8),
          child: SingleChildScrollView(
            child: Column(
              children: [
                32.height,
                Text(keyString(context, 'overall_rating'), style: boldTextStyle()).center(),
                6.height,
                CountingText(
                  style: boldTextStyle(size: 48),
                  begin: 0.0,
                  duration: 2.seconds,
                  end: double.parse(widget.bookDetail!.totalRating.toString()),
                  precision: 2,
                ),
                RatingBar.builder(
                  tapOnlyMode: true,
                  initialRating: double.parse(widget.bookDetail!.totalRating.toString()),
                  minRating: 0,
                  glow: false,
                  itemSize: 48,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  ignoreGestures: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                  itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
                  onRatingUpdate: (double value) {
                    //
                  },
                ),
                16.height,
                Text('${keyString(context, 'based_on')} ${widget.bookDetail!.totalReview} ${keyString(context, "lbl_reviews")}', style: boldTextStyle()).center(),
                16.height,
                Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[reviewText(5.0), ratingProgress(fiveStar, Colors.green)],
                    ),
                    2.height,
                    Row(
                      children: <Widget>[reviewText(4.0), ratingProgress(fourStar, Color(0xFF82D440))],
                    ),
                    2.height,
                    Row(
                      children: <Widget>[reviewText(3.0), ratingProgress(threeStar, Colors.yellow)],
                    ),
                    2.height,
                    Row(
                      children: <Widget>[reviewText(2.0), ratingProgress(twoStar, Colors.amber)],
                    ),
                    2.height,
                    Row(
                      children: <Widget>[reviewText(1.0), ratingProgress(oneStar, Colors.red)],
                    )
                  ],
                ).paddingSymmetric(horizontal: 32),
                16.height,
                Divider(),
                FutureBuilder<BookRatingList>(
                  future: getReview({"book_id": widget.bookDetail!.bookId}),
                  builder: (_, snap) {
                    if (snap.hasData) {
                      if (list.isNotEmpty) {
                        list.addAll(snap.data!.data!);
                        setRating(snap.data!.data!);
                      }
                      return ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snap.data!.data!.length,
                        shrinkWrap: true,
                        padding: EdgeInsets.all(8),
                        itemBuilder: (context, index) {
                          BookRating bookRating = snap.data!.data![index];
                          return Container(
                            padding: EdgeInsets.all(10.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                cachedImage(
                                  bookRating.profileImage.toString().validate(),
                                  height: 40,
                                  width: 40,
                                  fit: BoxFit.fill,
                                ).cornerRadiusWithClipRRect(80),
                                16.width,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(' ${bookRating.userName.toString().validate()}', style: boldTextStyle(color: context.theme.textTheme.headline6!.color)),
                                    4.height,
                                    RatingBar.builder(
                                      tapOnlyMode: true,
                                      initialRating: double.parse(bookRating.rating.toString()),
                                      minRating: 0,
                                      glow: false,
                                      itemSize: 16,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                                      itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
                                      onRatingUpdate: (double value) {
                                        //
                                      },
                                    ).withWidth(80),
                                    4.height,
                                    ReadMoreText(
                                      bookRating.review.toString().validate(),
                                      style: primaryTextStyle(color: context.theme.textTheme.subtitle2!.color),
                                    ),
                                    8.height,
                                    Text(bookRating.createdAt.toString(), style: secondaryTextStyle(color: context.theme.textTheme.subtitle2!.color)),
                                  ],
                                ).expand()
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return Divider(height: 0);
                        },
                      );
                    }
                    return snapWidgetHelper(snap);
                  },
                )
              ],
            ),
          )),
    );
  }
}
