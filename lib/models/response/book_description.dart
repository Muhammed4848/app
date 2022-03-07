import 'package:granth_flutter/models/response/author.dart';
import 'package:granth_flutter/models/response/book_detail.dart';
import 'package:granth_flutter/models/response/book_rating.dart';

class BookDescription {
  List<BookDetail>? authorBookList;
  List<AuthorDetail>? authorDetail;
  List<BookDetail>? bookDetail;
  List<BookRating>? bookRatingData;
  List<BookDetail>? recommendedBook;
  BookRating? userReviewData;

  BookDescription({this.authorBookList, this.authorDetail, this.bookDetail, this.bookRatingData, this.recommendedBook, this.userReviewData});

  factory BookDescription.fromJson(Map<String, dynamic> json) {
    return BookDescription(
      authorBookList: json['author_book_list'] != null ? (json['author_book_list'] as List).map((i) => BookDetail.fromJson(i)).toList() : null,
      authorDetail: json['author_detail'] != null ? (json['author_detail'] as List).map((i) => AuthorDetail.fromJson(i)).toList() : null,
      bookDetail: json['book_detail'] != null ? (json['book_detail'] as List).map((i) => BookDetail.fromJson(i)).toList() : null,
      bookRatingData: json['book_rating_data'] != null ? (json['book_rating_data'] as List).map((i) => BookRating.fromJson(i)).toList() : null,
      recommendedBook: json['recommended_book'] != null ? (json['recommended_book'] as List).map((i) => BookDetail.fromJson(i)).toList() : null,
      userReviewData: json['user_review_data'] != null ? BookRating.fromJson(json['user_review_data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.authorBookList != null) {
      data['author_book_list'] = this.authorBookList!.map((v) => v.toJson()).toList();
    }
    if (this.authorDetail != null) {
      data['author_detail'] = this.authorDetail!.map((v) => v.toJson()).toList();
    }
    if (this.bookDetail != null) {
      data['book_detail'] = this.bookDetail!.map((v) => v.toJson()).toList();
    }
    if (this.bookRatingData != null) {
      data['book_rating_data'] = this.bookRatingData!.map((v) => v.toJson()).toList();
    }
    if (this.recommendedBook != null) {
      data['recommended_book'] = this.recommendedBook!.map((v) => v.toJson()).toList();
    }
    if (this.userReviewData != null) {
      data['user_review_data'] = this.userReviewData!.toJson();
    }
    return data;
  }
}
