import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:granth_flutter/models/response/register_response.dart';
import 'package:granth_flutter/network/rest_apis.dart';
import 'package:granth_flutter/utils/common.dart';
import 'package:nb_utils/nb_utils.dart';

import '../app_localizations.dart';

class SignUpScreen extends StatefulWidget {
  static var tag = "/SignUp";

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameCont = new TextEditingController();
  TextEditingController userNameCont = new TextEditingController();
  TextEditingController emailCont = new TextEditingController();
  TextEditingController mobileNumberCont = new TextEditingController();
  TextEditingController confirmPasswordCont = new TextEditingController();
  TextEditingController passCont = new TextEditingController();
  bool isLoading = false;
  FocusNode passFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode nameFocus = FocusNode();
  FocusNode userNameFocus = FocusNode();
  FocusNode confirmPassFocus = FocusNode();
  FocusNode contactFocus = FocusNode();

  @override
  void initState() {
    500.milliseconds.delay.then((value) => setStatusBarColor(context.scaffoldBackgroundColor, statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.light));

    super.initState();
  }

  showLoading(bool show) {
    setState(() {
      isLoading = show;
    });
  }

  void signUp(BuildContext context) async {
    var request = {
      'email': emailCont.text.trim(),
      'name': nameCont.text.trim(),
      'password': passCont.text,
      'username': userNameCont.text,
    };

    isNetworkAvailable().then((bool) {
      if (bool) {
        showLoading(true);
        register(request).then((result) {
          showLoading(false);
          RegisterResponse baseResponse = RegisterResponse.fromJson(result);
          if (baseResponse.status!) {
            finish(context);
            toast(baseResponse.message);
          } else {
            toast(baseResponse.message);
          }
        }).catchError((error) {
          toast(keyString(context, 'error_something_wrong'));
          showLoading(false);
        });
      } else {
        toast(keyString(context, "error_network_no_internet"));
        showLoading(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var form = Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AppTextField(
            textStyle: primaryTextStyle(color: context.theme.textTheme.headline6!.color, size: 14),
            controller: nameCont,
            textFieldType: TextFieldType.NAME,
            decoration: inputDecoration(context, label: keyString(context, "hint_name")),
          ),
          8.height,
          AppTextField(
            textStyle: primaryTextStyle(color: context.theme.textTheme.headline6!.color, size: 14),
            controller: userNameCont,
            textFieldType: TextFieldType.NAME,
            decoration: inputDecoration(context, label: keyString(context, "hint_username")),
          ),
          8.height,
          AppTextField(
            textStyle: primaryTextStyle(color: context.theme.textTheme.headline6!.color, size: 14),
            controller: emailCont,
            textFieldType: TextFieldType.EMAIL,
            decoration: inputDecoration(context, label: keyString(context, "hint_email")),
          ),
          8.height,
          AppTextField(
            textStyle: primaryTextStyle(color: context.theme.textTheme.headline6!.color, size: 14),
            controller: mobileNumberCont,
            textFieldType: TextFieldType.PHONE,
            decoration: inputDecoration(context, label: keyString(context, "hint_contact_no")),
          ),
          8.height,
          AppTextField(
            textStyle: primaryTextStyle(color: context.theme.textTheme.headline6!.color, size: 14),
            controller: passCont,
            textFieldType: TextFieldType.PASSWORD,
            decoration: inputDecoration(context, label: keyString(context, "hint_password")),
          ),
          8.height,
          AppTextField(
            textStyle: primaryTextStyle(color: context.theme.textTheme.headline6!.color, size: 14),
            controller: confirmPasswordCont,
            textFieldType: TextFieldType.PASSWORD,
            decoration: inputDecoration(context, label: keyString(context, "hint_confirm_password")),
            validator: (value) {
              if (value!.isEmpty) {
                return keyString(context, "error_confirm_password_required");
              }
              return passCont.text == value ? null : keyString(context, "error_password_not_match");
            },
          ),
        ],
      ),
    ).paddingOnly(left: 20, right: 20);
    return Scaffold(
        backgroundColor: context.scaffoldBackgroundColor,
        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Container(
                child: Column(
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
                      keyString(context, "lbl_sign_up"),
                      style: boldTextStyle(color: context.theme.textTheme.headline6!.color),
                    ).paddingOnly(left: 20, top: 12.0, bottom: 12.0),
                    Padding(
                      padding: EdgeInsets.only(top: 4.0, bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          form,
                          SizedBox(
                            height: 50,
                          ),
                          AppButton(
                              text: keyString(context, "lbl_sign_up"),
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  signUp(context);
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
