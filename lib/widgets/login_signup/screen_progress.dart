// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';

// Project imports:
import 'package:jaansay_public_user/utils/login_controller.dart';

class ScreenProgress extends StatelessWidget {
  final LoginController c = Get.find();

  Widget _buildColumn(String title, Function ticks) {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Obx(() => ticks()),
        Text(title).tr(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _buildColumn("About", tick1),
        line(_mediaQuery),
        _buildColumn("Finish", tick3),
      ],
    );
  }

  Widget tick(bool isChecked) {
    return isChecked
        ? Icon(
            Icons.check_circle,
            color: Get.theme.primaryColor,
          )
        : Icon(
            Icons.radio_button_unchecked,
            color: Get.theme.primaryColor,
          );
  }

  Widget tick1() {
    return c.index.value > 0
        ? tick(
            true,
          )
        : tick(
            false,
          );
  }

  Widget tick3() {
    return c.index.value > 2
        ? tick(
            true,
          )
        : tick(
            false,
          );
  }

  Widget spacer() {
    return Container(
      width: 5.0,
    );
  }

  Widget line(Size mediaQuery) {
    return Expanded(
      child: Container(
        color: Get.theme.primaryColor,
        height: 5.0,
      ),
    );
  }
}
