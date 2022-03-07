import 'package:granth_flutter/models/response/book_detail.dart';
import 'package:granth_flutter/models/response/pagination.dart';

class BookListResponse {
  List<BookDetail>? data;
  String? maxPrice;
  Pagination? pagination;

  BookListResponse({this.data, this.maxPrice, this.pagination});

  factory BookListResponse.fromJson(Map<String, dynamic> json) {
    return BookListResponse(
      data: json['data'] != null ? (json['data'] as List).map((i) => BookDetail.fromJson(i)).toList() : null,
      maxPrice: json['max_price'],
      pagination: json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['max_price'] = this.maxPrice;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}
