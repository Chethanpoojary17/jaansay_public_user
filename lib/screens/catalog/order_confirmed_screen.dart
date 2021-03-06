// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:jaansay_public_user/widgets/general/custom_button.dart';
import 'package:lottie/lottie.dart';

// Project imports:
import 'package:jaansay_public_user/screens/splash_screen.dart';
import 'package:easy_localization/easy_localization.dart';

class OrderConfirmedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: WillPopScope(
        onWillPop: () async {
          Get.offAll(SplashScreen());
          return false;
        },
        child: Column(
          children: [
            Container(
              child: Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: Get.height * 0.1,
                      ),
                      Lottie.asset('assets/anims/done.json',
                          repeat: false, height: Get.height * 0.4),
                      Container(
                        width: double.infinity,
                        padding:
                            EdgeInsets.symmetric(horizontal: Get.width * 0.1),
                        child: Column(
                          children: [
                            Text(
                              "Order Received",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                  letterSpacing: 0.9),
                              textAlign: TextAlign.center,
                            ).tr(),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              "Thank you for your order. You will receive order confirmation message from the seller shortly.",
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 16,
                                  letterSpacing: 0.9),
                              textAlign: TextAlign.center,
                            ).tr(),
                            const SizedBox(
                              height: 16,
                            ),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300,
                                    letterSpacing: 0.9),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: tr(
                                          'Check the status of your order on the ')),
                                  TextSpan(
                                      text: tr('Your Orders'),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500)),
                                  TextSpan(text: tr(' page.')),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            BottomButton(
              onTap: () {
                Get.offAll(SplashScreen());
              },
              text: "Continue",
            )
          ],
        ),
      ),
    );
  }
}
