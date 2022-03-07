import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:granth_flutter/models/response/author.dart';
import 'package:granth_flutter/models/response/author_list.dart';
import 'package:granth_flutter/network/rest_apis.dart';
import 'package:granth_flutter/utils/widgets.dart';
import 'package:nb_utils/nb_utils.dart';

import '../app_localizations.dart';
import 'author_detail_screen.dart';

class AuthorsListScreen extends StatefulWidget {
  static String tag = '/AuthorsListScreen';
  @override
  AuthorsListScreenState createState() => AuthorsListScreenState();
}

class AuthorsListScreenState extends State<AuthorsListScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.scaffoldBackgroundColor,
        elevation: 0.0,
        centerTitle: true,
        iconTheme: context.theme.iconTheme,
        title: Text(keyString(context, "lbl_authors"), style: boldTextStyle(color: context.theme.textTheme.headline6!.color)),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: FutureBuilder<AuthorList>(
          future: getAuthorList(),
          builder: (_, snap) {
            if (snap.hasData) {
              return SingleChildScrollView(
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: snap.data!.authorList!.map((e) {
                    AuthorDetail data = snap.data!.authorList![snap.data!.authorList!.indexOf(e)];
                    return Container(
                      decoration: boxDecorationWithShadow(borderRadius: radius(8)),
                      width: context.width() / 2 - 24,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: <Widget>[
                          InkWell(
                            child: cachedImage(
                              data.image,
                              fit: BoxFit.fill,
                              height: 200,
                              width: context.width(),
                            ).cornerRadiusWithClipRRect(8),
                            onTap: () {
                              AuthorDetailScreen(authorDetail: data).launch(context);
                            },
                          ),
                          Container(
                            width: double.infinity,
                            height: 30,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                              colors: [Colors.black, Colors.transparent],
                              begin: Alignment(2.0, 1.0),
                              end: Alignment(-2.0, -1.0),
                            )),
                            child: Text(data.name, style: boldTextStyle(color: Colors.white), maxLines: 2),
                          ).cornerRadiusWithClipRRect(8)
                        ],
                      ),
                    );
                  }).toList(),
                ),
              );
            }
            return snapWidgetHelper(snap);
          },
        ),
      ),
    );
  }
}
