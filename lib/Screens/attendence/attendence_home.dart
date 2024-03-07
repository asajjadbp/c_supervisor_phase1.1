import 'package:c_supervisor/Model/request_model/get_attendence_request.dart';
import 'package:c_supervisor/Model/request_model/get_check_list_request.dart';
import 'package:c_supervisor/Model/response_model/journey_responses_plan/journey_plan_response_list.dart';
import 'package:c_supervisor/Screens/attendence/attendence.dart';
import 'package:c_supervisor/Screens/myteam/special_visit_screen.dart';
import 'package:c_supervisor/Screens/myteam/team_kpi.dart';
import 'package:flutter/material.dart';

import '../../Model/response_model/attendence_response/attendence_response.dart';
import '../../Network/http_manager.dart';
import '../dashboard/widgets/main_dashboard_card_item.dart';
import '../myteam/visits_history.dart';
import '../widgets/header_background_new.dart';
import '../widgets/header_widgets_new.dart';

class AttendenceHome extends StatefulWidget {
  const AttendenceHome({super.key});

  @override
  State<AttendenceHome> createState() => _AttendenceHomeState();
}

class _AttendenceHomeState extends State<AttendenceHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IgnorePointer(
        ignoring: false,
        child: HeaderBackgroundNew(
          childWidgets: [
            const HeaderWidgetsNew(
                pageTitle: "My Team", isBackButton: true, isDrawerButton: true),
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
                            // if (isCheckedIn) {
                            //   showToastMessage(
                            //       false, "Please check out first and try again");
                            // } else {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const TeamAttendence()));
                            // }
                            // showToastMessage(false,"Coming Soon...");
                          },
                          imageUrl: "assets/myicons/attendance.png",
                          cardName: "Team Attendance"),
                      MainDashboardItemCard(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                const VisitHistory()));

                            // showToastMessage(false,"Coming Soon...");
                          },
                          imageUrl:
                          // "assets/dashboard/my_coverage.png"
                          "assets/myicons/visithistory.png",
                          cardName: "Visits History"),
                      MainDashboardItemCard(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                const TeamKpiScreen()));

                            // showToastMessage(false,"Coming Soon...");
                          },
                          imageUrl:
                          // "assets/dashboard/my_coverage.png"
                          "assets/myicons/teamkpi.png",
                          cardName: "Team KPIS"),
                      MainDashboardItemCard(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                const SpecialVisitScreen()));

                            // showToastMessage(false,"Coming Soon...");
                          },
                          imageUrl:
                          // "assets/dashboard/my_coverage.png"
                          "assets/myicons/specialvisit.png",
                          cardName: "Special Visits"),
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
      ),
    );
  }
}
