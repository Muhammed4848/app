import 'dart:io';

import 'package:flutter/material.dart';
import 'package:granth_flutter/network/rest_apis.dart';
import 'package:granth_flutter/utils/common.dart';
import 'package:granth_flutter/utils/constants.dart';
import 'package:granth_flutter/utils/resources/images.dart';
import 'package:granth_flutter/utils/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';

import '../app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _nameController = new TextEditingController();
  TextEditingController _userNameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _contactController = new TextEditingController();

  String? contact;
  String? name;
  String? userProfile;
  String? userName;
  String? userEmail;
  int? userId;

  File? imageFile;
  bool isLoading = false;
  bool loadFromFile = false;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    setState(() {
      userId = getIntAsync(USER_ID);
      userProfile = getStringAsync(USER_PROFILE, defaultValue: '');

      _nameController.text = getStringAsync(NAME, defaultValue: '');
      _userNameController.text = getStringAsync(USERNAME, defaultValue: '');
      _emailController.text = getStringAsync(USER_EMAIL, defaultValue: '');
      _contactController.text = getStringAsync(USER_CONTACT_NO, defaultValue: '');
    });
  }

  showLoading(bool show) {
    setState(() {
      isLoading = show;
    });
  }

  Future getImage(ImageSource source) async {
    var image = await ImagePicker().getImage(source: source);
    if (image != null) {
      setState(() {
        imageFile = File(image.path);
        loadFromFile = true;
      });
    }
  }

  saveProfile(context) async {
    if (isLoading) {
      return;
    }
    isNetworkAvailable().then((bool) {
      if (bool) {
        //var future = _contactController.text != null ? setStringAsync(USER_CONTACT_NO, _contactController.text) : null;
        var request = {
          "id": userId,
          "username": _userNameController.text,
          "name": _nameController.text,
          "email": _emailController.text,
          "dob": "",
          "contact_number": _contactController.text,
        };
        showLoading(true);
        updateUser(request, imageFile).then((result) {
          print(result);
          showLoading(false);
          finish(context);
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
        elevation: 0.0,
        backgroundColor: context.scaffoldBackgroundColor,
        iconTheme: context.theme.iconTheme,
        centerTitle: true,
        title: Text(keyString(context, "guide_lbl_profile_edit"), style: boldTextStyle(color: context.theme.textTheme.headline6!.color)),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                Container(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Card(
                          semanticContainer: true,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          elevation: 12.0,
                          margin: EdgeInsets.all(0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: loadFromFile
                              ? Image.file(
                                  imageFile!,
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                )
                              : userProfile != null && userProfile.toString().isNotEmpty
                                  ? cachedImage(
                                      userProfile,
                                      height: 100,
                                      width: 100,
                                    )
                                  : Image.asset(ic_profile, width: 100, height: 100),
                        ).onTap(() {
                          getImage(ImageSource.gallery);
                        }),
                        16.height,
                        Text(
                          keyString(context, "lbl_change_photo"),
                          style: primaryTextStyle(color: context.theme.textTheme.button!.color),
                        ),
                      ],
                    ).paddingOnly(top: 16)),
                Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      AppTextField(
                        textStyle: primaryTextStyle(color: context.theme.textTheme.headline6!.color, size: 14),
                        controller: _nameController,
                        textFieldType: TextFieldType.NAME,
                        decoration: inputDecoration(context, label: keyString(context, "hint_name")),
                      ),
                      16.height,
                      AppTextField(
                        textStyle: primaryTextStyle(color: context.theme.textTheme.headline6!.color, size: 14),
                        controller: _userNameController,
                        textFieldType: TextFieldType.OTHER,
                        decoration: inputDecoration(context, label: keyString(context, "hint_username")),
                        validator: (value) {
                          return value!.isEmpty ? keyString(context, "error_uname_required") : null;
                        },
                      ),
                      16.height,
                      AppTextField(
                        textStyle: primaryTextStyle(color: context.theme.textTheme.headline6!.color, size: 14),
                        controller: _emailController,
                        textFieldType: TextFieldType.EMAIL,
                        decoration: inputDecoration(context, label: keyString(context, "hint_email")),
                      ),
                      16.height,
                      AppTextField(
                        textStyle: primaryTextStyle(color: context.theme.textTheme.headline6!.color, size: 14),
                        controller: _contactController,
                        textFieldType: TextFieldType.PHONE,
                        decoration: inputDecoration(context, label: keyString(context, "hint_contact_no")),
                        validator: (value) {
                          return value!.isEmpty ? keyString(context, "error_mobile") : null;
                        },
                      ),
                    ],
                  ),
                ),
                50.height,
                AppButton(
                  color: context.primaryColor,
                  width: context.width(),
                  textStyle: boldTextStyle(color: Colors.white),
                  text: keyString(context, "lbl_save"),
                  onTap: () {
                    if (isLoading) {
                      return;
                    }
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      saveProfile(context);
                    }
                  },
                ),
              ],
            ),
          ),
          Loader().visible(isLoading)
        ],
      ),
    );
  }
}
