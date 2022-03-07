import 'package:flutter/material.dart';
import 'package:granth_flutter/component/book_grid_list_widget.dart';
import 'package:granth_flutter/models/response/book_detail.dart';
import 'package:granth_flutter/models/response/book_list.dart';
import 'package:granth_flutter/models/response/category.dart';
import 'package:granth_flutter/network/rest_apis.dart';
import 'package:granth_flutter/utils/constants.dart';
import 'package:granth_flutter/utils/widgets.dart';
import 'package:nb_utils/nb_utils.dart';

import '../app_localizations.dart';

// ignore: must_be_immutable
class CategoryBooks extends StatefulWidget {
  static String tag = '/CategoryBooks';
  var type;
  var title;
  var categoryId = '';
  CategoryBooks({this.type, this.title, this.categoryId = ''});

  @override
  _CategoryBooksState createState() => _CategoryBooksState();
}

class _CategoryBooksState extends State<CategoryBooks> with AfterLayoutMixin<CategoryBooks> {
  List<Category> subCatList = [];
  ScrollController scrollController = new ScrollController();
  bool isLoadingMoreData = false;
  bool isExpanded = false;
  int cartCount = 0;
  bool isUserLogin = false;
  int selectedCategory = 0;
  bool isDataLoaded = false;

  List<BookDetail> list = [];

  int page = 1;
  int? totalBooks = 0;
  bool isList = false;
  bool isLastPage = false;
  bool isReady = false;

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
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
  void afterFirstLayout(BuildContext context) async {
    setState(() {
      isLoadingMoreData = true;
    });
    subCategoryList();
    isUserLogin = await getBool(IS_LOGGED_IN);
    if (isUserLogin) {
      cartCount = await getInt(CART_COUNT);
    }
  }

  scrollHandler() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !isLastPage) {
      page++;
      setState(() {
        isLoadingMoreData = true;
      });
      fetchBookList();
    }
  }

  Future<void> fetchBookList() async {
    getCategoryWiseBookDetail(page, subCatList[selectedCategory].categoryId, subCatList[selectedCategory].subCategoryId).then((result) {
      BookListResponse response = BookListResponse.fromJson(result);
      setState(() {
        if (page == 1) {
          list.clear();
        }
        isLoadingMoreData = false;
        totalBooks = response.pagination!.totalItems;
        isLastPage = page == response.pagination!.totalPages;
        if (response.data!.isEmpty) {
          isLastPage = true;
        }
        list.addAll(response.data!);
        isDataLoaded = true;
      });
      return response.data;
    }).catchError((error) {
      toast(error.toString());
      setState(() {
        isLoadingMoreData = false;
        isLastPage = true;
        finish(context);
      });
    });
  }

  Future subCategoryList() async {
    isNetworkAvailable().then((bool) {
      if (bool) {
        var request = {"category_id": widget.categoryId};
        subCategories(request).then((result) {
          if (result.data != null && result.data!.isNotEmpty) {
            setState(() {
              subCatList.clear();
              subCatList.add(Category(categoryId: widget.categoryId, subCategoryId: "", name: keyString(context, 'All_Books')));
              subCatList.addAll(result.data!);
              selectedCategory = 0;
              isLoadingMoreData = true;
              fetchBookList();
              scrollController.addListener(() {
                scrollHandler();
              });
            });
          } else {
            setState(() {
              isDataLoaded = true;
              isLoadingMoreData = false;
            });
          }
        }).catchError((error) {
          toast(error.toString());
          setState(() {
            isLoadingMoreData = false;
            isLastPage = true;
          });
        });
      } else {
        setState(() {
          isLoadingMoreData = false;
        });
        toast(keyString(context, "error_network_no_internet"));
        finish(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      backgroundColor: context.scaffoldBackgroundColor,
      iconTheme: context.theme.iconTheme,
      centerTitle: subCatList.isEmpty,
      actions: <Widget>[cartIcon(context, cartCount).visible(isUserLogin)],
      title: subCatList.isEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  widget.title,
                  style: boldTextStyle(color: context.theme.textTheme.headline6!.color),
                ).paddingTop(12.0),
                Text(
                  totalBooks.toString() + ' ' + keyString(context, "lbl_books"),
                  style: boldTextStyle(color: context.theme.textTheme.subtitle2!.color),
                ).paddingTop(2.0)
              ],
            )
          : Theme(
              data: ThemeData(canvasColor: Theme.of(context).cardTheme.color),
              child: DropdownButton(
                value: subCatList[selectedCategory].name,
                underline: SizedBox(),
                onChanged: (dynamic newValue) {
                  setState(() {
                    for (var i = 0; i < subCatList.length; i++) {
                      if (newValue == subCatList[i].name) {
                        if (selectedCategory != i) {
                          selectedCategory = i;
                          page = 1;
                          setState(() {
                            list.clear();
                            isLoadingMoreData = true;
                          });
                          fetchBookList();
                        }
                      }
                    }
                  });
                },
                items: subCatList.map((category) {
                  return DropdownMenuItem(
                    child: Row(
                      children: <Widget>[
                        Text(category.name != null ? category.name : "", style: boldTextStyle(color: context.theme.textTheme.headline6!.color)),
                      ],
                    ),
                    value: category.name,
                  );
                }).toList(),
              ),
            ),
    );

    return Scaffold(
      backgroundColor: context.scaffoldBackgroundColor,
      appBar: appBar,
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          SingleChildScrollView(
              controller: scrollController,
              child: list.isNotEmpty
                  ? isLoadingMoreData
                      ? Column(
                          children: <Widget>[BookGridListWidget(list, totalDivision: 2).paddingTop(12.0), Loader()],
                        )
                      : BookGridListWidget(list, totalDivision: 2).paddingTop(12.0)
                  : Center(child: Loader().paddingTop(24.0).visible(isLoadingMoreData))),
          Center(
            child: Text(keyString(context, "error_no_result"), style: primaryTextStyle(color: context.theme.textTheme.headline6!.color, size: 18)),
          ).visible(list.isEmpty && !isLoadingMoreData & isDataLoaded)
        ],
      ),
    );
  }
}
