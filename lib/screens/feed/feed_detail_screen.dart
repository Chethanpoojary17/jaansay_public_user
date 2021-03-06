// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:jaansay_public_user/models/feed.dart';
import 'package:jaansay_public_user/widgets/feed/feed_card.dart';
import 'package:easy_localization/easy_localization.dart';

class FeedDetailScreen extends StatelessWidget {
  final Feed feed;

  FeedDetailScreen(
    this.feed,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        title: Text(
          "Post",
          style: TextStyle(
            color: Get.theme.primaryColor,
          ),
        ).tr(),
      ),
      backgroundColor: Colors.white,
      body: Container(
        child: SingleChildScrollView(
          child: FeedCard(
            isDetail: true,
            feed: feed,
          ),
        ),
      ),
    );
  }
}
