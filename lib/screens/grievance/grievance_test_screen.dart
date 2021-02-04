import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'file:///C:/Users/Deepak/FlutterProjects/jaansay_public_user/lib/screens/grievance/grievance_test_history_screen.dart';
import 'file:///C:/Users/Deepak/FlutterProjects/jaansay_public_user/lib/screens/grievance/grievance_test_send_screen.dart';
import 'package:easy_localization/easy_localization.dart';

class GrievanceScreen extends StatefulWidget {
  @override
  _GrievanceScreenState createState() => _GrievanceScreenState();
}

class _GrievanceScreenState extends State<GrievanceScreen> {
  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size;

    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            flexibleSpace: AppBar(
              flexibleSpace: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TabBar(tabs: [
                    Tab(
                      text: "${tr("Send")}",
                    ),
                    Tab(
                      text: "${tr("History")}",
                    ),
                  ]),
                ],
              ),
            ),
          ),
          body: TabBarView(
            children: [
              GrievanceSendScreen(),
              GrievanceHistoryScreen(),
            ],
          ),
        ),
      ),
    );
  }
}