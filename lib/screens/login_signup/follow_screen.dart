// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';

// Project imports:
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/screens/home_screen.dart';
import 'package:jaansay_public_user/service/follow_service.dart';
import 'package:jaansay_public_user/service/official_service.dart';
import 'package:jaansay_public_user/widgets/general/custom_auth_button.dart';
import 'package:jaansay_public_user/widgets/general/custom_loading.dart';
import 'package:jaansay_public_user/widgets/general/custom_network_image.dart';

class FollowScreen extends StatefulWidget {
  @override
  _FollowScreenState createState() => _FollowScreenState();
}

class _FollowScreenState extends State<FollowScreen> {
  bool isLoad = true;
  List<Official> officials = [];

  getData() async {
    OfficialService officialService = OfficialService();
    await officialService.getAllOfficials(officials);
    isLoad = false;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  Widget appBar(BuildContext context) {
    return AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        title: Text(
          "Follow users near you",
          style: TextStyle(color: Get.theme.primaryColor),
        ).tr());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: Column(
        children: [
          isLoad
              ? CustomLoading()
              : Expanded(
                  child: Container(
                    child: ListView.builder(
                      itemCount: officials.length,
                      itemBuilder: (context, index) {
                        return _OfficialTile(officials[index]);
                      },
                    ),
                  ),
                ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: CustomAuthButton(
              title: tr("Continue"),
              onTap: () => Get.offAll(HomeScreen()),
            ),
          ),
        ],
      ),
    );
  }
}

class _OfficialTile extends StatelessWidget {
  final Official official;

  _OfficialTile(this.official);

  @override
  Widget build(BuildContext context) {
    var isAllowFollow =
        (official.isFollow == null || official.isFollow == 0).obs;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: ClipOval(child: CustomNetWorkImage(official.photo)),
          ),
          SizedBox(
            width: 8,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${official.officialsName}",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "#${official.businesstypeName}",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Obx(
            () => Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                      color: isAllowFollow.value
                          ? Theme.of(context).primaryColor
                          : Colors.black54,
                      width: 0.5),
                  color: isAllowFollow.value
                      ? Theme.of(context).primaryColor
                      : Colors.black.withOpacity(0.01)),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.white,
                  onTap: () {
                    FollowService followService = FollowService();
                    isAllowFollow(false);
                    official.isFollow = 1;
                    followService.followUser(official.officialsId);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          isAllowFollow.value ? tr("Follow") : tr("Following"),
                          style: TextStyle(
                              color: isAllowFollow.value
                                  ? Colors.white
                                  : Colors.black),
                        ).tr(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
