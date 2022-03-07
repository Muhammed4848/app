import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:granth_flutter/component/pin_entry.dart';
import 'package:granth_flutter/models/response/base_response.dart';
import 'package:granth_flutter/network/rest_apis.dart';
import 'package:granth_flutter/screens/update_password_screen.dart';
import 'package:nb_utils/nb_utils.dart';

import '../app_localizations.dart';

// ignore: must_be_immutable
class VerifyOTPScreen extends StatefulWidget {
  static var tag = "/VerifyOTP";
  var email;
  VerifyOTPScreen({this.email});

  @override
  VerifyOTPScreenState createState() => VerifyOTPScreenState();
}

class VerifyOTPScreenState extends State<VerifyOTPScreen> {
  var otp;
  @override
  void initState() {
    500.milliseconds.delay.then((value) => setStatusBarColor(context.scaffoldBackgroundColor, statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.light));

    super.initState();
  }

  bool isLoading = false;

  showLoading(bool show) {
    setState(() {
      isLoading = show;
    });
  }

  void verifyOTP(BuildContext context) async {
    if (isLoading) {
      return;
    }
    isNetworkAvailable().then((bool) {
      if (bool) {
        var request = {"email": widget.email, "code": otp};
        showLoading(true);
        verifyToken(request).then((result) {
          showLoading(false);
          BaseResponse response = BaseResponse.fromJson(result);
          toast(response.message);
          if (response.status) {
            UpdatePasswordScreen(email: widget.email).launch(context);
          }
        }).catchError((error) {
          toast(error.toString());
          showLoading(false);
        });
      } else {
        toast(keyString(context, "error_network_no_internet"));
      }
    });
  }

  void resendOTP(BuildContext context) async {
    if (isLoading) {
      return;
    }
    var request = {
      "email": widget.email,
    };
    showLoading(true);
    resendOtp(request).then((result) {
      showLoading(false);
      BaseResponse response = BaseResponse.fromJson(result);
      toast(response.message);
    }).catchError((error) {
      toast(error.toString());
      showLoading(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: context.scaffoldBackgroundColor,
        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    /*back icon*/
                    SafeArea(
                      child: Container(
                        padding: EdgeInsets.only(left: 4.0),
                        alignment: Alignment.centerLeft,
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ),
                    Text(
                      keyString(context, "lbl_verification"),
                      style: boldTextStyle(color: context.theme.textTheme.headline6!.color),
                    ).paddingOnly(left: 20, top: 12.0, bottom: 12.0),
                    Text(keyString(context, "note_verification"), style: primaryTextStyle(color: context.theme.textTheme.headline6!.color)).paddingOnly(left: 20, right: 20, bottom: 12.0),
                    Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          PinEntryTextField(
                            onSubmit: (String pin) {
                              otp = pin;
                            },
                            fields: 4,
                            fontSize: 22,
                          ).paddingOnly(left: 20, right: 20),
                          SizedBox(
                            height: 50,
                          ),
                          AppButton(
                              text: keyString(context, "lbl_verify"),
                              onTap: () {
                                if (isLoading) {
                                  return;
                                }
                                if (otp.toString().isEmpty && otp.toString().length < 4) {
                                  toast(keyString(context, "error_otp"));
                                }
                                verifyOTP(context);
                              }).paddingOnly(left: 20, right: 20),
                          SizedBox(
                            height: 16,
                          ),
                          GestureDetector(
                            onTap: () {
                              resendOTP(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.only(top: 10, bottom: 10, right: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(keyString(context, "msg_resend_code"), style: primaryTextStyle(color: context.theme.textTheme.headline6!.color)),
                                  Text(keyString(context, "lbl_resend_code"), style: boldTextStyle(color: context.theme.textTheme.headline6!.color)).paddingLeft(4.0),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Center(child: Loader().visible(isLoading))
          ],
        ));
  }
}
