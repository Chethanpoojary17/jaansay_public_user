import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaansay_public_user/models/feed.dart';
import 'package:jaansay_public_user/widgets/feed/feed_card.dart';

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
        ),
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
