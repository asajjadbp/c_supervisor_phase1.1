import 'dart:io';

import 'package:flutter/material.dart';

import '../attendence/attendence_home.dart';
import '../dashboard/widgets/main_dashboard_card_item.dart';
import '../utills/app_colors_new.dart';
import '../widgets/header_background_new.dart';
import '../widgets/header_widgets_new.dart';

class MyTeam extends StatelessWidget {
  const MyTeam({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
          onWillPop: () async {
            final shouldPop = await showDialog<bool>(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Do you want to leave ?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      child: const Text(
                        'No',
                        style: TextStyle(color: AppColors.primaryColor),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                        exit(0);
                      },
                      child: const Text(
                        'Yes',
                        style: TextStyle(color: AppColors.primaryColor),
                      ),
                    ),
                  ],
                );
              },
            );
            return shouldPop!;
          },
          child: IgnorePointer(
            ignoring: false,
            child: HeaderBackgroundNew(
              childWidgets: [
                HeaderWidgetsNew(
                    pageTitle: "My Team",
                    isBackButton: false,
                    isDrawerButton: true),
                Expanded(
                  child: Stack(
                    children: [
                      GridView(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: (163.5 / 135),
                          crossAxisCount: 2,
                        ),
                        children: [
                          MainDashboardItemCard(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const AttendenceHome()));

                                // showToastMessage(false,"Coming Soon...");
                              },
                              imageUrl:
                                  // "assets/dashboard/my_coverage.png"
                                  "assets/myicons/attendance.png",
                              cardName: "Team Attendance"),
                          // MainDashboardItemCard(onTap:(){
                          //
                          // },imageUrl:"assets/dashboard/my_team.png", cardName:"My Team"),
                          // MainDashboardItemCard(onTap:(){
                          //   showToastMessage(false,"Coming Soon...");
                          // },imageUrl:"assets/dashboard/knowledge_share.png",cardName: "Knowledge Share"),
                          // MainDashboardItemCard(onTap:(){
                          //   showToastMessage(false,"Coming Soon...");
                          // },imageUrl:"assets/dashboard/clients.png",cardName: "My Clients"),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
