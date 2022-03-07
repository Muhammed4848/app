import 'package:flutter/material.dart';
import 'package:granth_flutter/component/book_widget_component.dart';
import 'package:granth_flutter/models/response/book_detail.dart';
import 'package:nb_utils/nb_utils.dart';

// ignore: must_be_immutable
class BookGridListWidget extends StatelessWidget {
  final List<BookDetail> list;
  int totalDivision;

  BookGridListWidget(this.list, {this.totalDivision = 3});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        spacing: 8,
        runSpacing: 16,
        children: list.map((e) {
          BookDetail bookDetail = list[list.indexOf(e)];
          return Container(
            padding: EdgeInsets.only(left: 8),
            width: context.width() / totalDivision - 8,
            child: BookItemWidget(bookDetail: bookDetail),
          );
        }).toList(),
      ),
    );
  }
}
