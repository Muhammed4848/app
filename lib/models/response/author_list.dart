import 'package:granth_flutter/models/response/author.dart';

class AuthorList {
  List<AuthorDetail>? authorList;

  AuthorList({this.authorList});

  factory AuthorList.fromJson(Map<String, dynamic> json) {
    return AuthorList(
      authorList: json['data'] != null ? (json['data'] as List).map((i) => AuthorDetail.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.authorList != null) {
      data['data'] = this.authorList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
