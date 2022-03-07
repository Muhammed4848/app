import 'package:granth_flutter/models/response/book_rating.dart';

class BookRatingList {
  List<BookRating>? data;

  BookRatingList({this.data});

  factory BookRatingList.fromJson(Map<String, dynamic> json) {
    return BookRatingList(
      data: json['data'] != null ? (json['data'] as List).map((i) => BookRating.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
