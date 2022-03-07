import 'package:granth_flutter/models/response/author.dart';
import 'package:granth_flutter/models/response/base_response.dart';
import 'package:granth_flutter/models/response/book_detail.dart';
import 'package:granth_flutter/models/response/category.dart';
import 'package:granth_flutter/models/response/configuration.dart';
import 'package:granth_flutter/models/response/pagination.dart';
import 'package:granth_flutter/models/response/slider.dart';

class DashboardResponse extends BaseResponse {
  List<Category>? categoryBook;
  List<Configuration>? configuration;
  int? notificationCount;
  List<BookDetail>? popularBook;
  List<BookDetail>? recommendedBook;
  List<HomeSlider>? slider;
  List<AuthorDetail>? topAuthor;
  List<BookDetail>? topSearchBook;
  List<BookDetail>? topSellBook;
  List<BookDetail>? data;
  Pagination? pagination;
  bool? isPayPalEnabled;
  bool? isPayTmEnabled;

  DashboardResponse({
    this.categoryBook,
    this.configuration,
    this.notificationCount,
    this.popularBook,
    this.recommendedBook,
    this.slider,
    this.topAuthor,
    this.topSearchBook,
    this.topSellBook,
    this.data,
    this.pagination,
    this.isPayPalEnabled,
    this.isPayTmEnabled,
  });

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {
    return DashboardResponse(
      categoryBook: json['category_book'] != null ? (json['category_book'] as List).map((i) => Category.fromJson(i)).toList() : null,
      configuration: json['configuration'] != null ? (json['configuration'] as List).map((i) => Configuration.fromJson(i)).toList() : null,
      notificationCount: json['notificationCount'],
      popularBook: json['popular_book'] != null ? (json['popular_book'] as List).map((i) => BookDetail.fromJson(i)).toList() : null,
      recommendedBook: json['recommended_book'] != null ? (json['recommended_book'] as List).map((i) => BookDetail.fromJson(i)).toList() : null,
      slider: json['slider'] != null ? (json['slider'] as List).map((i) => HomeSlider.fromJson(i)).toList() : null,
      topAuthor: json['top_author'] != null ? (json['top_author'] as List).map((i) => AuthorDetail.fromJson(i)).toList() : null,
      topSearchBook: json['top_search_book'] != null ? (json['top_search_book'] as List).map((i) => BookDetail.fromJson(i)).toList() : null,
      topSellBook: json['top_sell_book'] != null ? (json['top_sell_book'] as List).map((i) => BookDetail.fromJson(i)).toList() : null,
      data: json['data'] != null ? (json['data'] as List).map((i) => BookDetail.fromJson(i)).toList() : null,
      pagination: json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null,
      isPayPalEnabled: json['is_paypal_configuration'],
      isPayTmEnabled: json['is_paytm_configuration'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['notificationCount'] = this.notificationCount;
    data['status'] = this.status;
    if (this.categoryBook != null) {
      data['category_book'] = this.categoryBook!.map((v) => v.toJson()).toList();
    }
    if (this.configuration != null) {
      data['configuration'] = this.configuration!.map((v) => v.toJson()).toList();
    }
    if (this.popularBook != null) {
      data['popularBook'] = this.popularBook!.map((v) => v.toJson()).toList();
    }
    if (this.recommendedBook != null) {
      data['recommendedBook'] = this.recommendedBook!.map((v) => v.toJson()).toList();
    }
    if (this.slider != null) {
      data['slider'] = this.slider!.map((v) => v.toJson()).toList();
    }
    if (this.topAuthor != null) {
      data['topAuthor'] = this.topAuthor!.map((v) => v.toJson()).toList();
    }
    if (this.topSearchBook != null) {
      data['topSearchBook'] = this.topSearchBook!.map((v) => v.toJson()).toList();
    }
    if (this.topSellBook != null) {
      data['topSellBook'] = this.topSellBook!.map((v) => v.toJson()).toList();
    }
    if (this.data != null) {
      data['topSellBook'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
