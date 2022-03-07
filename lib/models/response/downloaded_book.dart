import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:granth_flutter/models/response/book_detail.dart';

class DownloadedBook {
  int? id;
  String? taskId;
  String? bookId;
  String? bookName;
  String? frontCover;
  String? fileType;
  String? filePath;
  String? webBookPath;
  bool isDownloaded;
  /* String? filePath;
  String? userId;
  String? fileName;*/
  DownloadTask? mDownloadTask;
  DownloadTaskStatus? status = DownloadTaskStatus.undefined;

  DownloadedBook({this.id, this.taskId, this.bookId, this.bookName, this.frontCover, this.fileType, this.mDownloadTask, this.status,this.filePath,this.webBookPath,this.isDownloaded= false});

  factory DownloadedBook.fromJson(Map<String, dynamic> json) {
    return DownloadedBook(
      id: json['id'],
      taskId: json['task_id'],
      bookId: json['book_id'],
      bookName: json['book_name'],
      frontCover: json['front_cover'],
      fileType: json['file_type'],
      filePath: json['file_Path'],
      webBookPath: json['web_book_path'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['task_id'] = this.taskId;
    data['book_id'] = this.bookId;
    data['book_name'] = this.bookName;
    data['front_cover'] = this.frontCover;
    data['file_type'] = this.fileType;
    data['file_Path'] = this.filePath;
    data['web_book_path'] = this.webBookPath;
    return data;
  }
}

DownloadTask defaultTask(url) {
  return DownloadTask(status: DownloadTaskStatus.undefined, url: url, progress: 0, filename: "", savedDir: "", taskId: "", timeCreated: 0);
}

DownloadedBook defaultBook(BookDetail mBookDetail, fileType) {
  return DownloadedBook(bookId: mBookDetail.bookId.toString(), bookName: mBookDetail.name, frontCover: mBookDetail.frontCover, fileType: fileType,filePath: mBookDetail.filePath,webBookPath: mBookDetail.filePath);
}
