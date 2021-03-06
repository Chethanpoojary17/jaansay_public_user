// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/models/review.dart';
import 'package:jaansay_public_user/providers/feed_provider.dart';
import 'package:jaansay_public_user/providers/official_profile_provider.dart';
import 'package:jaansay_public_user/screens/community/profile_description_screen.dart';
import 'package:jaansay_public_user/screens/home_screen.dart';
import 'package:jaansay_public_user/service/official_service.dart';
import 'package:jaansay_public_user/widgets/feed/feed_card.dart';
import 'package:jaansay_public_user/widgets/general/custom_error_widget.dart';
import 'package:jaansay_public_user/widgets/general/custom_loading.dart';
import 'package:jaansay_public_user/widgets/profile/officials_profile_head.dart';
import 'package:jaansay_public_user/widgets/profile/review_card.dart';

class ProfileFullScreen extends StatelessWidget {
  final int officialId;
  final bool isClose;

  ProfileFullScreen(this.officialId, {this.isClose = false});

  @override
  Widget build(BuildContext context) {
    final feedProvider = Provider.of<FeedProvider>(context);
    final officialProvider = Provider.of<OfficialProfileProvider>(context);

    if (!officialProvider.initProfile) {
      officialProvider.initProfile = true;

      officialProvider.getOfficialById(officialId, feedProvider);
    }

    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
          backgroundColor: Colors.white,
          title: Text(
            officialProvider.isProfileLoad || officialProvider.official == null
                ? "${tr('Profile')}"
                : officialProvider.official.officialsName,
            style: TextStyle(
              color: Get.theme.primaryColor,
            ),
          ),
          actions: officialProvider.isProfileLoad ||
                  officialProvider.official == null
              ? null
              : officialProvider.official.detailDescription.length > 5
                  ? [
                      InkWell(
                        borderRadius: BorderRadius.circular(15),
                        onTap: () {
                          Get.to(
                              () => ProfileDescriptionScreen(
                                  officialProvider.official),
                              transition: Transition.rightToLeft);
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 16, left: 10),
                          child: Icon(
                            Icons.help_outline,
                            size: 28,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ]
                  : null,
        ),
        body: WillPopScope(
          onWillPop: () async {
            if (isClose) {
              await Get.offAll(HomeScreen());
              return false;
            } else {
              return true;
            }
          },
          child: officialProvider.isProfileLoad ||
                  officialProvider.official == null
              ? CustomLoading()
              : SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    child: Column(
                      children: [
                        OfficialsProfileHead(),
                        officialProvider.official.isFollow == 1
                            ? feedProvider.isBusinessLoad
                                ? CustomLoading(
                                    title: "Loading Feeds",
                                    height: Get.height * 0.3,
                                  )
                                : feedProvider.businessFeeds.length == 0
                                    ? CustomErrorWidget(
                                        title: "No posts",
                                        iconData: Icons.dynamic_feed_outlined,
                                        height: Get.height * 0.3,
                                      )
                                    : ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount:
                                            feedProvider.businessFeeds.length,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return FeedCard(
                                            feed: feedProvider
                                                .businessFeeds[index],
                                            isDetail: false,
                                          );
                                        },
                                      )
                            : _ReviewSection(officialProvider.official),
                      ],
                    ),
                  ),
                ),
        ));
  }
}

class _ReviewSection extends StatefulWidget {
  final Official official;

  _ReviewSection(this.official);

  @override
  __ReviewSectionState createState() => __ReviewSectionState();
}

class __ReviewSectionState extends State<_ReviewSection> {
  bool isLoad = true;
  List<Review> reviews = [];

  Review userReview;
  bool isCheck = false;

  getData() async {
    isLoad = true;
    setState(() {});
    reviews.clear();
    userReview = null;

    OfficialService officialService = OfficialService();

    userReview = await officialService.getOfficialRatings(
        widget.official.officialsId.toString(), reviews);
    isLoad = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: isLoad
          ? CustomLoading()
          : reviews.length == 0 && widget.official.isFollow != 1
              ? Container(
                  margin: EdgeInsets.only(top: Get.height * 0.1),
                  child: CustomErrorWidget(
                    title: tr("No reviews"),
                    iconData: Icons.not_interested,
                  ),
                )
              : ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return index == 0
                        ? userReview == null
                            ? SizedBox.shrink()
                            : ReviewCard(userReview)
                        : ReviewCard(
                            reviews[index - 1],
                          );
                  },
                  itemCount: reviews.length + 1,
                ),
    );
  }
}
