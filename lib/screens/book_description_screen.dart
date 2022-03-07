import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:granth_flutter/component/EpubFilenew.dart';
import 'package:granth_flutter/component/book_product_component.dart';
import 'package:granth_flutter/main.dart';
import 'package:granth_flutter/models/response/author.dart';
import 'package:granth_flutter/models/response/base_response.dart';
import 'package:granth_flutter/models/response/book_description.dart';
import 'package:granth_flutter/models/response/book_detail.dart';
import 'package:granth_flutter/models/response/book_rating.dart';
import 'package:granth_flutter/models/response/downloaded_book.dart';
import 'package:granth_flutter/network/rest_apis.dart';
import 'package:granth_flutter/screens/sign_in_screen.dart';
import 'package:granth_flutter/utils/admob_utils.dart';
import 'package:granth_flutter/utils/common.dart';
import 'package:granth_flutter/utils/constants.dart';
import 'package:granth_flutter/utils/database_helper.dart';
import 'package:granth_flutter/utils/permissions.dart';
import 'package:granth_flutter/utils/resources/colors.dart';
import 'package:granth_flutter/utils/resources/images.dart';
import 'package:granth_flutter/utils/widgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:readmore/readmore.dart';
import 'package:share/share.dart';

import '../app_localizations.dart';
import 'book_description_screen2.dart';
import 'book_reviews_screen.dart';

class BookDescriptionScreen extends StatefulWidget {
  static String tag = '/BookDescriptionScreen';
  BookDetail? bookDetail;

  BookDescriptionScreen({Key? key, this.bookDetail}) : super(key: key);

  @override
  BookDescriptionScreenState createState() => BookDescriptionScreenState();
}

class BookDescriptionScreenState extends State<BookDescriptionScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final dbHelper = DatabaseHelper.instance;

  BookDetail? mBookDetail;
  AuthorDetail? mAuthorDetail;
  BookRating? userReviewData;

  List<BookRating> bookRating = [];

  TextEditingController controller = TextEditingController();

  double rating = 0.0;

  DownloadedBook? mSampleDownloadTask;
  DownloadedBook? mBookDownloadTask;

  bool isExistInCart = false;
  bool mIsFirstTime = true;
  bool isLoading = false;
  bool _isPDFFile = false;
  bool _sampleFileExist = false;
  bool _purchasedFileExist = false;

  //BannerAd? _bannerAd;
  TargetPlatform? platform;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    1.seconds.delay.then((value) => setStatusBarColor(Theme.of(context).cardTheme.color!, statusBarBrightness: Brightness.light));
    if (widget.bookDetail != null) {
      mBookDetail = widget.bookDetail;
      setState(() {});
    }
    final filename = widget.bookDetail!.filePath.substring(widget.bookDetail!.filePath.toString().lastIndexOf("/") + 1);

    if (filename.contains(".pdf")) {
      _isPDFFile = true;
    } else if (filename.contains(".epub")) {
      _isPDFFile = false;
    }
    _sampleFileExist = await checkFileIsExist(bookId: mBookDetail!.bookId.toString(), bookPath: mBookDetail!.fileSamplePath, sampleFile: true);
    _purchasedFileExist = await checkFileIsExist(bookId: mBookDetail!.bookId.toString(), bookPath: mBookDetail!.filePath, sampleFile: false);

    //_bannerAd = createBannerAd()..load();
    if (mAdShowCount < 5) {
      mAdShowCount++;
    } else {
      mAdShowCount = 0;
      if (isAdsLoading) {
        createInterstitialAd().catchError((e) {
          //
        });

      }
    }
  }

  @override
  void dispose() {
   // _bannerAd?.dispose();

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
                          ignoreGestures: true,
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

  static void downloadCallback(String id, DownloadTaskStatus status, int progress) {
    print('Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');
    final SendPort send = IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
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

  void sampleClick(context) async {
    if (await Permissions.storageGranted()) {
      if (mSampleDownloadTask!.status == DownloadTaskStatus.undefined) {
        var id = await requestDownload(context: context, downloadTask: mSampleDownloadTask!, isSample: false);
        setState(() {
          mSampleDownloadTask!.taskId = id;
          mSampleDownloadTask!.status = DownloadTaskStatus.running;
        });
        await dbHelper.insert(mSampleDownloadTask!);
      } else if (mSampleDownloadTask!.status == DownloadTaskStatus.failed) {
        var id = await retryDownload(mSampleDownloadTask!.taskId);
        setState(() {
          mSampleDownloadTask!.taskId = id;
        });
      } else if (mSampleDownloadTask!.status == DownloadTaskStatus.complete) {
        readFile(context, mSampleDownloadTask!.mDownloadTask!.filename, mSampleDownloadTask!.bookName, mSampleDownloadTask!.bookId);
      } else {
        toast(mSampleDownloadTask!.bookName! + " " + keyString(context, "lbl_is_downloading"));
      }
      setState(() {});
    }
  }

  void readBook(context) async {
    if (await Permissions.storageGranted()) {
      if (mSampleDownloadTask!.status == DownloadTaskStatus.undefined) {
        var id = await requestDownload(context: context, downloadTask: mSampleDownloadTask!, isSample: false);
        setState(() {
          mSampleDownloadTask!.taskId = id;
          mSampleDownloadTask!.status = DownloadTaskStatus.running;
        });
        await dbHelper.insert(mSampleDownloadTask!);
      } else if (mSampleDownloadTask!.status == DownloadTaskStatus.failed) {
        /*var id = await retryDownload(mSampleDownloadTask!.taskId);
        setState(() {
          mSampleDownloadTask!.taskId = id;
        });*/
        retryDownload(mSampleDownloadTask!);
      } else if (mSampleDownloadTask!.status == DownloadTaskStatus.complete) {
        readFile(context, mSampleDownloadTask!.mDownloadTask!.filename, mSampleDownloadTask!.bookName, mSampleDownloadTask!.bookId);
      } else {
        toast(mSampleDownloadTask!.bookName! + " " + keyString(context, "lbl_is_downloading"));
      }
    }
  }

  IconData getCenter() {
    if (mSampleDownloadTask!.status == DownloadTaskStatus.running) {
      return Icons.pause;
    } else if (mSampleDownloadTask!.status == DownloadTaskStatus.paused) {
      return Icons.play_arrow;
    } else if (mSampleDownloadTask!.status == DownloadTaskStatus.failed) {
      return Icons.refresh;
    }
    return Icons.refresh;
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
            itemCount: snap.data!.bookRatingData!.length <= 3 ? snap.data!.bookRatingData!.length : 3,
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
                              finish(context);
                            },
                          ),
                          AppButton(
                            child: Text(keyString(context, "lbl_ok")),
                            onTap: () {
                              finish(context);
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
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    platform = Theme.of(context).platform;

    Widget buttonWidget() {
      return Row(
        children: <Widget>[
          AppButton(
            color: Theme.of(context).cardTheme.color,
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
                    bookTitle: mBookDetail!.name,
                    onUpdate: () {
                      setState(() {
                        _sampleFileExist = true;
                      });
                    }).launch(context);
              }
            },
          ).expand(),
          16.width,
          mBookDetail!.is_purchase == 0 && mBookDetail!.price != "0"
              ? AppButton(
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
                ).expand()
              : Offstage(),
          mBookDetail!.is_purchase == 1 || mBookDetail!.price == "0"
              ? AppButton(
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
                              bookTitle: mBookDetail!.name,
                              mFileType: PURCHASED_BOOK,
                              onUpdate: () {
                                _purchasedFileExist = true;
                              },
                              bookPath: mBookDetail!.filePath)
                          .launch(context);
                    }
                  },
                ).expand()
              : Offstage()
        ],
      );
    }

    Widget body() {
      var request = {"book_id": widget.bookDetail!.bookId, "user_id": getIntAsync(USER_ID)};
      return FutureBuilder<BookDescription>(
        future: getBookDetail(request),
        builder: (_, snap) {
          if (snap.hasData) {
            mBookDetail = snap.data!.bookDetail!.first;
            mAuthorDetail = snap.data!.authorDetail!.first;
            bookRating.addAll(snap.data!.bookRatingData!);
            userReviewData = snap.data!.userReviewData;

            if (userReviewData != null) {
              userReviewData!.userName = getStringAsync(USERNAME);
            }
          }
          return Scaffold(
            appBar: appBarWidget(
              widget.bookDetail!.name.toString().validate(),
              elevation: 0,
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
                    child: Stack(
                      children: [
                        SingleChildScrollView(
                          padding: EdgeInsets.only(bottom: 60),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InkWell(
                                    child: Container(
                                      decoration: boxDecorationWithShadow(
                                        borderRadius: radiusOnly(topLeft: 8, topRight: 8, bottomLeft: 8, bottomRight: 8),
                                        spreadRadius: 2,
                                        blurRadius: 2,
                                        backgroundColor: context.cardColor,
                                        border: Border.all(color: Colors.white, width: 2.0),
                                        offset: Offset(3, 2),
                                      ),
                                      child: cachedImage(
                                        mBookDetail!.frontCover,
                                        fit: BoxFit.fill,
                                        height: 150,
                                        width: 100,
                                        radius: 0,
                                      ).cornerRadiusWithClipRRectOnly(topLeft: 8, topRight: 8, bottomLeft: 8, bottomRight: 8),
                                    ),
                                    onTap: () {
                                      if (getIntAsync(DETAIL_PAGE_VARIANT, defaultValue: 2) == 1) {
                                        BookDescriptionScreen(bookDetail: mBookDetail).launch(context);
                                      } else {
                                        BookDescriptionScreen2(bookDetail: mBookDetail).launch(context);
                                      }
                                    },
                                    radius: 8.0,
                                  ),
                                  16.width,
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        mBookDetail!.name,
                                        style: boldTextStyle(color: context.theme.textTheme.headline6!.color),
                                        maxLines: 4,
                                      ),
                                      10.height,
                                      Text("${keyString(context, 'by')} ${mBookDetail!.authorName}", style: secondaryTextStyle(color: context.theme.textTheme.subtitle2!.color)),
                                      10.height,
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 8),
                                        decoration: BoxDecoration(color: context.theme.highlightColor, borderRadius: radius(2)),
                                        child: Text(mBookDetail!.categoryName, style: primaryTextStyle(color: context.theme.textTheme.headline6!.color)),
                                      ),
                                      10.height,
                                      ratingWidget(),
                                      16.height,
                                      priceWidget(),
                                      16.height,
                                      discountWidget(),
                                    ],
                                  ).paddingTop(8).expand()
                                ],
                              ).paddingSymmetric(horizontal: 16),
                              16.height,
                              Text(keyString(context, 'introduction'), style: boldTextStyle(size: 22, color: context.theme.textTheme.headline6!.color)).paddingSymmetric(horizontal: 16),
                              ReadMoreText(mBookDetail!.description, style: primaryTextStyle(color: context.theme.textTheme.subtitle2!.color)).paddingSymmetric(horizontal: 16),
                              16.height,
                     //         (_bannerAd != null && isAdsLoading) ? Container(child: AdWidget(ad: _bannerAd!), height: _bannerAd!.size.height.toDouble()) : SizedBox(),
                              16.height,
                              reviewWidget(snap),
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
                        ),
                        Positioned(
                          bottom: 16,
                          left: 16,
                          right: 16,
                          child: buttonWidget(),
                        ),
                      ],
                    ),
                  )
                : Loader(),
          );
        },
      );
    }

    return body();
  }
}
