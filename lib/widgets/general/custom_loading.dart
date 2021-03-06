// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomLoading extends StatelessWidget {
  final String title;
  final double height;

  CustomLoading({this.title = "Please wait", this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpinKitChasingDots(
            color: Theme.of(context).primaryColor,
            size: 30,
          ),
          SizedBox(
            height: 5,
          ),
          Text(tr("$title")),
        ],
      ),
    );
  }
}
