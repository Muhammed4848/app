import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:granth_flutter/component/EpubFilenew.dart';
import 'package:granth_flutter/component/book_product_component.dart';
import 'package:granth_flutter/models/response/author.dart';
import 'package:granth_flutter/models/response/base_response.dart';
import 'package:granth_flutter/models/response/book_description.dart';
import 'package:granth_flutter/models/response/book_detail.dart';
import 'package:granth_flutter/models/response/book_rating.dart';
import 'package:granth_flutter/network/rest_apis.dart';
import 'package:granth_flutter/screens/book_reviews_screen.dart';
import 'package:granth_flutter/screens/sign_in_screen.dart';
import 'package:granth_flutter/utils/common.dart';
import 'package:granth_flutter/utils/constants.dart';
import 'package:granth_flutter/utils/database_helper.dart';
import 'package:granth_flutter/utils/permissions.dart';
import 'package:granth_flutter/utils/resources/colors.dart';
import 'package:granth_flutter/utils/resources/images.dart';
import 'package:granth_flutter/utils/widgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:share/share.dart';

import '../app_localizations.dart';

// ignore: must_be_immutable
class BookDescriptionScreen2 extends StatefulWidget {
  static String tag = '/BookDetailScreen';
  BookDetail? bookDetail;

  BookDescriptionScreen2({Key? key, this.bookDetail}) : super(key: key);

  @override
  _BookDescriptionScreen2State createState() => _BookDescriptionScreen2State();
}

class _BookDescriptionScreen2State extends State<BookDescriptionScreen2> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TargetPlatform? platform;
  TabController? tabController;

  TextEditingController controller = TextEditingController();

  double rating = 0.0;
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  BookDetail? mBookDetail;
  late AuthorDetail mAuthorDetail;
  BookRating? userReviewData;

  bool isLoading = false;
  bool isExistInCart = false;
  bool _sampleFileExist = false;
  bool _purchasedFileExist = false;
  bool _isPDFFile = false;

  List<BookRating> bookRating = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    500.milliseconds.delay.then((value) => setStatusBarColor(context.scaffoldBackgroundColor, statusBarBrightness: Brightness.light));

    if (widget.bookDetail != null) {
      mBookDetail = widget.bookDetail;
    }

    log("book data isWishList${mBookDetail!.isWishList.toString()}");
    log("book data price${mBookDetail!.price.toString()}");
    log("book data purchase${mBookDetail!.is_purchase.toString()}");
    log("book data _sampleFileExist${_sampleFileExist.toString()}");

    tabController = TabController(length: 3, vsync: this);
    final filename = widget.bookDetail!.filePath.substring(widget.bookDetail!.filePath.toString().lastIndexOf("/") + 1);

    if (filename.contains(".pdf")) {
      _isPDFFile = true;
    } else if (filename.contains(".epub")) {
      _isPDFFile = false;
    }
    _sampleFileExist = await checkFileIsExist(bookId: mBookDetail!.bookId.toString(), bookPath: mBookDetail!.fileSamplePath, sampleFile: true);
    _purchasedFileExist = await checkFileIsExist(bookId: mBookDetail!.bookId.toString(), bookPath: mBookDetail!.filePath, sampleFile: false);

    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void showLoading(bool show) {
    isLoading = show;
    setState(() {});
  }

  void showRatingDialog(BuildContext context) {
    showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Scaffold(
          backgroundColor: transparent,
          body: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    width: context.width() - 40,
                    padding: EdgeInsets.all(16),
                    decoration: boxDecorationWithShadow(backgroundColor: context.cardColor, borderRadius: radius(8)),
                    child: Column(
                      children: <Widget>[
                        Text(keyString(context, "lbl_rateBook"), style: boldTextStyle(size: 24, color: context.theme.textTheme.headline6!.color)).paddingAll(10),
                        Divider(thickness: 0.5),
                        RatingBar.builder(
                          initialRating: rating,
                          minRating: 0,
                          glow: false,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (v) {
                            rating = v;
                            setState(() {});
                          },
                        ),
                        Form(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: AppTextField(
                            textStyle: primaryTextStyle(color: context.theme.textTheme.headline6!.color, size: 14),
                            controller: controller,
                            keyboardType: TextInputType.multiline,
                            maxLines: 5,
                            validator: (value) {
                              return value!.isEmpty ? keyString(context, "error_review_requires") : null;
                            },
                            decoration: inputDecoration(context, label: keyString(context, "aRate_hint")),
                            textFieldType: TextFieldType.ADDRESS,
                          ),
                        ),
                        30.height,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            AppButton(
                              textColor: context.theme.textTheme.headline6!.color,
                              child: Text(
                                keyString(context, "aRate_lbl_Cancel"),
                                style: primaryTextStyle(color: context.theme.textTheme.headline6!.color),
                              ),
                              onTap: () {
                                finish(context, ConfirmAction.CANCEL);
                              },
                            ).expand(),
                            16.width,
                            AppButton(
                              color: context.primaryColor,
                              textColor: Colors.white,
                              text: keyString(context, "lbl_post"),
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  submitReview(controller.text, rating);
                                }
                              },
                            ).expand()
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> submitReview(String text, double rating) async {
    isNetworkAvailable().then((bool) {
      if (bool) {
        if (userReviewData != null) {
          var request = {
            "book_id": mBookDetail!.bookId,
            "user_id": getIntAsync(USER_ID),
            "rating_id": userReviewData!.ratingId,
            "rating": rating.toString(),
            "review": text,
          };
          showLoading(true);

          updateBookRating(request).then((result) {
            BaseResponse response = BaseResponse.fromJson(result);
            if (response.status) {
              finish(context);
              setState(() {});
            } else {
              showLoading(false);
              toast(response.message);
            }
            return response.status;
          }).catchError((error) {
            showLoading(false);
            toast(error.toString());
          });
        } else {
          var request = {
            "book_id": mBookDetail!.bookId,
            "user_id": getIntAsync(USER_ID),
            "rating": rating.toString(),
            "review": text,
            "message": "",
            "status": true,
          };
          showLoading(true);
          addBookRating(request).then((result) {
            BaseResponse response = BaseResponse.fromJson(result);
            if (response.status) {
              finish(context);
              setState(() {});
            } else {
              showLoading(false);
              toast(response.message);
            }
            return response.status;
          }).catchError((error) {
            toast(error.toString());
            showLoading(false);
          });
        }
      } else {
        toast(keyString(context, "error_network_no_internet"));
      }
    });
  }

  void deleteBookRating(ratingId) async {
    isNetworkAvailable().then((bool) {
      if (bool) {
        showLoading(true);
        var request = {
          "id": userReviewData!.ratingId,
        };
        deleteRating(request).then((result) {
          BaseResponse response = BaseResponse.fromJson(result);
          if (response.status) {
            setState(() {});
          } else {
            showLoading(false);
            toast(response.message);
          }
        }).catchError((error) {
          toast(error.toString());
          showLoading(false);
        });
      } else {
        toast(keyString(context, "error_network_no_internet"));
      }
    });
  }

  void addRemoveToWishList(isWishList) {
    addRemoveWishList(context, mBookDetail!.bookId, isWishList);
  }

  addRemoveWishList(context, int? id, int? isWishList) async {
    toast(keyString(context, 'lbl_processing'));
    await isNetworkAvailable().then((bool) {
      if (bool) {
        var request = {"book_id": id, "is_wishlist": isWishList};
        addFavourite(request).then((result) {
          BaseResponse response = BaseResponse.fromJson(result);
          if (response.status) {
            LiveStream().emit(WISH_DATA_ITEM_CHANGED, true);
            setState(() {});
          }
        }).catchError((error) {
          toast(error.toString());
        });
      } else {
        toast(keyString(context, "error_network_no_internet"));
      }
    });
  }

  void addBookToCart() {
    isNetworkAvailable().then((bool) {
      if (bool) {
        showLoading(true);

        var request = {"book_id": mBookDetail!.bookId, "added_qty": 1, "user_id": getIntAsync(USER_ID)};
        addToCart(request).then((result) {
          BaseResponse response = BaseResponse.fromJson(result);
          if (response.status) {
            LiveStream().emit(CART_ITEM_CHANGED, true);
            toast(response.message);
            setState(() {});
          } else {
            showLoading(false);
          }
        }).catchError((error) {
          showLoading(false);
          toast(error.toString());
        });
      } else {
        toast(keyString(context, "error_network_no_internet"));
      }
    });
  }

  Widget ratingWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        RatingBar.builder(
          tapOnlyMode: true,
          initialRating: double.parse(mBookDetail!.totalRating.toString()),
          minRating: 0,
          glow: false,
          itemSize: 15,
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
        6.width,
        Text("${double.parse(mBookDetail!.totalRating.toStringAsFixed(1))} (${mBookDetail!.totalReview.toString()})", style: primaryTextStyle(color: context.theme.textTheme.headline6!.color)),
      ],
    );
  }

  Widget priceWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          mBookDetail!.discountedPrice != 0 ? mBookDetail!.discountedPrice.toString().toCurrencyFormat()! : mBookDetail!.price.toString().toCurrencyFormat()!,
          style: boldTextStyle(color: context.primaryColor, size: 16),
        ).visible(mBookDetail!.discountedPrice != 0 || mBookDetail!.price != 0),
        6.width,
        Text(
          mBookDetail!.price.toString().toCurrencyFormat()!,
          style: primaryTextStyle(decoration: TextDecoration.lineThrough),
        ).visible(mBookDetail!.discount != 0),
      ],
    );
  }

  Widget discountWidget() {
    return Text("~ " + mBookDetail!.discount.toString() + keyString(context, "lbl_your_discount"), style: boldTextStyle(color: Theme.of(context).errorColor));
  }

  @override
  Widget build(BuildContext context) {
    platform = Theme.of(context).platform;

    Widget body() {
      return FutureBuilder<BookDescription>(
        future: getBookDetail({"book_id": widget.bookDetail!.bookId, "user_id": getIntAsync(USER_ID)}),
        builder: (_, snap) {
          if (snap.hasData) {
            mBookDetail = snap.data!.bookDetail!.first;
            mAuthorDetail = snap.data!.authorDetail!.first;
            bookRating.addAll(snap.data!.bookRatingData!);
            userReviewData = snap.data!.userReviewData;
          }
          return Scaffold(
            appBar: appBarWidget(
              widget.bookDetail!.name.toString().validate(),
              color: context.scaffoldBackgroundColor,
              textColor: context.theme.textTheme.headline6!.color,
              actions: [
                /* disabling  Icon button next to wish list button
                IconButton(
                    icon: SvgPicture.asset(
                      icon_share,
                      color: context.theme.iconTheme.color,
                    ),
                    onPressed: () {
                      Share.share(mBookDetail!.name + keyString(context, 'by') + mBookDetail!.authorName + "\n" + mBaseUrl + "book/detail/" + mBookDetail!.bookId.toString());
                    }),


                 */
                IconButton(
                    icon: SvgPicture.asset(mBookDetail!.isWishList == 1 ? icon_bookmark_fill : icon_bookmark, color: context.theme.iconTheme.color),
                    onPressed: () {
                      if (getBoolAsync(IS_LOGGED_IN)) {
                        setState(() {
                          mBookDetail!.isWishList = mBookDetail!.isWishList == 0 ? 1 : 0;
                        });
                        addRemoveToWishList(mBookDetail!.isWishList);
                      } else {
                        SignInScreen().launch(context);
                      }
                    }).visible(mBookDetail!.is_purchase == 0),
                cartIcon(context, getIntAsync(CART_COUNT)),
              ],
            ),
            body: snap.hasData
                ? Container(
                    child: NestedScrollView(
                      headerSliverBuilder: (_, innerScrolled) {
                        return [
                          SliverList(
                            delegate: SliverChildListDelegate(
                              [
                                Stack(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  children: [
                                    Container(
                                      height: context.height() * 0.30,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: Image.network(snap.data!.bookDetail!.first.frontCover.toString().validate()).image,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      child: ClipRRect(
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                                          child: Container(
                                            padding: EdgeInsets.only(top: 22, left: 20),
                                            width: context.width(),
                                            color: Colors.black.withOpacity(0.1),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 30,
                                      left: 8,
                                      child: Row(
                                        children: [
                                          Container(
                                            decoration: boxDecorationWithShadow(
                                              borderRadius: radiusOnly(topLeft: 8, topRight: 8, bottomLeft: 8, bottomRight: 8),
                                              spreadRadius: 2,
                                              blurRadius: 2,
                                              backgroundColor: context.cardColor,
                                              border: Border.all(color: Colors.white, width: 2.0),
                                              offset: Offset(3, 2),
                                            ),
                                            child: cachedImage(
                                              snap.data!.bookDetail!.first.frontCover,
                                              fit: BoxFit.fill,
                                              height: context.height() * 0.25,
                                              width: 140,
                                              radius: 0,
                                            ).cornerRadiusWithClipRRectOnly(topLeft: 8, topRight: 8, bottomLeft: 8, bottomRight: 8),
                                          ),
                                          16.width,
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                snap.data!.bookDetail!.first.name.toString().validate().capitalizeFirstLetter(),
                                                style: boldTextStyle(size: 20, color: Colors.white),
                                                maxLines: 4,
                                              ),
                                              8.height,
                                              Text(
                                                snap.data!.bookDetail!.first.categoryName.toString().validate(),
                                                style: secondaryTextStyle(size: 18, color: Colors.white),
                                              ),
                                              8.height,
                                              Row(
                                                children: [
                                                  Container(
                                                    height: 30,
                                                    width: 30,
                                                    decoration: boxDecorationWithShadow(boxShape: BoxShape.circle, backgroundColor: context.cardColor),
                                                    child: cachedImage(mAuthorDetail.image.toString().validate(), fit: BoxFit.fill).cornerRadiusWithClipRRect(80),
                                                  ),
                                                  6.width,
                                                  Text(mAuthorDetail.name.toString().validate(), style: primaryTextStyle(size: 16, color: Colors.white)),
                                                ],
                                              ),
                                              8.height,
                                              Container(
                                                margin: EdgeInsets.only(top: 12.0),
                                                padding: EdgeInsets.all(6),
                                                decoration: boxDecorationWithRoundedCorners(
                                                  backgroundColor: context.theme.highlightColor,
                                                  borderRadius: radius(8),
                                                ),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: <Widget>[
                                                    RatingBar.builder(
                                                      tapOnlyMode: true,
                                                      initialRating: double.parse(mBookDetail!.totalRating.toString()),
                                                      minRating: 0,
                                                      glow: false,
                                                      itemSize: 15,
                                                      direction: Axis.horizontal,
                                                      ignoreGestures: true,
                                                      allowHalfRating: true,
                                                      itemCount: 5,
                                                      itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                                                      itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
                                                      onRatingUpdate: (double value) {
                                                        //
                                                      },
                                                    ),
                                                    Text(double.parse(mBookDetail!.totalRating.toStringAsFixed(1)).toString(), style: primaryTextStyle(color: context.theme.textTheme.headline6!.color))
                                                        .paddingOnly(left: 8),
                                                  ],
                                                ),
                                              ),
                                              8.height,
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                          mBookDetail!.discountedPrice != 0
                                                              ? mBookDetail!.discountedPrice.toString().toCurrencyFormat()!
                                                              : mBookDetail!.price.toString().toCurrencyFormat()!,
                                                          style: boldTextStyle(color: Colors.white, size: 22))
                                                      .visible(mBookDetail!.discountedPrice != 0 || mBookDetail!.price != 0),
                                                  Text(mBookDetail!.price.toString().toCurrencyFormat()!, style: primaryTextStyle(color: Colors.white, decoration: TextDecoration.lineThrough))
                                                      .paddingOnly(left: 8.0)
                                                      .visible(mBookDetail!.discount != 0),
                                                ],
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    AppButton(
                                      color: Theme.of(context).colorScheme.secondary,  //cardTheme.color,
                                      child: Text(_sampleFileExist ? keyString(context, 'lbl_view_sample') : keyString(context, 'lbl_download_sample')),
                                      onTap: () async {
                                        if (await Permissions.storageGranted()) {
                                          await ViewEPubFileNew(
                                              bookName: await getBookFileName(mBookDetail!.bookId.toString(), mBookDetail!.fileSamplePath.toString(), isSample: true),
                                              mBookId: mBookDetail!.bookId.toString(),
                                              mBookImage: mBookDetail!.frontCover,
                                              platform: platform!,
                                              isPDFFile: _isPDFFile,
                                              isFileExist: _sampleFileExist,
                                              bookPath: mBookDetail!.fileSamplePath,
                                              isSampleFile: true,
                                              mFileType: SAMPLE_BOOK,
                                              bookTitle: widget.bookDetail!.name,
                                              onUpdate: () {
                                                setState(() {
                                                  _sampleFileExist = true;
                                                });
                                              }).launch(context);
                                        }
                                      },
                                    ).expand(),
                                    16.width,

                                    if(mBookDetail!.is_purchase == 0 && mBookDetail!.price != "0")
                                         AppButton(
                                            color: Theme.of(context).colorScheme.secondary,
                                            child: Text(keyString(context, 'add_to_cart'), style: boldTextStyle(color: Colors.white)),
                                            onTap: () {
                                              if (getBoolAsync(IS_LOGGED_IN)) {
                                                if (isExistInCart) {
                                                  toast(keyString(context, 'already_exits_in_cart'));
                                                } else {
                                                  addBookToCart();
                                                  LiveStream().on("updateCart", (status) {
                                                    if (status as bool? ?? false) {
                                                      setState(() {});
                                                    }
                                                  });
                                                }
                                              } else {
                                                SignInScreen().launch(context);
                                              }
                                            },
                                          ).expand(),

                                    if(mBookDetail!.is_purchase == 1 || mBookDetail!.price == "0")
                                         AppButton(
                                            color: Theme.of(context).colorScheme.secondary,
                                            child: Text(keyString(context, 'read_book'), style: boldTextStyle(color: Colors.white)),
                                            onTap: () async {
                                              if (await Permissions.storageGranted()) {
                                                ViewEPubFileNew(
                                                        bookName: await getBookFileName(mBookDetail!.bookId.toString(), mBookDetail!.filePath.toString(), isSample: false),
                                                        mBookId: mBookDetail!.bookId.toString(),
                                                        mBookImage: mBookDetail!.frontCover,
                                                        platform: platform!,
                                                        isPDFFile: _isPDFFile,
                                                        isFileExist: _purchasedFileExist,
                                                        isSampleFile: false,
                                                        mFileType: PURCHASED_BOOK,
                                                        bookTitle: widget.bookDetail!.name,
                                                        onUpdate: () {
                                                          _purchasedFileExist = true;
                                                        },
                                                        bookPath: mBookDetail!.filePath)
                                                    .launch(context);
                                              }
                                            },
                                          ).expand()

                                  ],
                                ).paddingSymmetric(horizontal: 8, vertical: 16)
                              ],
                            ),
                          ),
                        ];
                      },
                      body: DefaultTabController(
                        length: 3,
                        child: Column(
                          children: [
                            TabBar(
                              isScrollable: false,
                              controller: tabController,
                              indicatorSize: TabBarIndicatorSize.tab,
                              indicatorColor: context.theme.textTheme.headline6!.color,
                              labelPadding: EdgeInsets.only(left: 10, right: 10),
                              tabs: [
                                Tab(child: Text(keyString(context, 'overView'), style: boldTextStyle(color: context.theme.textTheme.headline6!.color))),
                                Tab(child: Text(keyString(context, 'information'), style: boldTextStyle(color: context.theme.textTheme.headline6!.color))),
                                Tab(child: Text(keyString(context, 'reviews'), style: boldTextStyle(color: context.theme.textTheme.headline6!.color))),
                              ],
                            ),
                            TabBarView(
                              controller: tabController,
                              children: [
                                overViewWidget(snap),
                                informationWidget(snap),
                                reviewWidget(snap),
                              ],
                            ).expand(),
                          ],
                        ),
                      ),
                    ),
                  )
                : Loader(),
          );
        },
      );
    }

    return body();
  }

  Widget overViewWidget(AsyncSnapshot<BookDescription> snap) {
    return Container(
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: [
          Text(
            parseHtmlString(mBookDetail!.description),
            style: primaryTextStyle(color: context.theme.textTheme.headline6!.color),
          ).paddingAll(16),
          16.height,
          Row(
            children: [
              Text(keyString(context, "lbl_more_books_by_this_author"), style: boldTextStyle(size: 18, color: context.theme.textTheme.headline6!.color))
                  .visible(
                    snap.data!.recommendedBook!.isNotEmpty,
                  )
                  .expand(),
            ],
          ).paddingSymmetric(horizontal: 16),
          BookProductComponent(snap.data!.authorBookList, isHorizontal: true),
          32.height,
          Row(
            children: [
              Text(keyString(context, "lnl_you_may_also_like"), style: boldTextStyle(size: 18, color: context.theme.textTheme.headline6!.color))
                  .visible(
                    snap.data!.recommendedBook!.isNotEmpty,
                  )
                  .expand(),
            ],
          ).paddingSymmetric(horizontal: 16),
          BookProductComponent(snap.data!.recommendedBook)
        ],
      ),
    );
  }

  Widget reviewWidget(AsyncSnapshot<BookDescription> snap) {
    return Container(
      child: ListView(
        padding: EdgeInsets.all(16),
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [
          Row(
            children: [
              Text(keyString(context, "lbl_top_reviews"), style: boldTextStyle(color: context.theme.textTheme.headline6!.color)).expand(),
              Text(
                keyString(context, "lbl_view_all"),
                style: secondaryTextStyle(color: Theme.of(context).textTheme.button!.color),
              ).onTap(() {
                BookReviews(bookDetail: mBookDetail).launch(context);
              })
            ],
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: snap.data!.bookRatingData!.length <= 5 ? snap.data!.bookRatingData!.length : 5,
            itemBuilder: (context, index) {
              BookRating bookRating = snap.data!.bookRatingData![index];
              return review(context, bookRating, isUserReview: true, callback: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Theme(
                      data: ThemeData(canvasColor: context.scaffoldBackgroundColor),
                      child: AlertDialog(
                        title: Text(keyString(context, "lbl_confirmation")),
                        content: Text(keyString(context, "lbl_note_delete")),
                        actions: <Widget>[
                          AppButton(
                            child: Text(keyString(context, "close")),
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          AppButton(
                            child: Text(keyString(context, "lbl_ok")),
                            onTap: () {
                              Navigator.of(context).pop();
                              deleteBookRating(userReviewData!.ratingId);
                            },
                          )
                        ],
                      ),
                    );
                  },
                );
              });
            },
          ),
          16.height,
          MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            elevation: 4.0,
            padding: EdgeInsets.fromLTRB(24, 10.0, 24, 10.0),
            color: Theme.of(context).cardTheme.color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
              side: BorderSide(color: Theme.of(context).cardTheme.color!),
            ),
            child: Text(keyString(context, "lbl_write_review"), style: primaryTextStyle(color: context.theme.textTheme.headline6!.color)),
            onPressed: () async {
              if (getBoolAsync(IS_LOGGED_IN)) {
                showRatingDialog(context);
              } else {
                SignInScreen().launch(context);
              }
            },
          ).visible(userReviewData == null)
        ],
      ),
    );
  }

  Widget informationWidget(AsyncSnapshot<BookDescription> snap) {
    BookDetail authorDetail = snap.data!.bookDetail!.first;
    return Container(
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [
          SettingItemWidget(
            titleTextStyle: primaryTextStyle(color: context.theme.textTheme.subtitle2!.color),
            title: keyString(context, 'category'),
            trailing: Text(authorDetail.categoryName, style: primaryTextStyle(color: context.theme.textTheme.headline6!.color)),
          ),
          Divider(),
          SettingItemWidget(
            titleTextStyle: primaryTextStyle(color: context.theme.textTheme.subtitle2!.color),
            title: keyString(context, 'created'),
            trailing: Text(authorDetail.dateOfPublication, style: primaryTextStyle(color: context.theme.textTheme.headline6!.color)),
          ),
          Divider(),
          SettingItemWidget(
            titleTextStyle: primaryTextStyle(color: context.theme.textTheme.subtitle2!.color),
            title: keyString(context, 'author'),
            trailing: Text(authorDetail.authorName, style: primaryTextStyle(color: context.theme.textTheme.headline6!.color)),
          ),
          Divider(),
          SettingItemWidget(
            titleTextStyle: primaryTextStyle(color: context.theme.textTheme.subtitle2!.color),
            title: keyString(context, 'publisher'),
            trailing: Text(authorDetail.publisher, style: primaryTextStyle(color: context.theme.textTheme.headline6!.color)),
          ),
          Divider(),
          SettingItemWidget(
            titleTextStyle: primaryTextStyle(color: context.theme.textTheme.subtitle2!.color),
            title: keyString(context, 'language'),
            trailing: Text(authorDetail.language, style: primaryTextStyle(color: context.theme.textTheme.headline6!.color)),
          ),
          Divider(),
          SettingItemWidget(
            titleTextStyle: primaryTextStyle(color: context.theme.textTheme.subtitle2!.color),
            title: keyString(context, 'available_format'),
            trailing: Text(authorDetail.format, style: primaryTextStyle(color: context.theme.textTheme.headline6!.color)),
          ),
          Divider(),
        ],
      ),
    );
  }
}
