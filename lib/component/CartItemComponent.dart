import 'package:flutter/material.dart';
import 'package:granth_flutter/models/response/cart_response.dart';
import 'package:granth_flutter/network/common_api_calls.dart';
import 'package:granth_flutter/utils/common.dart';
import 'package:granth_flutter/utils/resources/colors.dart';
import 'package:granth_flutter/utils/widgets.dart';
import 'package:nb_utils/nb_utils.dart';

import '../app_localizations.dart';

class CartItemComponent extends StatefulWidget {
  static String tag = '/CartItemComponent';
  final CartItem? cartItem;

  CartItemComponent({this.cartItem});

  @override
  CartItemComponentState createState() => CartItemComponentState();
}

class CartItemComponentState extends State<CartItemComponent> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
      decoration: boxDecorationWithShadow(borderRadius: radius(8), spreadRadius: 1, blurRadius: 5, backgroundColor: context.cardColor),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            cachedImage(widget.cartItem!.front_cover, height: 30, width: 100, fit: BoxFit.fill).cornerRadiusWithClipRRect(8),
            16.width,
            Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(widget.cartItem!.name, style: boldTextStyle(color: context.theme.textTheme.headline6!.color)),
                    6.height,
                    Text(widget.cartItem!.author_name, style: primaryTextStyle(color: context.theme.textTheme.headline6!.color)),
                    6.height,
                    Row(
                      children: <Widget>[
                        Text(
                          widget.cartItem!.discount != 0
                              ? discountedPrice(tryParse(widget.cartItem!.price.toString())!, tryParse(widget.cartItem!.discount.toString())!).toString().toCurrencyFormat()!
                              : widget.cartItem!.price.toString().toCurrencyFormat()!,
                          style: boldTextStyle(color: context.theme.textTheme.headline6!.color),
                        ).visible(widget.cartItem!.price != 0),
                        6.width,
                        Text(
                          widget.cartItem!.price.toString().toCurrencyFormat()!,
                          style: primaryTextStyle(decoration: TextDecoration.lineThrough, color: context.theme.textTheme.subtitle2!.color),
                        ).visible(widget.cartItem!.discount != 0),
                        6.width,
                        Text(widget.cartItem!.discount.toString() + keyString(context, "lbl_off"), style: boldTextStyle(color: Colors.red)).visible(widget.cartItem!.discount != 0),
                      ],
                    ),
                  ],
                ),
                Divider(),
                Row(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(Icons.bookmark_border, size: 20, color: colorPrimary),
                        2.width,
                        Text(keyString(context, "lbl_move_to_wishlist"), style: boldTextStyle(size: 14, color: colorPrimary)).expand(),
                      ],
                    ).onTap(() {
                      removeBookFromCart(context, widget.cartItem!, addToWishList: true);
                    }).expand(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.delete_outline, size: 20, color: Colors.red),
                        6.width,
                        Text(keyString(context, "lbl_remove"), style: primaryTextStyle(size: 14, color: Colors.red)),
                      ],
                    ).onTap(() {
                      removeBookFromCart(context, widget.cartItem!);
                    })
                  ],
                ).expand()
              ],
            ).expand()
          ],
        ),
      ),
    );
  }
}
