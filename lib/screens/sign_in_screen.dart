import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:granth_flutter/models/response/login_response.dart';
import 'package:granth_flutter/network/rest_apis.dart';
import 'package:granth_flutter/screens/forgot_password_screen.dart';
import 'package:granth_flutter/screens/home_screen.dart';
import 'package:granth_flutter/screens/sign_up_screen.dart';
import 'package:granth_flutter/utils/common.dart';
import 'package:granth_flutter/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:platform_device_id/platform_device_id.dart';

import '../app_localizations.dart';

class SignInScreen extends StatefulWidget {
  static var tag = "/T2SignIn";

  @override
  SignInScreenState createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FocusNode passFocus = FocusNode();
  FocusNode emailFocus = FocusNode();

  bool? isRemember = false;
  bool isLoading = false;

  String? email;
  String? password;
  String playerId = '';
  String? deviceId;

  @override
  void initState() {
    super.initState();
    fetchData();
    getDeviceID();
    if (getStringAsync(PLAYER_ID).isEmpty) saveOneSignalPlayerId();
    500.milliseconds.delay.then((value) => setStatusBarColor(context.scaffoldBackgroundColor));
  }

  void getDeviceID() async {
    deviceId = await PlatformDeviceId.getDeviceId;
  }

  fetchData() async {
    var remember = getBoolAsync(REMEMBER_PASSWORD, defaultValue: false);
    if (remember) {
      var password = getStringAsync(PASSWORD);
      var email = getStringAsync(EMAIL);
      emailController.text = email;
      passwordController.text = password;
    }
    isRemember = remember;

    setState(() {});
  }

  showLoading(bool show) {
    setState(() {
      isLoading = show;
    });
  }

  void login(BuildContext context) async {
    var request = {
      'device_id': deviceId,
      'email': emailController.text,
      'login_from': platformName().toLowerCase(),
      'password': passwordController.text,
      'registration_id': getStringAsync(PLAYER_ID),
    };

    await isNetworkAvailable().then((bool) async {
      if (bool) {
        showLoading(true);
        await doLogin(request).then((result) async {
          print(result);
          showLoading(false);
          LoginResponse loginResponse = LoginResponse.fromJson(result);
          if (loginResponse.status!) {
            LoginData data = loginResponse.data!;
            await setValue(IS_LOGGED_IN, true);
            await setValue(TOKEN, data.apiToken);
            await setValue(USERNAME, data.userName.validate());
            await setValue(NAME, data.name);
            await setValue(USER_EMAIL, data.email);
            await setValue(USER_PROFILE, data.image.validate());
            await setValue(USER_CONTACT_NO, data.contactNumber.validate());
            await setValue(USER_ID, data.id);
            await setValue(REMEMBER_PASSWORD, isRemember);
            if (isRemember!) {
              await setValue(EMAIL, email);
              await setValue(PASSWORD, password);
            } else {
              await setValue(PASSWORD, "");
              await setValue(EMAIL, '');
            }
            HomeScreen().launch(context);
          } else {
            toast(loginResponse.message.toString());
          }
        }).catchError((error) {
          print(error);
          toast(error.toString());
          showLoading(false);
        });
      } else {
        toast(keyString(context, "error_network_no_internet"));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: context.scaffoldBackgroundColor,
        body: Stack(
          children: <Widget>[
            Positioned(
              top: 8,
              left: 8,
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      keyString(context, "lbl_sign_in"),
                      style: boldTextStyle(size: 28, color: context.theme.textTheme.headline6!.color),
                    ),
                    16.height,
                    AppTextField(
                      textStyle: primaryTextStyle(color: context.theme.textTheme.headline6!.color, size: 14),
                      textFieldType: TextFieldType.EMAIL,
                      decoration: inputDecoration(context, label: keyString(context, "hint_email")),
                      focus: emailFocus,
                      nextFocus: passFocus,
                      maxLines: 1,
                      cursorColor: Theme.of(context).primaryColor,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (String value) {
                        email = value;
                      },
                      controller: emailController,
                    ),
                    16.height,
                    AppTextField(
                      textStyle: primaryTextStyle(color: context.theme.textTheme.headline6!.color, size: 14),
                      controller: passwordController,
                      textFieldType: TextFieldType.PASSWORD,
                      decoration: inputDecoration(context, label: keyString(context, "hint_password")),
                      focus: passFocus,
                      maxLines: 1,
                      cursorColor: Theme.of(context).primaryColor,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (String value) {
                        password = value;
                      },
                    ),
                    16.height,
                    Row(
                      children: <Widget>[
                        Theme(
                          data: ThemeData(unselectedWidgetColor: context.theme.textTheme.headline6!.color),
                          child: Checkbox(
                            focusColor: Theme.of(context).primaryColor,
                            activeColor: Theme.of(context).primaryColor,
                            value: isRemember,
                            onChanged: (bool? value) {
                              setState(() {
                                isRemember = value;
                              });
                            },
                          ),
                        ),
                        Text(
                          keyString(context, "hint_remember_me"),
                          style: TextStyle(fontFamily: font_regular, fontSize: 16, color: context.theme.textTheme.headline6!.color),
                        )
                      ],
                    ),
                    50.height,
                    AppButton(
                      color: context.primaryColor,
                      width: context.width(),
                      textStyle: primaryTextStyle(size: 18, color: Colors.white),
                      text: keyString(context, "lbl_sign_in"),
                      onTap: () {
                        if (isLoading) {
                          return;
                        }
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          email = emailController.text;
                          password = passwordController.text;
                          login(context);
                        }
                      },
                    ),
                    16.height,
                    GestureDetector(
                      child: Center(child: Text(keyString(context, "lbl_dont_have_account"), style: primaryTextStyle(color: context.theme.textTheme.headline6!.color, size: 18))),
                      onTap: () {
                        SignUpScreen().launch(context);
                      },
                    ),
                    16.height,
                    GestureDetector(
                      child: Center(child: Text(keyString(context, "lbl_forgot_password"), style: primaryTextStyle(color: context.primaryColor, size: 18))),
                      onTap: () {
                        ForgotPassword().launch(context);
                      },
                    ),
                  ],
                ),
              ),
            ).center(),
            Center(child: Loader().visible(isLoading))
          ],
        ),
      ),
    );
  }
}
