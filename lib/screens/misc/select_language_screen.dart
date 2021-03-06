// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';

// Project imports:
import 'package:jaansay_public_user/screens/login_signup/login_screen.dart';
import 'package:jaansay_public_user/screens/splash_screen.dart';

class SelectLanguageScreen extends StatefulWidget {
  @override
  _SelectLanguageScreenState createState() => _SelectLanguageScreenState();
}

class _SelectLanguageScreenState extends State<SelectLanguageScreen> {
  bool isFirst;

  Widget languageButton(String code, String title) {
    bool isActive = false;

    if (context.locale.languageCode == code) {
      isActive = true;
    }

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
              color: isActive ? Theme.of(context).primaryColor : Colors.black54,
              width: 0.5),
          color:
              isActive ? Theme.of(context).primaryColor : Colors.grey.shade50),
      width: 120,
      height: 40,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: Colors.white,
            onTap: () async {
              if (!isFirst) {
                if (!isActive) {
                  context.setLocale(Locale(code));
                  Get.updateLocale(Locale(code));
                  Get.offAll(SplashScreen());
                } else {
                  Get.rawSnackbar(
                      message: tr("You have already select this language"));
                }
              } else {
                context.setLocale(Locale(code));
                Get.updateLocale(Locale(code));

                Future.delayed(Duration(milliseconds: 100),
                    () => Get.offAll(LoginScreen()));
              }
            },
            child: Align(
              alignment: Alignment.center,
              child: Text(
                title,
                style: TextStyle(color: isActive ? Colors.white : Colors.black),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    isFirst = ModalRoute.of(context).settings.arguments ?? false;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        title: Text(
          "Select Language",
          style: TextStyle(
            color: Get.theme.primaryColor,
          ),
        ).tr(),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/select_language.png"),
          SizedBox(
            height: 30,
          ),
          Text(
            "Select Your Language",
            style: TextStyle(fontSize: 20),
          ).tr(),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              languageButton("en", "English"),
              SizedBox(
                width: 30,
              ),
              languageButton("kn", "Kannada")
            ],
          )
        ],
      ),
    );
  }
}
