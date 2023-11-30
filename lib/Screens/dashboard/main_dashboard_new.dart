import 'dart:io';

import 'package:c_supervisor/Network/api_urls.dart';
import 'package:c_supervisor/Screens/dashboard/widgets/main_dashboard_card_item.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../my_jp/my_journey_plan_screen.dart';
import '../utills/user_constants.dart';
import '../widgets/header_background_new.dart';
import '../widgets/header_widgets_new.dart';
import '../widgets/toast_message_show.dart';

class MainDashboardNew extends StatefulWidget {
  const MainDashboardNew({Key? key}) : super(key: key);

  @override
  State<MainDashboardNew> createState() => _MainDashboardNewState();
}

class _MainDashboardNewState extends State<MainDashboardNew> {

  String userName = "";
  String userId = "";

  @override
  void initState() {
    // TODO: implement initState
    getUserData();
    super.initState();
  }

  getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      userName = sharedPreferences.getString(UserConstants().userName)!;
      userId = sharedPreferences.getString(UserConstants().userId)!;
    });
  }

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
                    child: const Text('No'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                      exit(0);
                    },
                    child: const Text('Yes'),
                  ),
                ],
              );
            },
          );
          return shouldPop!;
        },
        child: HeaderBackgroundNew(
          childWidgets: [
             HeaderWidgetsNew(pageTitle: "Welcome $userName",isBackButton: false,isDrawerButton: true),
            Expanded(
              child: GridView(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: (163.5 / 135),
                  crossAxisCount: 2,
                ),
                children:  [
                  MainDashboardItemCard(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const MyJourneyPlanScreenNew()));
                      },imageUrl: "assets/dashboard/my_journey_plan.png", cardName: "My Jp"),
                  MainDashboardItemCard(onTap:(){
                    showToastMessage(false,"Coming Soon...");
                  },imageUrl:"assets/dashboard/my_team.png", cardName:"My Team"),
                  MainDashboardItemCard(onTap:(){
                    showToastMessage(false,"Coming Soon...");
                  },imageUrl:"assets/dashboard/my_coverage.png", cardName:"My Coverage"),
                  MainDashboardItemCard(onTap:(){
                    showToastMessage(false,"Coming Soon...");
                  },imageUrl:"assets/dashboard/knowledge_share.png",cardName: "Knowledge Share"),
                  MainDashboardItemCard(onTap:(){
                    showToastMessage(false,"Coming Soon...");
                  },imageUrl:"assets/dashboard/clients.png",cardName: "My Clients"),
                ],
              ),
            )
          ],
        )
      ),
    );
  }
}
