import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:granth_flutter/models/response/base_response.dart';
import 'package:granth_flutter/network/rest_apis.dart';
import 'package:granth_flutter/screens/verify_otp_screen.dart';
import 'package:granth_flutter/utils/common.dart';
import 'package:nb_utils/nb_utils.dart';

import '../app_localizations.dart';

class ForgotPassword extends StatefulWidget {
  static var tag = "/ForgotPassword";

  @override
  ForgotPasswordState createState() => ForgotPasswordState();
}

class ForgotPasswordState extends State<ForgotPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController emailCont = TextEditingController();

  @override
  void initState() {
    500.milliseconds.delay.then((value) => setStatusBarColor(context.scaffoldBackgroundColor, statusBarBrightness: Brightness.light));

    super.initState();
  }

  bool isLoading = false;

  showLoading(bool show) {
    setState(() {
      isLoading = show;
    });
  }

  void forgotPassword(BuildContext context) async {
    isNetworkAvailable().then((bool) {
      if (bool) {
        var request = {"email": emailCont.text};
        showLoading(true);
        sendForgotPasswordRequest(request).then((result) {
          showLoading(false);
          BaseResponse response = BaseResponse.fromJson(result);
          if (response.status) {
            VerifyOTPScreen(email: emailCont.text).launch(context);
          } else {
            toast(response.message);
          }
        }).catchError((error) {
          showLoading(false);
          toast(error.toString());
        });
      } else {
        toast(keyString(context, "error_network_no_internet"));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarWidget(keyString(context, "lbl_forget_password")),
        backgroundColor: context.scaffoldBackgroundColor,
        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  16.height,
                  Text(keyString(context, "txt_about_forgot_password"), style: secondaryTextStyle(size: 16, color: context.theme.textTheme.subtitle2!.color)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            AppTextField(
                              textStyle: primaryTextStyle(color: context.theme.textTheme.headline6!.color, size: 14),
                              controller: emailCont,
                              textFieldType: TextFieldType.EMAIL,
                              decoration: inputDecoration(context, label: keyString(context, "hint_email")),
                            ),
                          ],
                        ),
                      ),
                      50.height,
                      AppButton(
                        width: context.width(),
                        color: context.primaryColor,
                        textStyle: primaryTextStyle(color: Colors.white),
                        text: keyString(context, "text_send_request"),
                        onTap: () {
                          if (isLoading) {
                            return;
                          }
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            forgotPassword(context);
                          }
                        },
                      ),
                      16.height,
                    ],
                  ),
                ],
              ),
            ),
            Center(child: Loader().visible(isLoading))
          ],
        ));
  }
}
