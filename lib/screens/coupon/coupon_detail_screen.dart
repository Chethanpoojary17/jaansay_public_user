import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:jaansay_public_user/providers/coupon_provider.dart';
import 'package:jaansay_public_user/widgets/misc/custom_divider.dart';
import 'package:jaansay_public_user/widgets/misc/custom_network_image.dart';

import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class CouponDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final couponProvider = Provider.of<CouponProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        title: Text(
          "Coupon Details",
          style: TextStyle(
            color: Get.theme.primaryColor,
          ),
        ),
        actions: [
          InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: () async {
              final url =
                  "tel:${couponProvider.coupons[couponProvider.selectedCouponIndex].officialsPhone}";
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw '${"Could not launch"} $url';
              }
            },
            child: Container(
              margin: EdgeInsets.only(left: 15, right: 15),
              child: Icon(
                Icons.call,
                size: 28,
                color: Get.theme.primaryColor,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                    horizontal: 16, vertical: Get.height * 0.05),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    couponProvider.coupons[couponProvider.selectedCouponIndex]
                            .expireOn
                            .isBefore(DateTime.now())
                        ? Container(
                            height: Get.width * 0.2,
                            width: Get.width * 0.2,
                            margin: EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(shape: BoxShape.circle),
                            child: ClipOval(
                              child: CustomNetWorkImage(couponProvider
                                  .coupons[couponProvider.selectedCouponIndex]
                                  .photo),
                            ),
                          )
                        : QrImage(
                            data: json.encode({
                              "type": "coupon",
                              "user_id":
                                  GetStorage().read("user_id").toString(),
                              "code": couponProvider
                                  .coupons[couponProvider.selectedCouponIndex]
                                  .cmCode
                            }),
                            version: QrVersions.auto,
                            size: 200.0,
                          ),
                    Text(
                      couponProvider.coupons[couponProvider.selectedCouponIndex]
                          .officialsName,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      couponProvider
                          .coupons[couponProvider.selectedCouponIndex].title,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 4, horizontal: 22),
                      decoration: BoxDecoration(
                        color: couponProvider
                                .coupons[couponProvider.selectedCouponIndex]
                                .expireOn
                                .isBefore(DateTime.now())
                            ? Colors.grey.withAlpha(50)
                            : Get.theme.primaryColor.withAlpha(25),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        "${couponProvider.coupons[couponProvider.selectedCouponIndex].expireOn.isBefore(DateTime.now()) ? 'Expired on' : 'Expires on'}: ${DateFormat("dd MMM").format(couponProvider.coupons[couponProvider.selectedCouponIndex].expireOn)}",
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomDivider(
                      isColor: true,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Container(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Offer Details:",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            couponProvider
                                .coupons[couponProvider.selectedCouponIndex]
                                .description,
                            style: TextStyle(
                                letterSpacing: 0.5, height: 1.25, fontSize: 14),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}