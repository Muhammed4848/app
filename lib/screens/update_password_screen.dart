import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:granth_flutter/models/response/base_response.dart';
import 'package:granth_flutter/network/rest_apis.dart';
import 'package:granth_flutter/screens/sign_in_screen.dart';
import 'package:granth_flutter/utils/common.dart';
import 'package:granth_flutter/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';

import '../app_localizations.dart';

// ignore: must_be_immutable
class UpdatePasswordScreen extends StatefulWidget {
  static var tag = "/UpdatePassword";
  String? email = "";
  UpdatePasswordScreen({this.email});
  @override
  UpdatePasswordScreenState createState() => UpdatePasswordScreenState();
}

class UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? newPassword;
  bool passwordVisible = true;
  TextEditingController _controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
    500.milliseconds.delay.then((value) => setStatusBarColor(context.scaffoldBackgroundColor, statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.light));
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
        var request = {"email": widget.email, "password": newPassword};
        showLoading(true);
        updatePassword(request).then((result) {
          showLoading(false);
          BaseResponse response = BaseResponse.fromJson(result);
          if (response.status) {
            SignInScreen().launch(context);
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
                      keyString(context, "lbl_change_password"),
                      style: boldTextStyle(color: context.theme.textTheme.headline6!.color),
                    ).paddingOnly(left: 20, top: 12.0, bottom: 12.0),
                    Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Form(
                            key: _formKey,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                TextFormField(
                                    controller: _controller,
                                    obscureText: passwordVisible,
                                    cursorColor: context.theme.textTheme.headline6!.color,
                                    style: TextStyle(fontSize: 16, color: context.theme.textTheme.headline6!.color, fontFamily: font_regular),
                                    validator: (value) {
                                      return validatePassword(context, value!);
                                    },
                                    onSaved: (String? value) {
                                      newPassword = value;
                                    },
                                    decoration: new InputDecoration(
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: context.theme.textTheme.headline6!.color!),
                                      ),
                                      labelText: keyString(context, "hint_enter_your_new_password"),
                                      labelStyle: TextStyle(fontSize: 16),
                                      contentPadding: new EdgeInsets.only(bottom: 2.0),
                                      suffixIcon: new GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            passwordVisible = !passwordVisible;
                                          });
                                        },
                                        child: new Icon(passwordVisible ? Icons.visibility : Icons.visibility_off),
                                      ),
                                    )),
                                SizedBox(
                                  height: 25,
                                ),
                                TextFormField(
                                    obscureText: passwordVisible,
                                    cursorColor: context.theme.textTheme.headline6!.color,
                                    style: TextStyle(fontSize: 16, color: context.theme.textTheme.headline6!.color, fontFamily: font_regular),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return keyString(context, "error_confirm_password_required");
                                      }
                                      return _controller.text == value ? null : keyString(context, "error_password_not_match");
                                    },
                                    decoration: new InputDecoration(
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: context.theme.textTheme.headline6!.color!),
                                      ),
                                      labelText: keyString(context, "hint_confirm_your_new_password"),
                                      labelStyle: TextStyle(fontSize: 16),
                                      contentPadding: EdgeInsets.only(bottom: 2.0, top: 4.0),
                                      suffixIcon: new GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            passwordVisible = !passwordVisible;
                                          });
                                        },
                                        child: new Icon(passwordVisible ? Icons.visibility : Icons.visibility_off),
                                      ),
                                    )),
                              ],
                            ),
                          ).paddingOnly(left: 20, right: 20),
                          SizedBox(
                            height: 50,
                          ),
                          AppButton(
                              text: keyString(context, "text_send_request"),
                              onTap: () {
                                if (isLoading) {
                                  return;
                                }
                                final form = _formKey.currentState!;
                                if (form.validate()) {
                                  form.save();
                                  forgotPassword(context);
                                }
                              }).paddingOnly(left: 20, right: 20),
                          SizedBox(
                            height: 16,
                          ),
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
