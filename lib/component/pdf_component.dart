import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:granth_flutter/main.dart';
import 'package:nb_utils/nb_utils.dart';

// ignore: must_be_immutable
class PDFViewComponent extends StatelessWidget {
  String pathPDF = "";
  String? title = "";
  PDFViewComponent(this.pathPDF, this.title);
  final Completer<PDFViewController> _controller = Completer<PDFViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: PDFView(
          enableSwipe: true,
          filePath: pathPDF,
          pageSnap: false,
          pageFling: true,
          autoSpacing: true,
          nightMode: appStore.isDarkMode,
          swipeHorizontal: false,
          onViewCreated: (PDFViewController pdfViewController) {
            _controller.complete(pdfViewController);
          },
          onPageChanged: (int? page, int? total) {
            log(page);
          },
        ).paddingTop(8),
      ),
    );
  }
}
