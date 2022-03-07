import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:granth_flutter/models/response/transaction_history.dart';
import 'package:granth_flutter/network/rest_apis.dart';
import 'package:granth_flutter/utils/constants.dart';
import 'package:granth_flutter/utils/widgets.dart';
import 'package:nb_utils/nb_utils.dart';

import '../app_localizations.dart';

class TransactionHistoryScreen extends StatefulWidget {
  static String tag = '/TransactionHistoryScreen';

  @override
  _TransactionHistoryScreenState createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  List<Transaction> list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.scaffoldBackgroundColor,
        elevation: 0.0,
        centerTitle: true,
        iconTheme: context.theme.iconTheme,
        title: Text(keyString(context, "lbl_transaction_history"), style: boldTextStyle(color: context.theme.textTheme.headline6!.color)),
        actions: <Widget>[
          cartIcon(context, getIntAsync(CART_COUNT)),
        ],
      ),
      body: Container(
        child: FutureBuilder<TransactionHistory>(
          future: transactionHistory(),
          builder: (_, snap) {
            if (snap.hasData) {
              if (list.isEmpty) {
                list.addAll(snap.data!.transcationData!.reversed);
              }
              return ListView.builder(
                  padding: EdgeInsets.all(8),
                  itemCount: list.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    Transaction data = list[index];
                    return Container(
                      decoration: boxDecorationWithShadow(borderRadius: radius(8), backgroundColor: context.cardColor),
                      margin: EdgeInsets.symmetric(vertical: 8),
                      padding: EdgeInsets.all(8),
                      child: Row(
                        children: [
                          cachedImage(list[index].front_cover, width: 80, height: 120, fit: BoxFit.fill).cornerRadiusWithClipRRect(8),
                          16.width,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(data.bookName, style: boldTextStyle(color: context.theme.textTheme.headline6!.color)),
                              8.height,
                              (data.other_transaction_detail!.TXN_PAYMENT_ID != null)
                                  ? Text("#" + data.other_transaction_detail!.TXN_PAYMENT_ID.toString(), style: primaryTextStyle())
                                  : Text("#" + data.other_transaction_detail!.TXNID.toString(), style: primaryTextStyle()),
                              8.height,
                              Text(data.other_transaction_detail!.tXNDATE.formatDateTime(), style: secondaryTextStyle()),
                              Row(
                                children: [
                                  Text(
                                    data.payment_status == 'TXN_SUCCESS' || data.payment_status == 'approved' ? "Done" : "Failed",
                                    style: boldTextStyle(color: data.payment_status == 'TXN_SUCCESS' || data.payment_status == 'approved' ? Colors.green : Theme.of(context).errorColor),
                                  ).expand(),
                                  Text(data.total_amount.toString().toCurrencyFormat()!, style: boldTextStyle(color: context.theme.textTheme.headline6!.color)),
                                ],
                              ),
                            ],
                          ).expand(),
                        ],
                      ),
                    );
                  });
            }
            return snapWidgetHelper(snap);
          },
        ),
      ),
    );
  }
}
