import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:granth_flutter/component/EpubFilenew.dart';
import 'package:granth_flutter/models/response/book_detail.dart';
import 'package:granth_flutter/models/response/book_list.dart';
import 'package:granth_flutter/models/response/downloaded_book.dart';
import 'package:granth_flutter/network/rest_apis.dart';
import 'package:granth_flutter/utils/common.dart';
import 'package:granth_flutter/utils/constants.dart';
import 'package:granth_flutter/utils/database_helper.dart';
import 'package:granth_flutter/utils/permissions.dart';
import 'package:granth_flutter/utils/widgets.dart';
import 'package:nb_utils/nb_utils.dart';

import '../app_localizations.dart';

class LibraryScreen extends StatefulWidget {
  static String tag = '/LibraryScreen';

  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> with AfterLayoutMixin<LibraryScreen> {
  double? width;
  List<DownloadedBook?> purchasedList = [];
  List<DownloadedBook> sampleList = [];
  List<DownloadedBook> downloadedList = [];

  bool isLoading = false;
  ReceivePort _port = ReceivePort();
  final dbHelper = DatabaseHelper.instance;
  var isDataLoaded = false;
  late TargetPlatform platform;

  showLoading(bool show) {
    setState(() {
      isLoading = show;
    });
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    //
  }

  @override
  void dispose() {
    _unbindBackgroundIsolate();
    super.dispose();
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    _bindBackgroundIsolate(context);
    FlutterDownloader.registerCallback(downloadCallback);

    fetchData(context);
  }

  void _bindBackgroundIsolate(context) {
    bool isSuccess = IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate(context);
      return;
    }
    _port.listen((dynamic data) {
      print('UI Isolate Callback: $data');
      String? id = data[0];
      fetchData(context);
      final task = purchasedList.firstWhere((task) => task!.taskId == id);
      if (task != null) {
        if (data[1] == DownloadTaskStatus.complete) {
          fetchData(context);
        }
        setState(() {
          task.status = data[1];
        });
      }
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  static void downloadCallback(String id, DownloadTaskStatus status, int progress) {
    print('Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');
    final SendPort send = IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }

  DownloadedBook? isExists(List<DownloadedBook> tasks, BookDetail mBookDetail) {
    DownloadedBook? exist;
    tasks.forEach((task) {
      if (task.bookId == mBookDetail.bookId.toString() && task.fileType == PURCHASED_BOOK) {
        exist = task;
      }
    });
    if (exist == null) {
      exist = defaultBook(mBookDetail, PURCHASED_BOOK);
    }
    return exist;
  }

  void fetchData(context) async {
    showLoading(true);
    List<DownloadTask>? tasks = await FlutterDownloader.loadTasks();
    List<DownloadedBook>? books = await dbHelper.queryAllRows();

    if (books.isNotEmpty) {
      List<DownloadedBook>? samples = [];
      List<DownloadedBook>? downloaded = [];
      books.forEach((DownloadedBook? book) {
        if (book!.fileType == SAMPLE_BOOK) {
          samples.add(book);
        }
        if (book.fileType == PURCHASED_BOOK) {
          downloaded.add(book);
        }
      });
      setState(() {
        sampleList.clear();
        downloadedList.clear();
        sampleList.addAll(samples);
        downloadedList.addAll(downloaded);

        downloadedList.forEach((purchaseItem) async {
          String filePath = await getBookFilePathFromName(purchaseItem.bookName.toString(), isSampleFile: false);
          if (!File(filePath).existsSync()) {
            purchaseItem.isDownloaded = false;
          } else {
            purchaseItem.isDownloaded = true;
          }
        });
      });
    } else {
      setState(() {
        sampleList.clear();
        downloadedList.clear();
      });
    }

    if (getBoolAsync(IS_LOGGED_IN)) {
      purchasedBookList().then((result) async {
        BookListResponse response = BookListResponse.fromJson(result);

        await setValue(LIBRARY_DATA, jsonEncode(response));
        setLibraryData(response, books, tasks);

        showLoading(false);
        setState(() {
          isDataLoaded = true;
        });
      }).catchError((error) async {
        showLoading(false);
        toast(error.toString());
        setLibraryData(BookListResponse.fromJson(jsonDecode(getStringAsync(LIBRARY_DATA))), books, tasks);
      });
    } else {
      setState(() {
        isDataLoaded = true;
      });
      showLoading(false);
    }
  }

  @override
  void didUpdateWidget(covariant LibraryScreen oldWidget) {
    fetchData(context);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    platform = Theme.of(context).platform;

    width = MediaQuery.of(context).size.width;

    var purchased = purchasedList.isNotEmpty
        ? getList(purchasedList, context, 1, isSampleExits: false, downloadList: downloadedList)
        : Center(
            child: Text(keyString(context, "err_no_books_purchased"), style: primaryTextStyle(color: context.theme.textTheme.headline6!.color, size: 18)),
          ).visible(isDataLoaded);
    var samples = sampleList.isNotEmpty
        ? getList(sampleList, context, 0, isSampleExits: true)
        : Center(
            child: Text(keyString(context, "err_no_sample_books_downloaded"), style: primaryTextStyle(color: context.theme.textTheme.headline6!.color, size: 18)),
          ).visible(isDataLoaded);
    var downloaded = downloadedList.isNotEmpty
        ? getList(downloadedList, context, 2, isSampleExits: false)
        : Center(
            child: Text(keyString(context, "err_no_books_downloaded"), style: primaryTextStyle(color: context.theme.textTheme.headline6!.color, size: 18)),
          ).visible(isDataLoaded);

    return Container(
      color: context.scaffoldBackgroundColor,
      child: Stack(
        children: <Widget>[
          DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: getBoolAsync(IS_LOGGED_IN)
                  ? AppBar(
                      backgroundColor: context.scaffoldBackgroundColor,
                      iconTheme: context.theme.iconTheme,
                      centerTitle: true,
                      bottom: PreferredSize(
                        preferredSize: Size(double.infinity, 50),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: TabBar(
                            isScrollable: false,
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicatorColor: context.theme.textTheme.headline6!.color,
                            labelPadding: EdgeInsets.only(left: 10, right: 10),
                            tabs: [
                              Tab(child: Text(keyString(context, "lbl_samples"), style: boldTextStyle(color: context.theme.textTheme.headline6!.color))),
                              Tab(child: Text(keyString(context, "lbl_purchased"), style: boldTextStyle(color: context.theme.textTheme.headline6!.color))),
                              Tab(child: Text(keyString(context, "lbl_downloaded"), style: boldTextStyle(color: context.theme.textTheme.headline6!.color))),
                            ],
                          ),
                        ),
                      ),
                      title: Text(keyString(context, "lbl_my_library"), style: boldTextStyle(color: context.theme.textTheme.headline6!.color, size: 22)))
                  : AppBar(
                      backgroundColor: context.scaffoldBackgroundColor,
                      iconTheme: context.theme.iconTheme,
                      centerTitle: true,
                      title: Text(keyString(context, "lbl_samples"), style: boldTextStyle(color: context.theme.textTheme.headline6!.color))),
              body: getBoolAsync(IS_LOGGED_IN)
                  ? TabBarView(
                      children: [
                        samples,
                        purchased,
                        downloaded,
                      ],
                    )
                  : samples,
            ),
          ),
          Center(
            child: Loader(),
          ).visible(isLoading)
        ],
      ),
    );
  }

  Future<void> remove(DownloadedBook task, context, isSample) async {
    String filePath = await getBookFilePathFromName(task.bookName.toString(), isSampleFile: isSample);
    if (!File(filePath).existsSync()) {
      print("Path: Remove File Not Exist");
    } else {
      await dbHelper.delete(task.id);
      await File(filePath).delete();

      fetchData(context);
    }
  }

  Widget getList(List<DownloadedBook?> list, BuildContext context, int i, {bool? isSampleExits = false, List<DownloadedBook?>? downloadList}) {
    return Container(
      padding: EdgeInsets.only(top: 16, bottom: 16),
      child: SingleChildScrollView(
        child: Wrap(
          spacing: 8,
          runSpacing: 16,
          children: list.map((e) {
            DownloadedBook bookDetail = list[list.indexOf(e)]!;
            return Container(
              padding: EdgeInsets.only(left: 8),
              width: context.width() / 2 - 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  InkWell(
                    onTap: () async {
                      if (await Permissions.storageGranted()) {
                        String bookName = await getBookFileName(bookDetail.bookId, bookDetail.webBookPath.toString(), isSample: isSampleExits);
                        String path = await getBookFilePathFromName(bookName, isSampleFile: isSampleExits);
                        if (File(path).existsSync()) {
                          await ViewEPubFileNew(
                                  bookName: bookDetail.bookName,
                                  mBookId: bookDetail.bookId.toString(),
                                  mBookImage: bookDetail.frontCover,
                                  platform: platform,
                                  isPDFFile: bookDetail.bookName.isPdf,
                                  isFileExist: true,
                                  bookPath: path,
                                  isSampleFile: isSampleExits,
                                  mFileType: bookDetail.fileType,
                                  bookTitle: bookDetail.bookName.toString(),
                                  onUpdate: () {})
                              .launch(context);
                        } else {
                          print("file not exits");
                        }
                      }
                    },
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: <Widget>[
                        cachedImage(bookDetail.frontCover, fit: BoxFit.fill, height: 250, width: context.width() / 2).cornerRadiusWithClipRRect(8),
                        i == 1
                            ? (!bookDetail.isDownloaded
                                ? Container(
                                        margin: EdgeInsets.all(4.0),
                                        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black.withOpacity(0.5)),
                                        padding: EdgeInsets.all(4.0),
                                        child: Icon(Icons.file_download, size: 14, color: Colors.white))
                                    .onTap(() async {
                                    if (await isNetworkAvailable()) {
                                      if (await Permissions.storageGranted()) {
                                        await ViewEPubFileNew(
                                                bookName: await getBookFileName(bookDetail.bookId.toString(), bookDetail.webBookPath.toString(), isSample: true),
                                                mBookId: bookDetail.bookId.toString(),
                                                mBookImage: bookDetail.frontCover,
                                                platform: platform,
                                                isPDFFile: bookDetail.webBookPath.isPdf,
                                                isFileExist: isSampleExits!,
                                                bookPath: bookDetail.webBookPath,
                                                isSampleFile: false,
                                                mFileType: PURCHASED_BOOK,
                                                bookTitle: bookDetail.bookName.toString(),
                                                onUpdate: () {
                                                  //
                                                })
                                            .launch(context);
                                        fetchData(context);
                                      }
                                    } else {
                                      throw errorInternetNotAvailable;
                                    }
                                  })
                                : SizedBox())
                            : InkWell(
                                onTap: () {
                                  remove(bookDetail, context, isSampleExits);
                                },
                                child: Container(
                                  margin: EdgeInsets.all(4.0),
                                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black.withOpacity(0.2)),
                                  padding: EdgeInsets.all(4.0),
                                  child: Icon(Icons.delete, size: 14, color: Colors.red),
                                ),
                              )
                      ],
                    ),
                  ),
                  8.height,
                  Text(
                    bookDetail.bookName!,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: boldTextStyle(color: context.theme.textTheme.headline6!.color),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  void setLibraryData(BookListResponse response, List<DownloadedBook> books, List<DownloadTask>? tasks) {
    List<DownloadedBook?> purchased = [];
    if (response.data!.isNotEmpty) {
      DownloadedBook? book;

      response.data!.forEach((bookDetail) async {
        if (books.isNotEmpty) {
          book = isExists(books, bookDetail);
          if (book!.taskId != null) {
          } else {
            book = defaultBook(bookDetail, PURCHASED_BOOK);
            book!.mDownloadTask = defaultTask(bookDetail.filePath);
          }
        } else {
          book = defaultBook(bookDetail, SAMPLE_BOOK);
          book!.mDownloadTask = defaultTask(bookDetail.fileSamplePath);
        }
        purchased.add(book);
      });
      setState(() {
        purchasedList.clear();
        purchasedList.addAll(purchased);
        purchasedList.forEach((purchaseItem) async {
          String filePath = await getBookFilePathFromName(purchaseItem!.bookName.toString(), isSampleFile: false);
          if (!File(filePath).existsSync()) {
            purchaseItem.isDownloaded = false;
          } else {
            purchaseItem.isDownloaded = true;
          }
        });
      });
    }
  }
}
