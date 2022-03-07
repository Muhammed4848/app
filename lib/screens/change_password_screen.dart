import 'package:flutter/material.dart';
import 'package:granth_flutter/models/response/base_response.dart';
import 'package:granth_flutter/network/rest_apis.dart';
import 'package:granth_flutter/utils/common.dart';
import 'package:granth_flutter/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';

import '../app_localizations.dart';

class ChangePasswordScreen extends StatefulWidget {
  static String tag = '/ChangePasswordScreen';

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  var formKey = GlobalKey<FormState>();

  bool isLoading = false;

  FocusNode oldPassFocus = FocusNode();
  FocusNode newPassFocus = FocusNode();
  FocusNode confirmPassFocus = FocusNode();

  var oldPassCont = TextEditingController();
  var newPassCont = TextEditingController();
  var confNewPassCont = TextEditingController();

  var confPassFocus = FocusNode();

  showLoading(bool show) {
    setState(() {
      isLoading = show;
    });
  }

  changePassword(context) async {
    var email = getStringAsync(USER_EMAIL);
    var request = {'email': email, 'old_password': oldPassCont.text, 'new_password': newPassCont.text};
    isNetworkAvailable().then((bool) {
      if (bool) {
        showLoading(true);
        changeUserPassword(request).then((result) {
          BaseResponse response = BaseResponse.fromJson(result);
          toast(response.message.toString());
          showLoading(false);
          if (response.status) {
            finish(context);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.scaffoldBackgroundColor,
        elevation: 0.0,
        centerTitle: true,
        iconTheme: context.theme.iconTheme,
        title: Text(keyString(context, "lbl_change_password"), style: boldTextStyle(color: context.theme.textTheme.headline6!.color)),
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Form(
                  key: formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      AppTextField(
                        textStyle: primaryTextStyle(color: context.theme.textTheme.headline6!.color, size: 14),
                        controller: oldPassCont,
                        cursorColor: context.theme.textTheme.headline6!.color,
                        textFieldType: TextFieldType.PASSWORD,
                        decoration: inputDecoration(context, label: keyString(context, 'label_enter_old_password')),
                        nextFocus: newPassFocus,
                      ),
                      16.height,
                      AppTextField(
                        textStyle: primaryTextStyle(color: context.theme.textTheme.headline6!.color, size: 14),
                        controller: newPassCont,
                        cursorColor: context.theme.textTheme.headline6!.color,
                        textFieldType: TextFieldType.PASSWORD,
                        decoration: inputDecoration(context, label: keyString(context, 'hint_enter_your_new_password')),
                        focus: newPassFocus,
                        nextFocus: confPassFocus,
                      ),
                      16.height,
                      AppTextField(
                        textStyle: primaryTextStyle(color: context.theme.textTheme.headline6!.color, size: 14),
                        controller: confNewPassCont,
                        cursorColor: context.theme.textTheme.headline6!.color,
                        textFieldType: TextFieldType.PASSWORD,
                        decoration: inputDecoration(context, label: keyString(context, 'hint_confirm_your_new_password')),
                        focus: confPassFocus,
                        validator: (String? value) {
                          if (value!.isEmpty) return errorThisFieldRequired;
                          if (value.length < passwordLengthGlobal) return keyString(context, 'error_password_not_match');
                          if (value.trim() != newPassCont.text.trim()) return keyString(context, 'error_confirm_password_required');
                          return null;
                        },
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (s) {
                          // submit();
                        },
                      ),
                    ],
                  ),
                ),
                30.height,
                AppButton(
                  color: context.primaryColor,
                  width: context.width(),
                  textStyle: boldTextStyle(color: Colors.white),
                  text: keyString(context, "lbl_change_password"),
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      changePassword(context);
                    }
                  },
                ),
              ],
            ),
          ),
          Center(child: Loader().visible(isLoading))
        ],
      ),
    );
  }
}
