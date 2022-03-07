//import 'package:granth_flutter/utils/downloader/downloader_models.dart';

import 'package:granth_flutter/models/response/downloaded_book.dart';

class BookDetail {
  var authorName;
  var backCover;
  int? bookId;
  var categoryName;
  var dateOfPublication;
  var description;
  var discount;
  var discountedPrice;
  var edition;
  var filePath;
  var fileSamplePath;
  var format;
  var frontCover;
  int? isWishList;
  var keywords;
  var language;
  var name;
  var price;
  var publisher;
  var subcategoryName;
  var title;
  var topicCover;
  var totalReview;
  var totalRating;
  var is_purchase;
  DownloadedBook? downloadTask;

  BookDetail(
      {this.authorName,
      this.backCover,
      this.bookId,
      this.categoryName,
      this.dateOfPublication,
      this.description,
      this.discount,
      this.discountedPrice,
      this.edition,
      this.filePath,
      this.fileSamplePath,
      this.format,
      this.frontCover,
      this.isWishList,
      this.keywords,
      this.language,
      this.name,
      this.price,
      this.publisher,
      this.subcategoryName,
      this.title,
      this.topicCover,
      this.totalReview,
      this.totalRating,
      this.is_purchase});

  factory BookDetail.fromJson(Map<String, dynamic> json) {
    return BookDetail(
        authorName: json['author_name'],
        backCover: json['back_cover'] != null ? json['back_cover'] : null,
        bookId: json['book_id'],
        categoryName: json['category_name'],
        dateOfPublication: json['date_of_publication'],
        description: json['description'],
        discount: json['discount'],
        discountedPrice: json['discounted_price'],
        edition: json['edition'] != null ? json['edition'] : null,
        filePath: json['file_path'],
        fileSamplePath: json['file_sample_path'],
        format: json['format'],
        frontCover: json['front_cover'],
        isWishList: json['is_wishlist'],
        keywords: json['keywords'],
        language: json['language'],
        name: json['name'],
        price: json['price'],
        publisher: json['publisher'],
        subcategoryName: json['subcategory_name'],
        title: json['title'],
        topicCover: json['topic_cover'] != null ? json['topic_cover'] : null,
        totalReview: json['total_review'],
        totalRating: json['total_rating'] != null ? json['total_rating'] : 0.0,
        is_purchase: json['is_purchase'] != null ? json['is_purchase'] : 0);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['author_name'] = this.authorName;
    data['book_id'] = this.bookId;
    data['category_name'] = this.categoryName;
    data['date_of_publication'] = this.dateOfPublication;
    data['description'] = this.description;
    data['discount'] = this.discount;
    data['discounted_price'] = this.discountedPrice;
    data['file_path'] = this.filePath;
    data['file_sample_path'] = this.fileSamplePath;
    data['format'] = this.format;
    //˛data['front_cover'] = this.frontCover;
    data['keywords'] = this.keywords;
    data['language'] = this.language;
    data['name'] = this.name;
    data['price'] = this.price;
    data['publisher'] = this.publisher;
    data['subcategory_name'] = this.subcategoryName;
    data['title'] = this.title;
    if (this.frontCover != null) {
      data['front_cover'] = this.frontCover;
    }
    if (this.backCover != null) {
      data['back_cover'] = this.backCover;
    }
    if (this.edition != null) {
      data['edition'] = this.edition;
    }
    data['is_wishlist'] = this.isWishList;

    if (this.topicCover != null) {
      data['topic_cover'] = this.topicCover;
    }
    return data;
  }
}
