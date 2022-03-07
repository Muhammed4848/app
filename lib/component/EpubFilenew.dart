import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:epub_viewer/epub_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:granth_flutter/app_localizations.dart';
import 'package:granth_flutter/models/response/downloaded_book.dart';
import 'package:granth_flutter/utils/common.dart';
import 'package:granth_flutter/utils/constants.dart';
import 'package:granth_flutter/utils/database_helper.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

// ignore: must_be_immutable
class ViewEPubFileNew extends StatefulWidget {
  static String tag = '/EpubFiles';
  String? mBookId, bookName, mBookImage, bookPath, mFileType;
  final TargetPlatform platform;
  bool isPDFFile = false;
  bool isFileExist = false;
  bool? isSampleFile = false;
  Function? onUpdate;
  String bookTitle;

  ViewEPubFileNew(
      {this.mBookId,
      this.bookName,
      this.mBookImage,
      required this.platform,
      required this.isPDFFile,
      required this.isFileExist,
      this.bookPath,
      this.onUpdate,
      this.mFileType,
      this.isSampleFile,
      this.bookTitle = ""});

  @override
  ViewEPubFileNewState createState() => ViewEPubFileNewState();
}

class ViewEPubFileNewState extends State<ViewEPubFileNew> {
  _TaskInfo? _tasks;
  bool isDownloadFile = false;
  bool isDownloadFailFile = false;
  String percentageCompleted = "";
  ReceivePort _port = ReceivePort();
  String fullFilePath = "";
  int userId = 0;
  final dbHelper = DatabaseHelper.instance;
  DownloadedBook? mSampleDownloadTask;
  DownloadedBook? mBookDownloadTask;
  final Completer<PDFViewController> _controller = Completer<PDFViewController>();

  int? mTotalPage = 0;
  var pageCont = TextEditingController();
  bool mIsLoading = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    await initialDownload();
    var mCurrentPAgeData = widget.mFileType == SAMPLE_BOOK ? getIntAsync(SAMPLE_PAGE_NUMBER + widget.mBookId!) : getIntAsync(PURCHASE_PAGE_NUMBER + widget.mBookId!);
    if (mCurrentPAgeData.toString().isNotEmpty) {
      widget.mFileType == SAMPLE_BOOK ? appStore.setSamplePage(mCurrentPAgeData) : appStore.setReadBookPage(mCurrentPAgeData);
    } else {
      widget.mFileType == SAMPLE_BOOK ? appStore.setSamplePage(0) : appStore.setReadBookPage(0);
    }
  }

  Future<void> initialDownload() async {
    if (widget.isFileExist) {
      //String bookName = await getBookFileName(widget.mBookId, widget.bookPath!, isSample: widget.isSampleFile);
      String filePath = await getBookFilePathFromName(widget.bookName.toString(), isSampleFile: widget.isSampleFile);

      isDownloadFile = true;
      await _openDownloadedFile(filePath);
    } else {
      userId = getIntAsync(USER_ID);
      _bindBackgroundIsolate();
      await FlutterDownloader.registerCallback(downloadCallback);
      requestPermission();
    }
  }

  void requestPermission() async {
    if (await checkPermission(widget)) {
      _prepare();
    } else {
      if (widget.platform == TargetPlatform.android) {
        Navigator.of(context).pop();
      } else {
        _prepare();
      }
    }
  }

  @override
  void dispose() {
    _unbindBackgroundIsolate();
    //widget.onUpdate!.call();
    super.dispose();
  }

  void _bindBackgroundIsolate() async {
    bool isSuccess = IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');

    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }

    _port.listen((dynamic data) async {
      DownloadTaskStatus? status = data[1];
      int? progress = data[2];
      if (_tasks != null) {
        setState(() {
          _tasks!.status = status;
          _tasks!.progress = progress;
          percentageCompleted = _tasks!.progress!.toString();
          percentageCompleted = percentageCompleted + "% ${keyString(context, 'completed')}";
        });
        if (_tasks!.status == DownloadTaskStatus.complete) {
          FlutterDownloader.remove(taskId: _tasks!.taskId!, shouldDeleteContent: false);
          String bookName = await getBookFileName(widget.mBookId, widget.bookPath!, isSample: widget.isSampleFile);
          String filePath = await getBookFilePathFromName(bookName, isSampleFile: widget.isSampleFile);

          await insertIntoDb(bookName, filePath: filePath);
          setState(() {
            isDownloadFile = true;
            widget.onUpdate!.call();
          });
          await _openDownloadedFile(filePath);
        } else if (_tasks!.status == DownloadTaskStatus.failed) {
          finish(context);
          widget.onUpdate!.call();
        }
      }
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  static void downloadCallback(String id, DownloadTaskStatus status, int progress) {
    final SendPort send = IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBarWidget(widget.bookTitle.validate(), showBack: true),
        resizeToAvoidBottomInset: false,
        body: !isDownloadFile
            ? isDownloadFailFile
                ? new Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 18),
                          child: Text(
                            keyString(context, 'downloaded_failed'),
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  )
                : new Center(
                    child: (_tasks != null)
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 80,
                                height: 80,
                                child: CircularProgressIndicator(
                                  strokeWidth: 15,
                                  value: _tasks!.progress!.toDouble(),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: Text(
                                  percentageCompleted,
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          )
                        : SizedBox(),
                  )
            : getPdfView(),
        floatingActionButton: Container(
          decoration: boxDecorationRoundedWithShadow(50),
          padding: EdgeInsets.all(16),
          child: Text(keyString(context, 'go') + " ${widget.mFileType == SAMPLE_BOOK ? appStore.samplePageIndex : appStore.readBookPageIndex} / $mTotalPage", style: boldTextStyle()),
        ),
      ),
    );
  }

  Widget getPdfView() {
    if (widget.isPDFFile) {
      return Observer(
        builder: (_) => Container(
          height: MediaQuery.of(context).size.height,
          child: PDFView(
            filePath: fullFilePath,
            pageSnap: false,
            swipeHorizontal: false,
            onViewCreated: (PDFViewController pdfViewController) {
              _controller.complete(pdfViewController);
            },
            nightMode: false,
            onPageChanged: (int? page, int? total) async {
              widget.mFileType == SAMPLE_BOOK ? await setValue(SAMPLE_PAGE_NUMBER + widget.mBookId.toString(), page!) : await setValue(PURCHASE_PAGE_NUMBER + widget.mBookId.toString(), page!);
              setState(() {
                widget.mFileType == SAMPLE_BOOK ? appStore.setSamplePage(page.validate() + 1) : appStore.setReadBookPage(page.validate() + 1);
                mTotalPage = total;
              });
            },
            defaultPage: widget.mFileType == SAMPLE_BOOK ? appStore.samplePageIndex : appStore.readBookPageIndex,
          ),
        ),
      );
    }
    return SizedBox();
  }

  void _resumeDownload(_TaskInfo task) async {
    String? newTaskId = await FlutterDownloader.resume(taskId: task.taskId!);
    task.taskId = newTaskId;
  }

  void _retryDownload(_TaskInfo task) async {
    String? newTaskId = await FlutterDownloader.retry(taskId: task.taskId!);
    task.taskId = newTaskId;
  }

  // ignore: missing_return
  Future<void> _openDownloadedFile(String filePath) async {
    print("File Path: $filePath");

    if (widget.isPDFFile) {
      setState(() {
        fullFilePath = filePath;
      });
    } else {
      EpubViewer.setConfig(themeColor: Theme.of(context).primaryColor, identifier: "iosBook", scrollDirection: EpubScrollDirection.VERTICAL, allowSharing: false, enableTts: true, nightMode: false);

      var epubLocator = EpubLocator();
      String locatorPref = getStringAsync('locator');

      try {
        if (locatorPref.isNotEmpty) {
          Map<String, dynamic> r = jsonDecode(locatorPref);

          epubLocator = EpubLocator.fromJson(r);
        }
      } on Exception {
        epubLocator = EpubLocator();
        await removeKey('locator');
      }
      EpubViewer.open(Platform.isAndroid ? filePath : filePath, lastLocation: epubLocator);

     /* EpubViewer.locatorStream.listen((locator) async {
        await setValue('locator', locator);
      });*/
      Navigator.of(context).pop();
    }
  }

  Future<String> getTaskId(id) async {
    int userId = getIntAsync(USER_ID, defaultValue: 0);
    return userId.toString() + "_" + id;
  }

  Future<Null> _prepare() async {
    final tasks = await FlutterDownloader.loadTasks();
    _tasks = _TaskInfo(name: widget.bookName, link: widget.bookPath, taskId: await getTaskId(widget.mBookId));
    tasks?.forEach((task) {
      if (_tasks!.link == task.url) {
        _tasks!.taskId = task.taskId;
        _tasks!.status = task.status;
        _tasks!.progress = task.progress;
      }
    });
    var fileName = await getBookFileName(widget.mBookId, _tasks!.link!, isSample: widget.isSampleFile);
    String filePath = await getBookFilePathFromName(fileName, isSampleFile: widget.isSampleFile);

    String path = await localPath;
    final savedDir = Directory(path);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }

    if (_tasks!.status == DownloadTaskStatus.complete) {
      FlutterDownloader.remove(taskId: _tasks!.taskId!, shouldDeleteContent: false);
      await insertIntoDb(fileName);
      setState(() {
        isDownloadFile = true;
      });
      await _openDownloadedFile(filePath);
    } else if (_tasks!.status == DownloadTaskStatus.paused) {
      _resumeDownload(_tasks!);
    } else if (_tasks!.status == DownloadTaskStatus.undefined) {
      _tasks!.taskId = await FlutterDownloader.enqueue(url: _tasks!.link!, fileName: fileName, savedDir: path, showNotification: false, openFileFromNotification: false);
    } else if (_tasks!.status == DownloadTaskStatus.failed) {
      _retryDownload(_tasks!);
    }
  }

  Future<void> insertIntoDb(String bookName, {String? filePath}) async {
    /**
     * Store data to db for offline usage
     */
    DownloadedBook _download = DownloadedBook();
    _download.bookId = widget.mBookId;
    _download.bookName = bookName;
    _download.frontCover = widget.mBookImage;
    _download.taskId = _tasks!.taskId;
    _download.filePath = filePath;
    _download.webBookPath = widget.bookPath;

    if (widget.mFileType == SAMPLE_BOOK) {
      _download.fileType = SAMPLE_BOOK;
    } else {
      _download.fileType = PURCHASED_BOOK;
    }
    await dbHelper.insert(_download);
  }
}

class _TaskInfo {
  final String? name;
  final String? link;
  String? taskId;

  int? progress = 0;
  DownloadTaskStatus? status = DownloadTaskStatus.undefined;

  _TaskInfo({this.name, this.link, this.taskId});
}
