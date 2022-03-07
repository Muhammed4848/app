import 'dart:convert';
import 'dart:io';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutterwave_standard/core/TransactionCallBack.dart';
import 'package:flutterwave_standard/core/navigation_controller.dart';
import 'package:flutterwave_standard/models/requests/customer.dart';
import 'package:flutterwave_standard/models/requests/customizations.dart';
import 'package:flutterwave_standard/models/requests/standard_request.dart';
import 'package:flutterwave_standard/models/responses/charge_response.dart';
import 'package:flutterwave_standard/view/flutterwave_style.dart';
import 'package:flutterwave_standard/view/view_utils.dart';
import 'package:granth_flutter/app_localizations.dart';
import 'package:granth_flutter/component/CartItemComponent.dart';
import 'package:granth_flutter/models/request/order_detail.dart';
import 'package:granth_flutter/models/response/cart_response.dart';
import 'package:granth_flutter/models/response/checksum_response.dart';
import 'package:granth_flutter/models/response/wishlist_response.dart';
import 'package:granth_flutter/network/rest_apis.dart';
import 'package:granth_flutter/screens/wishlist_screens.dart';
import 'package:granth_flutter/utils/common.dart';
import 'package:granth_flutter/utils/constants.dart';
import 'package:granth_flutter/utils/payment/cart_payment.dart';
import 'package:granth_flutter/utils/resources/images.dart';
import 'package:granth_flutter/utils/widgets.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class CartScreen extends StatefulWidget {
  static String tag = '/CartScreen';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with AfterLayoutMixin<CartScreen>, TransactionCallBack {
  late Razorpay razorPay;
  final plugin = PaystackPlugin();
  final formKey = GlobalKey<FormState>();
  CheckoutMethod method = CheckoutMethod.card;
  late NavigationController controller;
  bool testing = true;
  late String paymentResponse = "";

  String? cardNumber;
  String? cvv;
  int? expiryMonth;
  int? expiryYear;

  List<CartItem> list = [];
  List<WishListItem> wishList = [];
  double? width;
  var mIsFirstTime = true;
  var totalMrp = 0.0;
  var total = 0.0;
  var discount = 0.0;
  var paymentMethod = "";
  var userId;
  var userEmail;
  var phoneNo;
  var wishListCount = 0;
  var platform;
  bool isDisabled = false;
  bool isPayPalEnabled = false;
  bool isPayTmEnabled = false;
  var authorization;

  @override
  void initState() {
    super.initState();
    plugin.initialize(publicKey: payStackPublicKey);

    init();
  }

  Future<void> init() async {
    razorPay = Razorpay();
    razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, razorPayHandlePaymentSuccess);
    razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, razorPayHandlePaymentError);
    razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, razorPayHandleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    razorPay.clear();
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    if (mIsFirstTime) {
      platform = Theme.of(context).platform;
      isPayPalEnabled = getBoolAsync(IS_PAYPAL_ENABLED);
      isPayTmEnabled = getBoolAsync(IS_PAYTM_ENABLED);

      LiveStream().on(CART_DATA_CHANGED, (value) {
        if (mounted) {
          showLoading(false);
          setCartItem(value as List<CartItem>?);
        }
      });
      LiveStream().on(WISH_LIST_DATA_CHANGED, (value) {
        if (mounted) {
          showLoading(false);
          setWishListItem(value as List<WishListItem>?);
        }
      });

      setCartItem(CartResponse.fromJson(jsonDecode(getStringAsync(CART_DATA))).data);
      var wishListItemList = await wishListItems();
      setWishListItem(wishListItemList);
      userId = getIntAsync(USER_ID);
      userEmail = getStringAsync(USER_EMAIL, defaultValue: "");
      phoneNo = getStringAsync(USER_CONTACT_NO, defaultValue: "");
    }
  }

  void setCartItem(List<CartItem>? cartItems) {
    setState(() {
      list.clear();
      list.addAll(cartItems!);
      var mrp = 0.0;
      var discounts = 0.0;
      list.forEach((cartItem) {
        mrp += tryParse(cartItem.price.toString()) ?? 0;
        discounts += getPercentageRate(tryParse(cartItem.price.toString())!, tryParse(cartItem.discount.toString())!);
      });
      totalMrp = mrp;
      discount = discounts;
      total = mrp - discounts;
    });
  }

  void setWishListItem(List<WishListItem>? cartItems) {
    setState(() {
      wishList.clear();
      wishList.addAll(cartItems!);
      wishListCount = cartItems.length;
    });
  }

  bool isLoading = false;

  showLoading(bool show) {
    setState(() {
      isLoading = show;
    });
  }

  OrderDetail getOrderDetail({int? paymentType}) {
    var orderDetail = OrderDetail();
    List<BookData> otherOrder = [];
    list.forEach((cartItem) {
      orderDetail.book_id = cartItem.book_id;
      orderDetail.price = cartItem.price;
      orderDetail.discount = cartItem.price;
      orderDetail.quantity = cartItem.addedQty;
      orderDetail.cash_on_delivery = cartItem.cash_on_delivery;
      BookData otherOrderData = BookData();
      otherOrderData.book_id = cartItem.book_id;
      otherOrderData.discount = cartItem.discount;
      otherOrderData.price = cartItem.price;
      otherOrder.add(otherOrderData);
    });
    orderDetail.other_detail = OtherDetail(data: otherOrder);
    orderDetail.gstnumber = "";
    orderDetail.is_hard_copy = "1";
    orderDetail.shipping_cost = "";
    orderDetail.total_amount = total.toString();
    orderDetail.user_id = userId;
    orderDetail.discount = discount;
    orderDetail.payment_type = 1;
    orderDetail.gstnumber = "";
    orderDetail.is_hard_copy = "1";
    orderDetail.payment_type = paymentType;
    return orderDetail;
  }

  checkSumApi({double? total}) {
    var request = {
      "TXN_AMOUNT": total.toString(),
      "EMAIL": 'test@gmail.com',
      "MOBILE_NO": '000000000',
    };

    isNetworkAvailable().then((bool) {
      if (bool) {
        getChecksum(request).then((result) async {
          CheckSumResponse checksum = CheckSumResponse.fromJson(result);
          String cusId = checksum.data!.order_data!.cUST_ID.toString();
          await paytmPayment(paymentMethod: PAYTM, total: total, orderId: checksum.data!.order_data!.oRDER_ID.toString(), cusId: cusId);
        }).catchError((error) {
          toast(error.toString());
        });
      } else {}
    });
  }

  ///Razor Payment
  void razorPayPayment() async {
    String username = razorKey;
    String password = razorPayKeySecret;
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$username:$password'));

    print(basicAuth);

    var headers = {HttpHeaders.authorizationHeader: basicAuth, HttpHeaders.contentTypeHeader: 'application/json'};
    var request = http.Request('POST', Uri.parse(razorPayURL));
    request.body = json.encode({
      "amount": '${(total * 100).toInt()}',
      "receipt": "receipt#1",
      "currency": CartPayment.CURRENCY_CODE,
    });
    request.headers.addAll(headers);

    await request.send().then((value) {
      http.Response.fromStream(value).then((response) async {
        var req = {
          'key': razorKey,
          'amount': (total * 100).toInt(),
          'name': keyString(context, "app_name"),
          'theme.color': '#234AA1',
          'description': keyString(context, "app_name"),
          'image': 'https://razorpay.com/assets/razorpay-glyph.svg',
          'prefill': {'contact': getStringAsync(USER_CONTACT_NO, defaultValue: ""), 'email': getStringAsync(USER_EMAIL, defaultValue: "")},
          'external': {
            'wallets': ['paytm']
          }
        };
        try {
          razorPay.open(req);
        } catch (e) {
          debugPrint(e.toString());
        }
      }).catchError((e) {
        showLoading(false);
        toast(e.toString(), print: true);
      });
    }).catchError((e) {
      toast(e.toString(), print: true);
    });
  }

  void razorPayHandlePaymentSuccess(PaymentSuccessResponse response) async {
    var request = <String, String?>{
      "TXNID": response.paymentId,
      "STATUS": "TXN_SUCCESS",
      "TXN_PAYMENT_ID": response.paymentId,
      "TXN_ORDER_ID": response.orderId.toString().isEmptyOrNull ? response.paymentId.toString() : response.orderId.toString(),
      "TXN_signature": response.signature,
    };
    saveTransaction(request, getOrderDetail(paymentType: RAZOR_PAY_STATUS), RAZOR_PAY, 'TXN_SUCCESS');
  }

  void razorPayHandlePaymentError(PaymentFailureResponse response) {
    snackBar(context, title: response.message.toString());
    log("Failure:+$response");
  }

  void razorPayHandleExternalWallet(ExternalWalletResponse response) {
    snackBar(context, title: "EXTERNAL_WALLET: " + response.walletName!);
  }

  ///PayStack Payment
  void payStackCheckOut(BuildContext context) async {
    formKey.currentState?.save();
    Charge charge = Charge()
      ..amount = (total * 100).toInt() // In base currency
      ..email = getStringAsync(USER_EMAIL)
      ..currency = payStackCurrencyCode
      ..card = PaymentCard(number: cardNumber, cvc: cvv, expiryMonth: expiryMonth, expiryYear: expiryYear);

    charge.reference = _getReference();

    try {
      CheckoutResponse response = await plugin.checkout(context, method: method, charge: charge, fullscreen: false);
      payStackUpdateStatus(response.reference, response.message);
      if (response.message == "Success") {
        var paymentId = response.reference!.split('_').last;
        var request = <String, String?>{
          "STATUS": "TXN_SUCCESS",
          "TXNID": paymentId.toString(),
          "TXNCARDDATA": response.card.toString(),
          "TXNEXPR": response.card!.cvc,
          "TXNMETHOD": response.method.toString(),
          "TXNSTATUS": response.status.toString(),
          "TXNMESSAGE": response.message.toString(),
        };
        saveTransaction(request, getOrderDetail(paymentType: PAY_STACK_STATUS), PAY_STACK, 'TXN_SUCCESS');
      } else {
        toast("Payment failed please try again");
      }
    } catch (e) {
      payStackShowMessage("Check console for error");
      log("response error$e:----");

      rethrow;
    }
  }

  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }

    return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }

  void payStackUpdateStatus(String? reference, String message) {
    payStackShowMessage(message, const Duration(seconds: 7));
  }

  void payStackShowMessage(String message, [Duration duration = const Duration(seconds: 4)]) {
    snackBar(context, title: message);
    log(message);
  }

  ///FlutterWave Payment
  void flutterWaveCheckout() {
    if (isDisabled) return;
    _showConfirmDialog();
  }

  final style = FlutterwaveStyle(
      appBarText: "My Standard Blue",
      buttonColor: Color(0xffd0ebff),
      appBarIcon: Icon(Icons.message, color: Color(0xffd0ebff)),
      buttonTextStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
      appBarColor: Color(0xffd0ebff),
      dialogCancelTextStyle: TextStyle(color: Colors.redAccent, fontSize: 18),
      dialogContinueTextStyle: TextStyle(color: Colors.blue, fontSize: 18));

  void _showConfirmDialog() {
    FlutterwaveViewUtils.showConfirmPaymentModal(
      context,
      "USD",
      total.toString(),
      style.getMainTextStyle(),
      style.getDialogBackgroundColor(),
      style.getDialogCancelTextStyle(),
      style.getDialogContinueTextStyle(),
      _handlePayment,
    );
  }

  void _handlePayment() async {
    final Customer customer = Customer(
      name: getStringAsync(USER_DISPLAY_NAME),
      phoneNumber: getStringAsync(USER_CONTACT_NO),
      email: getStringAsync(USER_EMAIL),
    );

    final request = StandardRequest(
      txRef: DateTime.now().millisecond.toString(),
      amount: total.toString(),
      customer: customer,
      paymentOptions: "card, payattitude",
      customization: Customization(title: "Test Payment"),
      isTestMode: true,
      publicKey: flutterWavePublicKey,
      currency: CartPayment.CURRENCY_CODE,
      redirectUrl: "https://www.google.com",
    );

    try {
      Navigator.of(context).pop(); // to remove confirmation dialog
      _toggleButtonActive(false);
      controller.startTransaction(request);
      _toggleButtonActive(true);
    } catch (error) {
      _toggleButtonActive(true);
      _showErrorAndClose(error.toString());
    }
  }

  void _toggleButtonActive(final bool shouldEnable) {
    setState(() {
      isDisabled = !shouldEnable;
    });
  }

  void _showErrorAndClose(final String errorMessage) {
    FlutterwaveViewUtils.showToast(context, errorMessage);
  }

  @override
  onTransactionError() {
    _showErrorAndClose("transaction error");
    snackBar(context, title: errorMessage);
  }

  @override
  onCancelled() {
    snackBar(context, title: "Transaction Cancelled");
  }

  @override
  onTransactionSuccess(String id, String txRef) {
    final ChargeResponse chargeResponse = ChargeResponse(status: "success", success: true, transactionId: id, txRef: txRef);
    var request = <String, String?>{
      "STATUS": "TXN_SUCCESS",
      "TXNID": chargeResponse.transactionId,
      "TXNSTATUS": chargeResponse.status,
      "TXNSREFF": chargeResponse.txRef,
      "TXNSUCCESS": chargeResponse.success.toString(),
    };
    saveTransaction(request, getOrderDetail(paymentType: FLUTTER_WAVE_STATUS), FLUTTER_WAVE, 'TXN_SUCCESS');
  }

  ///paypal payment
  void paypalPayment() async {
    var request = BraintreeDropInRequest(
      tokenizationKey: paypalURL,
      collectDeviceData: true,
      googlePaymentRequest: BraintreeGooglePaymentRequest(
        totalPrice: total.toString(),
        currencyCode: CartPayment.CURRENCY_CODE,
        billingAddressRequired: false,
      ),
      paypalRequest: BraintreePayPalRequest(amount: total.toString(), currencyCode: CartPayment.CURRENCY_CODE),
      cardEnabled: true,
    );
    final result = await BraintreeDropIn.start(request);
    if (result != null) {
      var request = <String, String?>{
        "STATUS": "TXN_SUCCESS",
        "TXNID": result.paymentMethodNonce.nonce,
        "TXNTYPE_LABEL": result.paymentMethodNonce.typeLabel,
        "TXNTYPE_DECRIPTION": result.paymentMethodNonce.description,
        "TXNTYPE_IS_DEFAULT": result.paymentMethodNonce.isDefault.toString(),
      };
      saveTransaction(request, getOrderDetail(paymentType: PAYPAL_STATUS), FLUTTER_WAVE, 'TXN_SUCCESS');
    }
  }

  @override
  Widget build(BuildContext context) {
    controller = NavigationController(Client(), style, this);

    width = MediaQuery.of(context).size.width;
    placeOrder() async {
      if (!isPayTmEnabled && !isPayPalEnabled && !isPayRazorPayEnabled && !isPayStackEnabled && !isFlutterWaveEnabled) {
        toast("Payment option are not available");
        return;
      }
      if (paymentMethod.isNotEmpty) {
        //TODO
        /*if (paymentMethod == PAYTM) {
          checkSumApi(total: total);
        } else */
        if (paymentMethod == RAZOR_PAY) {
          razorPayPayment();
        } else if (paymentMethod == PAY_STACK) {
          payStackCheckOut(context);
        } else if (paymentMethod == FLUTTER_WAVE) {
          flutterWaveCheckout();
        } else if (paymentMethod == PAYPAL) {
          paypalPayment();
        }
      } else {
        toast(keyString(context, "error_select_payment_option"));
      }
    }

    final cartItems = list.isNotEmpty
        ? ListView.builder(
            itemCount: list.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return CartItemComponent(cartItem: list[index]);
            })
        : Container();

    final next = Container(
      color: Theme.of(context).cardTheme.color,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Wrap(
            children: <Widget>[
              Text(keyString(context, "lbl_total_amount"), style: primaryTextStyle(color: context.theme.textTheme.headline6!.color, size: 16)),
              Text(total.toString().toCurrencyFormat()!, style: boldTextStyle(color: context.theme.textTheme.headline6!.color, size: 18)),
            ],
          ),
          MaterialButton(
            child: Text(keyString(context, "lbl_place_order"), style: primaryTextStyle(color: Colors.white)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4.0))),
            elevation: 5.0,
            minWidth: 150,
            height: 40,
            color: Theme.of(context).primaryColor,
            onPressed: () {
              if (!isLoading) {
                placeOrder();
              }
            },
          ),
        ],
      ).paddingOnly(left: 16, right: 16, top: 8, bottom: 8),
    );

    Widget paymentOptions = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(keyString(context, "lbl_payment_method"), style: boldTextStyle(color: context.theme.textTheme.headline6!.color))
            .paddingAll(16)
            .visible(isPayPalEnabled || isPayTmEnabled || isPayRazorPayEnabled || isPayStackEnabled || isFlutterWaveEnabled),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              paymentCardWidget(
                onTap: () {
                  setState(() {
                    paymentMethod = PAYTM;
                  });
                },
                bgColor: context.cardColor,
                paymentMethod: paymentMethod,
                paymentName: PAYTM,
                icon: icon_paytm,
                title: keyString(context, "lbl_paytm"),
              ).visible(isPayTmEnabled),
              16.width,
              paymentCardWidget(
                onTap: () {
                  setState(() {
                    paymentMethod = RAZOR_PAY;
                  });
                },
                bgColor: context.cardColor,
                paymentMethod: paymentMethod,
                paymentName: RAZOR_PAY,
                title: keyString(context, "razor_payment"),
                icon: icon_razor_pay,
              ).visible(isPayRazorPayEnabled),
              16.width,
              paymentCardWidget(
                      onTap: () {
                        setState(() {
                          paymentMethod = PAY_STACK;
                        });
                      },
                      bgColor: context.cardColor,
                      paymentMethod: paymentMethod,
                      paymentName: PAY_STACK,
                      title: keyString(context, "pay_stack"),
                      icon: icon_pay_stack)
                  .visible(isPayStackEnabled),
              16.width,
              paymentCardWidget(
                onTap: () {
                  setState(() {
                    paymentMethod = FLUTTER_WAVE;
                  });
                },
                bgColor: context.cardColor,
                paymentMethod: paymentMethod,
                paymentName: FLUTTER_WAVE,
                title: keyString(context, "flutter_wave"),
                icon: icon_flutter_wave,
              ).visible(isFlutterWaveEnabled),
              16.width,
              paymentCardWidget(
                onTap: () {
                  setState(() {
                    paymentMethod = PAYPAL;
                  });
                },
                bgColor: context.cardColor,
                paymentMethod: paymentMethod,
                paymentName: PAYPAL,
                title: keyString(context, "paypal"),
                icon: icon_payPal,
              ).visible(isPayPalEnabled),
            ],
          ).paddingOnly(left: 12.0, right: 12.0, top: 8, bottom: 8),
        )
      ],
    );

    return Scaffold(
      backgroundColor: context.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(keyString(context, "lbl_cart"), style: boldTextStyle(color: context.theme.textTheme.headline6!.color)),
        centerTitle: true,
        iconTheme: context.theme.iconTheme,
        backgroundColor: context.scaffoldBackgroundColor,
        actions: <Widget>[
          Badge(
            badgeContent: Text(wishListCount.toString(), style: primaryTextStyle(color: Colors.white, size: 14)),
            badgeColor: Colors.red,
            showBadge: wishListCount > 0,
            position: BadgePosition.topEnd(end: -5),
            animationType: BadgeAnimationType.fade,
            child: SvgPicture.asset(
              icon_bookmark,
              height: 24,
              width: 24,
              color: context.theme.textTheme.headline6!.color,
            ),
          ).paddingAll(12).onTap(() {
            if (wishListCount > 0) {
              WishlistScreen().launch(context);
            } else {
              toast(keyString(context, "error_wishlist_empty"));
            }
          })
        ],
      ),
      body: Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () {
                    LiveStream().emit(CART_ITEM_CHANGED, true);
                    LiveStream().emit(WISH_DATA_ITEM_CHANGED, true);
                    return Future.value(true);
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(keyString(context, "lbl_cart_items"), style: boldTextStyle(color: context.theme.textTheme.headline6!.color)).paddingAll(16),
                        cartItems,
                        Text(keyString(context, "lbl_payment_detail"), style: boldTextStyle(color: context.theme.textTheme.headline6!.color)).paddingAll(16),
                        priceDetailsWidget(context, totalMrp: totalMrp, total: total, discount: discount).paddingOnly(left: 12.0, right: 12.0, bottom: 4.0),
                        paymentOptions,
                      ],
                    ).paddingBottom(70),
                  ),
                ),
              ).visible(list.isNotEmpty),
              Container(
                alignment: Alignment.center,
                child: Column(
                  children: <Widget>[
                    SvgPicture.asset(ic_empty, width: 180, height: 180),
                    Text(keyString(context, "error_cart_empty"), style: boldTextStyle(color: context.theme.textTheme.subtitle2!.color, size: 22)).paddingTop(12.0),
                  ],
                ),
              ).visible(list.isEmpty),
              next.visible(list.isNotEmpty)
            ],
          ),
          Center(
            child: Loader(),
          ).visible(isLoading)
        ],
      ),
    );
  }

  paytmPayment({String? paymentMethod, String? orderId, double? total, String? cusId}) async {
    showLoading(true);
    String callBackUrl = (testing ? 'https://securegw-stage.paytm.in' : 'https://securegw.paytm.in') + '/theia/paytmCallback?ORDER_ID=' + orderId.toString();

    var url = 'https://desolate-anchorage-29312.herokuapp.com/generateTxnToken';

    var body = json
        .encode({"mid": mId, "key_secret": paytmSecretKey, "website": false, "orderId": orderId, "amount": total.toString(), "callbackUrl": callBackUrl, "custId": cusId, "testing": testing ? 0 : 1});

    try {
      final response = await http.post(
        Uri.parse(url),
        body: body,
        headers: {'Content-type': "application/json"},
      );
      String txnToken = response.body;

      //TODO
      /*var paytmResponse = Paytm.payWithPaytm(
          mId: mId,
          orderId: orderId.toString(),
          txnToken: txnToken,
          txnAmount: total.toString(),
          callBackUrl: callBackUrl,
          staging: testing,
          appInvokeEnabled: false);

      paytmResponse.then((value) {
        print(value);
        setState(() {
          showLoading(false);
          if (value['error']) {
            paymentResponse = value['errorMessage'];
          } else {
            if (value['response'] != null) {
              paymentResponse = value['response']['STATUS'];
              print("paytm success${paymentResponse.toString()}");
              var request = <String, String?>{
                "TXNID": value['response']['TXNID'],
                "STATUS": value['response']['STATUS'],
                "TXN_ORDER_ID": value['response']['ORDERID'],
                "TXN_BANK_NAME": value['response']['BANKNAME:WALLET'],
              };
              saveTransaction(
                  request,
                  getOrderDetail(paymentType: PAYTM_STATUS),
                  PAYTM,
                  'TXN_SUCCESS');
            }
          }
          paymentResponse += "\n" + value.toString();
        });
      });*/
    } catch (e) {
      showLoading(false);
      print(e);
    }
  }
}
