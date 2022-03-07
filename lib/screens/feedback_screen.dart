import 'package:flutter/material.dart';
import 'package:granth_flutter/models/response/base_response.dart';
import 'package:granth_flutter/network/rest_apis.dart';
import 'package:granth_flutter/utils/common.dart';
import 'package:granth_flutter/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';

import '../app_localizations.dart';

class FeedbackScreen extends StatefulWidget {
  static String tag = '/FeedbackScreen';

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> with AfterLayoutMixin<FeedbackScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  bool isLoading = false;

  FocusNode nameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode messagesFocus = FocusNode();

  showLoading(bool show) {
    setState(() {
      isLoading = show;
    });
  }

  feedBack(context) async {
    if (isLoading) {
      return;
    }
    isNetworkAvailable().then((bool) {
      if (bool) {
        showLoading(true);
        Map<String, dynamic> request = {
          'email': emailController.text,
          'name': nameController.text,
          'comment': messageController.text,
        };
        addFeedback(request).then((result) {
          BaseResponse response = BaseResponse.fromJson(result);
          toast(response.message.toString());
          showLoading(false);

          if (response.status) {
            finish(context);
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
  void initState() {
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    emailController.text = getStringAsync(USER_EMAIL);
    nameController.text = getStringAsync(USERNAME);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.scaffoldBackgroundColor,
        elevation: 0.0,
        centerTitle: true,
        iconTheme: context.theme.iconTheme,
        title: Text(keyString(context, "lbl_feedback"), style: boldTextStyle(color: context.theme.textTheme.headline6!.color)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
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
                    controller: nameController,
                    textFieldType: TextFieldType.NAME,
                    focus: nameFocus,
                    nextFocus: emailFocus,
                    keyboardType: TextInputType.emailAddress,
                    decoration: inputDecoration(context, label: keyString(context, "hint_name")),
                  ),
                  AppTextField(
                    textStyle: primaryTextStyle(color: context.theme.textTheme.headline6!.color, size: 14),
                    controller: emailController,
                    focus: emailFocus,
                    nextFocus: messagesFocus,
                    textFieldType: TextFieldType.EMAIL,
                    decoration: inputDecoration(context, label: keyString(context, "hint_email")),
                  ),
                  AppTextField(
                    textStyle: primaryTextStyle(color: context.theme.textTheme.headline6!.color, size: 14),
                    controller: messageController,
                    textFieldType: TextFieldType.OTHER,
                    textInputAction: TextInputAction.done,
                    decoration: inputDecoration(context, label: keyString(context, "hint_message")),
                  ),
                ],
              ),
            ),
            30.height,
            AppButton(
                width: context.width(),
                text: keyString(context, "lbl_submit"),
                textStyle: primaryTextStyle(color: Colors.white),
                color: context.primaryColor,
                onTap: () {
                  final form = _formKey.currentState!;
                  if (form.validate()) {
                    form.save();
                    feedBack(context);
                  }
                }),
          ],
        ),
      ),
    );
  }
}
