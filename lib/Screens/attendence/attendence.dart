import 'dart:developer';

import 'package:c_supervisor/Screens/utills/app_colors_new.dart';
import 'package:c_supervisor/Screens/widgets/toast_message_show.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Model/request_model/get_attendence_request.dart';
import '../../Model/response_model/attendence_response/attendence_response.dart';
import '../../Network/http_manager.dart';
import '../utills/user_constants.dart';
import '../widgets/header_background_new.dart';
import '../widgets/header_widgets_new.dart';
import 'attendance_card.dart';

class TeamAttendence extends StatefulWidget {
  const TeamAttendence({super.key});

  @override
  State<TeamAttendence> createState() => _TeamAttendenceState();
}

class _TeamAttendenceState extends State<TeamAttendence> {
  List<GetAttendenceList> attendenceList = <GetAttendenceList>[];

  bool isLoading = true;
  bool isError = false;
  String errorText = "";
  var userId = "";

  AttendenceSummary attendenceSummary =
      AttendenceSummary(total: 0, present: 0, absent: 0);

  @override
  void initState() {
    // TODO: implement initState

    getUserData();
    super.initState();
  }

  getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      userId = sharedPreferences.getString(UserConstants().userId)!;
    });

    getAttendenceList(userId);
  }

  getAttendenceList(String elId) async {
    setState(() {
      isLoading = true;
    });

    print(elId);

    await HTTPManager()
        .teamAttendence(GetAttendenceRequestModel(elId: elId))
        .then((value) {
      setState(() {

        attendenceList = value.data.data;
        attendenceSummary = value.data.summary;
        isLoading = false;
        isError = false;
      });
    }).catchError((e) {
      log(e.toString());
      setState(() {
        isError = true;
        errorText = e.toString();
        isLoading = false;
      });
      // showToastMessage(false, errorText);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    Map<String, double> dataMap = {
      // "Total": attendenceSummary.total.toDouble(),
      "Present (${attendenceSummary.present})":
          attendenceSummary.present.toDouble(),
      "Absent (${attendenceSummary.absent})":
          attendenceSummary.absent.toDouble(),
      // "3 L1": attendenceSummary!.l1.toDouble(),
      // "4 L2": attendenceSummary!.l2.toDouble(),
      // "7 L3": attendenceSummary!.l3.toDouble(),
    };

    var colorList = [
      const Color.fromRGBO(10, 200, 300, 100),
      const Color.fromRGBO(238, 6, 6, 0.612),
      // Color.fromRGBO(7, 22, 236, 0.612),
      // Colors.blue,
      // Colors.purple
    ];

    return Scaffold(
      backgroundColor: AppColors.lightgray_2,
      body: HeaderBackgroundNew(
        childWidgets: [
          const HeaderWidgetsNew(
            pageTitle: "Team Attendance",
            isBackButton: true,
            isDrawerButton: true,
          ),
          isLoading
              ? Container(
                  margin: EdgeInsets.only(top: screenHeight * 0.3),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  ),
                )
              : Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      children: [
                        Card(
                          // elevation: 10,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: PieChart(
                              dataMap: dataMap,
                              animationDuration:
                                  const Duration(milliseconds: 1000),
                              chartLegendSpacing: 62,
                              chartRadius:
                                  MediaQuery.of(context).size.width / 4.5,
                              colorList: colorList,
                              initialAngleInDegree: 0,
                              chartType: ChartType.ring,
                              ringStrokeWidth: 22,
                              centerText: attendenceSummary.total.toString(),
                              legendOptions: const LegendOptions(
                                showLegendsInRow: false,
                                legendPosition: LegendPosition.right,
                                showLegends: true,
                                legendShape: BoxShape.rectangle,
                                legendTextStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              chartValuesOptions: const ChartValuesOptions(
                                // showChartValueBackground: true,
                                // showChartValues: true,
                                // showChartValuesInPercentage: false,
                                showChartValuesOutside: true,
                                // decimalPlaces: 1,
                              ),
                              // gradientList: ---To add gradient colors---
                              // emptyColorGradient: ---Empty Color gradient---
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                              itemCount: attendenceList.length,
                              itemBuilder: (ctx, i) {
                                return AttendanceCard(
                                  employeeId: attendenceList[i].id.toString(),
                                  employeeName: attendenceList[i].fullName,
                                  employeeFirstName:
                                      attendenceList[i].firstName,
                                  employeeLastName: attendenceList[i].lastName,
                                  location:
                                      attendenceList[i].isPresent.toString(),
                                  imageUrl: attendenceList[i].tmrPic,
                                  checkInTime: attendenceList[i].checkInTime,
                                  userId: userId,
                                  userRecordId:
                                      attendenceList[i].userRecordId.toString(),
                                  employeeAttendance:
                                      attendenceList[i].isPresent,
                                  updateByEl:
                                      attendenceList[i].updatedByEl.toString(),
                                  updateAttendanceView: () {
                                    getAttendenceList(userId);
                                  },
                                );
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
