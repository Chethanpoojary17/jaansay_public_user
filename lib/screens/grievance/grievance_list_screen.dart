// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/providers/grievance_provider.dart';
import 'package:jaansay_public_user/providers/official_profile_provider.dart';
import 'package:jaansay_public_user/screens/community/profile_full_screen.dart';
import 'package:jaansay_public_user/screens/grievance/grievance_add_screen.dart';
import 'package:jaansay_public_user/screens/grievance/grievance_detail_screen.dart';
import 'package:jaansay_public_user/widgets/dashboard/grievance_head.dart';
import 'package:jaansay_public_user/widgets/general/custom_loading.dart';
import 'package:jaansay_public_user/widgets/general/custom_network_image.dart';

class GrievanceListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final officialProfileProvider =
        Provider.of<OfficialProfileProvider>(context, listen: false);
    final grievanceProvider = Provider.of<GrievanceProvider>(context);

    Official official = grievanceProvider.selectedOfficial;

    if (!grievanceProvider.initMaster) {
      grievanceProvider.initMaster = true;
      grievanceProvider.getAllGrievanceMasters();
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        titleSpacing: 0,
        leadingWidth: 50,
        title: InkWell(
          onTap: () {
            officialProfileProvider.clearData();

            Get.until((route) => route.isFirst);
            Get.to(
              ProfileFullScreen(
                official.officialsId,
              ),
            );
          },
          child: Row(
            children: [
              Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: ClipOval(child: CustomNetWorkImage(official.photo)),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                official.officialsName,
                style: TextStyle(
                  color: Get.theme.primaryColor,
                ),
              ).tr(),
            ],
          ),
        ),
        actions: [
          InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: () async {
              final url = "tel:${official.officialDisplayPhone}";
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw '${tr("Could not launch")} $url';
              }
            },
            child: Container(
              margin: EdgeInsets.only(left: 15, right: 15),
              child: Icon(
                Icons.call,
                size: 26,
                color: Get.theme.primaryColor,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: grievanceProvider.isMasterLoad
          ? null
          : FloatingActionButton.extended(
              backgroundColor: Get.theme.primaryColor,
              icon: Icon(
                Icons.add,
                color: Colors.white,
                size: 22,
              ),
              label: Text(
                "Add Grievance",
                style: TextStyle(color: Colors.white, fontSize: 14),
              ).tr(),
              onPressed: () {
                Get.to(() => GrievanceAddScreen(),
                    transition: Transition.rightToLeft);
              },
            ),
      body: grievanceProvider.isMasterLoad
          ? CustomLoading()
          : Container(
              child: ListView.builder(
                itemCount: grievanceProvider.grievanceMasters.length,
                itemBuilder: (context, index) {
                  return GrievanceHead(
                      grievanceProvider.grievanceMasters[index], () {
                    grievanceProvider.clearData();
                    grievanceProvider.selectedGrievanceMaster =
                        grievanceProvider.grievanceMasters[index];
                    Get.to(() => GrievanceDetailScreen(),
                        transition: Transition.rightToLeft);
                  });
                },
              ),
            ),
    );
  }
}
