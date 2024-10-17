// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';
import 'package:c_supervisor/Screens/utills/image_to_cloud.dart';
import 'package:flutter/services.dart';

import 'package:c_supervisor/Model/request_model/journey_plan_request.dart';
import 'package:c_supervisor/Screens/dashboard/widgets/checkin_checkout_button.dart';
import 'package:c_supervisor/Screens/dashboard/widgets/circular_percent_indicatio_with_title.dart';
import 'package:c_supervisor/Screens/dashboard/widgets/colum_graph_widget.dart';
import 'package:c_supervisor/Screens/dashboard/widgets/container_background.dart';
import 'package:c_supervisor/Screens/dashboard/widgets/efficiency_title_bar.dart';
import 'package:c_supervisor/Screens/dashboard/widgets/graph_details_widget.dart';
import 'package:c_supervisor/Screens/dashboard/widgets/main_dashboard_card_item.dart';
import 'package:c_supervisor/Screens/dashboard/widgets/time_gauge_widget.dart';
import 'package:c_supervisor/Screens/widgets/header_background_new.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart' as location;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../Model/chart_data_Model.dart';
import '../../Model/request_model/check_in_status_request.dart';
import '../../Model/request_model/save_user_location_request.dart';
import '../../Model/response_model/check_in_response/check_in_response.dart';
import '../../Model/response_model/check_in_response/check_in_status_response.dart';
import '../../Model/response_model/check_in_response/check_in_status_response_details.dart';
import '../../Model/response_model/dashboard_model_response.dart';
import '../../Network/http_manager.dart';
import '../../provider/license_provider.dart';
import '../attendence/attendence.dart';
import '../attendence/attendence_home.dart';
import '../buisness_trips/business_trips_screen.dart';
import '../clients/client_screen.dart';
import '../knowledge/knowledge_share.dart';
import '../my_coverage/my_coverage_plan_screen.dart';
import '../my_jp/my_journey_plan_screen.dart';
import '../myteam/special_visit_screen.dart';
import '../myteam/team_kpi.dart';
import '../myteam/visits_history.dart';
import '../recruite_suggest/recruit_suggest_screen.dart';
import '../setting_screen/setting_screen_new.dart';
import '../time_motion/time_motion_screen.dart';
import '../utills/app_colors_new.dart';
import '../utills/image_compressed_functions.dart';
import '../utills/image_quality.dart';
import '../utills/location_permission_handle.dart';
import '../utills/user_constants.dart';
import '../utills/vpn_detector_handler.dart';
import '../widgets/alert_dialogues.dart';
import '../widgets/error_text_and_button.dart';
import '../widgets/header_widgets_new.dart';
import '../widgets/toast_message_show.dart';

class DashboardGraphScreen extends StatefulWidget {
  const DashboardGraphScreen({super.key});

  @override
  State<DashboardGraphScreen> createState() => _DashboardGraphScreenState();
}

class _DashboardGraphScreenState extends State<DashboardGraphScreen> {
  String userName = "";
  String userId = "";
   int backgroundService = 0;
  ImagePicker picker = ImagePicker();
  XFile? image;
  XFile? compressedImage;
  location.Position? _currentPosition;
  late DashboardResponseData dashboardResponseData;

  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  bool isLoading1 = true;
  bool isLoading3 = true;
  bool isLoading2 = false;
  bool isError = false;
  String errorText = "";
  String errorText1 = "";

  bool isCheckedIn = false;
  String? checkInId;
  String checkInTime = "";
  String checkOutTime = "";
  var release = "";

  Timer? timer;
  bool? isVpnConnected;

  List<CheckInStatusItem> checkListItem = <CheckInStatusItem>[];
  List<CheckInStatusDetailsItem> checkListItemStatus =
      <CheckInStatusDetailsItem>[];

  TextEditingController commentController = TextEditingController();

  List<IpcLocationResponseItem> ipcLocation = <IpcLocationResponseItem>[];

  int _selectedTab = 0;

  void onRefresh() async {
    // monitor network fetch
    getCheckInStatus();
    getDashboardData();
    // if failed,use refreshFailed()
    refreshController.refreshCompleted();
  }

  void onLoading() async {
    // monitor network fetch
    getCheckInStatus();
    getDashboardData();
    // if failed,use loadFailed(),if no data return,use LoadNodata()

    refreshController.loadComplete();
  }

  _changeTab(int index) {
    setState(() {
      _selectedTab = index;
      print(_selectedTab);
    });
  }

  @override
  void initState() {
    getUserData();
    updateAvailable();
    // checkUpdate();
    // getIpcLocations();
    checkVpnDetector();

    super.initState();
  }

  updateAvailable() {
    // Instantiate NewVersion manager object (Using GCP Console app as example)
    final newVersion = NewVersionPlus(
      iOSId: 'com.catalist.EE-leaders',
      androidId: 'com.catalist.csupervisor',
      androidPlayStoreCountry: "es_ES",
      // androidHtmlReleaseNotes: true, //support country code
    );

    // You can let the plugin handle fetching the status and showing a dialog,
    // or you can fetch the status and display your own dialog, or no dialog.
    final ver = VersionStatus(
      appStoreLink: '',
      localVersion: '',
      storeVersion: '',
      releaseNotes: '',
      originalStoreVersion: '',
    );
    print(ver);

    // basicStatusCheck(newVersion);
    advancedStatusCheck(newVersion);
  }

  advancedStatusCheck(NewVersionPlus newVersion) async {
    setState(() {
      isLoading1 = true;
    });
    final status = await newVersion.getVersionStatus();

    if (status != null) {
      debugPrint(status.releaseNotes);
      debugPrint(status.appStoreLink);
      debugPrint(status.localVersion);
      debugPrint(status.storeVersion);
      debugPrint(status.canUpdate.toString());
      if (status.canUpdate) {
        newVersion.showUpdateDialog(
          context: context,
          versionStatus: status,
          dialogTitle: 'Update Available',
          dialogText: 'Please update your app to ${status.storeVersion}',
          launchModeVersion: LaunchModeVersion.external,
          allowDismissal: true,
        );
      }
    }
    setState(() {
      isLoading1 = false;
    });
  }

  checkVpnDetector() async {
    bool isVpnConnected = await vpnDetector();

    print("VPN Status");
    print(isVpnConnected);
  }

  getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      userName = sharedPreferences.getString(UserConstants().userName)!;
      userId = sharedPreferences.getString(UserConstants().userId)!;
      backgroundService = sharedPreferences.getInt(UserConstants().userGeoFence)!;

    });

    getCheckInStatus();
    getDashboardData();
    if(backgroundService== 1 || backgroundService == 1.0)
    {Timer.periodic(
        const Duration(minutes: 15), (Timer t) => _getCurrentPosition(false));}
    else
      print("no background services");  }

  getDashboardData() {
    setState(() {
      isLoading3 = true;
    });
    HTTPManager()
        .dashboardDataDetails(JourneyPlanRequestModel(elId: userId))
        .then((value) {
      setState(() {
        if (value.data!.isNotEmpty) {
          dashboardResponseData = value;
        } else {
          dashboardResponseData =
              DashboardResponseData(status: true, msg: "", data: <Data>[
            Data(
              mykpi: Mykpi(
                  planned: 0,
                  totalPlanned: 0,
                  totalJpc: 0,
                  totalEffeciency: 0,
                  totalCoverage: 0,
                  special: 0,
                  checkins: 0,
                  totalCheckins: 0,
                  plannedTime: 0,
                  specialTime: 0,
                  checkinTime: 0),
              teamkpi: Teamkpi(
                  totalUsers: 0,
                  totalPresent: 0,
                  totalJpc: 0,
                  totalProductivity: 0,
                  totalEffeciency: 0),
            )
          ]);
        }

        errorText1 = "";
        isError = false;
        isLoading3 = false;
      });
    }).catchError((e) {
      setState(() {
        print(e.toString());
        isLoading3 = false;
        isError = true;
        errorText1 = e.toString();
      });
    });
  }

  saveUserCurrentLocation(String currentPosition) {
    HTTPManager()
        .saveUserCurrentLocation(SaveUserLocationRequestModel(
            elId: userId, latLong: currentPosition))
        .then((value) {
      print(value);
    }).catchError((e) {
      print(e.toString());
    });
  }

  getCheckInStatus() {
    setState(() {
      isLoading1 = true;
    });

    HTTPManager()
        .getCheckInStatus(CheckInRequestModel(elId: userId))
        .then((value) {
      setState(() {
        checkListItemStatus = value.data!;

        // print("-----------------");
        print(checkListItemStatus[0].checkoutStatus!);
        // print(checkListItemStatus.length);
        // print("++++++++++");

        if (checkListItemStatus.isNotEmpty) {
          if (checkListItemStatus[0].checkoutStatus!) {
            isCheckedIn = false;
          } else {
            isCheckedIn = true;
          }
          checkInId = checkListItemStatus[0].id.toString();
          checkInTime = checkListItemStatus[0].checkinTime!;
          checkOutTime = checkListItemStatus[0].checkoutTime!;
        } else {
          checkInId = "";
          checkInTime = "";
          checkOutTime = "";
          isCheckedIn = false;
        }

        isLoading1 = false;
        isError = false;
      });
    }).catchError((e) {
      setState(() {
        print(e.toString());
        isLoading1 = false;
        // isError = true;
        errorText1 = e.toString();
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SettingScreenNew()));
                  },
                  child: SvgPicture.asset(
                    'assets/icons/menu_ic.svg',
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Column(
                  children: [
                    Text(
                      "Welcome $userName",
                     overflow:TextOverflow.ellipsis,
                      style: const TextStyle(

                          color: AppColors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    ),
                    Text(
                      DateFormat.yMMMd().format(DateTime.now()),
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w400,
                        color: AppColors.white,),
                    ),
                  ],
                )
              ],
            ),
            const Text(
              "Version:1.0.27",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400,color: Colors.white),
            )
          ],
        ),
      ),
      bottomNavigationBar: Theme(
        data: ThemeData(
          canvasColor: AppColors.primaryColor,
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedTab,
          onTap: (index) => _changeTab(index),
          selectedItemColor: AppColors.white,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          unselectedItemColor: AppColors.graphBackground,
          items: const [
            BottomNavigationBarItem(
                icon: ImageIcon(
                    AssetImage("assets/myicons/my_kpi_white_icon.png")),
                label: "KPIs"),
            BottomNavigationBarItem(
                icon: ImageIcon(
                    AssetImage("assets/myicons/my_team_kpi_white_icon.png")),
                label: "Team KPIs"),
            BottomNavigationBarItem(
                icon: ImageIcon(
                    AssetImage("assets/myicons/other_white_icon.png")),
                label: "Other"),
          ],
        ),
      ),
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
        child: SmartRefresher(
          enablePullDown: true,
          header: const WaterDropHeader(
            waterDropColor: AppColors.primaryColor,
            complete: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Icon(Icons.check), Text(" Success")],
            ),
          ),
          controller: refreshController,
          onRefresh: onRefresh,
          onLoading: onLoading,
          child: IgnorePointer(
              ignoring: isLoading2,
              child: HeaderBackgroundNew(childWidgets: [
                Expanded(
                    child: isLoading1 || isLoading3
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primaryColor,
                            ),
                          )
                        : isError
                            ? ErrorTextAndButton(
                                onTap: () {
                                  // getIpcLocations();
                                  getCheckInStatus();
                                  getDashboardData();
                                },
                                errorText: errorText1)
                            : Stack(
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                        color: AppColors.white),
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      children: [
                                        if (_selectedTab == 0)
                                          Expanded(
                                            child: SingleChildScrollView(
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              child: ContainerBackground(
                                                childWidget: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // const Text("My KPIs",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: AppColors.primaryColor),),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        CircularPercentIndicatorWidget(
                                                            title: "JPC",
                                                            imageStringIcon: "",
                                                            percentColor:
                                                                AppColors
                                                                    .graphPurple,
                                                            percentText:
                                                                dashboardResponseData
                                                                        .data![
                                                                            0]
                                                                        .mykpi!
                                                                        .totalJpc! /
                                                                    100),
                                                        Expanded(
                                                            child: HalfScreenEfficiency(
                                                                percentValue:
                                                                    dashboardResponseData
                                                                        .data![
                                                                            0]
                                                                        .mykpi!
                                                                        .totalEffeciency!))
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                            child: Column(
                                                          children: [
                                                            Card(
                                                              child: Column(
                                                                children: [
                                                                  const Text(
                                                                      "TMRs"),
                                                                  ColumnGraphWidget(
                                                                    firstColor:
                                                                        AppColors
                                                                            .graphPurple,
                                                                    firstChartData:
                                                                        dashboardResponseData.data![0].mykpi!.totalPlanned! !=
                                                                                0
                                                                            ? [
                                                                                ChartData("Covered", dashboardResponseData.data![0].mykpi!.totalPlanned!)
                                                                              ]
                                                                            : [],
                                                                    secondColor:
                                                                        AppColors
                                                                            .graphLightPurple,
                                                                    secondChartData:
                                                                        dashboardResponseData.data![0].mykpi!.planned! !=
                                                                                0
                                                                            ? [
                                                                                ChartData("Covered", dashboardResponseData.data![0].mykpi!.planned!)
                                                                              ]
                                                                            : [],
                                                                  ),
                                                                  const GraphDetailsWidget(
                                                                    firstTitle:
                                                                        "Covered",
                                                                    firstColor:
                                                                        AppColors
                                                                            .graphPurple,
                                                                    secondTitle:
                                                                        "Planned",
                                                                    secondColor:
                                                                        AppColors
                                                                            .graphLightPurple,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            TimeGauge(
                                                              timeGauge:
                                                                  dashboardResponseData
                                                                      .data![0]
                                                                      .mykpi!
                                                                      .plannedTime!,
                                                              timeValue:
                                                                  dashboardResponseData
                                                                      .data![0]
                                                                      .myKpiHr!
                                                                      .plannedHours!,
                                                            )
                                                          ],
                                                        )),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Expanded(
                                                            child: Column(
                                                          children: [
                                                            Card(
                                                              child: Column(
                                                                children: [
                                                                  const Text(
                                                                      "Stores"),
                                                                  SizedBox(
                                                                    height: MediaQuery.of(context)
                                                                            .size
                                                                            .height /
                                                                        7,
                                                                    child:
                                                                        Visibility(
                                                                      visible: dashboardResponseData.data![0].mykpi!.special! !=
                                                                              0 ||
                                                                          dashboardResponseData.data![0].mykpi!.planned! !=
                                                                              0,
                                                                      child: SfCircularChart(
                                                                          palette: const [
                                                                            AppColors.graphLightPurple,
                                                                            AppColors.graphPurple
                                                                          ],
                                                                          series: <CircularSeries>[
                                                                            DoughnutSeries<ChartData, String>(dataSource: [
                                                                              ChartData("CheckIn", dashboardResponseData.data![0].mykpi!.special!),
                                                                              ChartData("CheckIn", dashboardResponseData.data![0].mykpi!.planned!)
                                                                            ], xValueMapper: (ChartData data, _) => data.x, yValueMapper: (ChartData data, _) => data.y, dataLabelSettings: const DataLabelSettings(isVisible: true, showCumulativeValues: true, labelPosition: ChartDataLabelPosition.inside, color: AppColors.graphLightPurple)
                                                                                // Starting angle of doughnut
                                                                                ),
                                                                          ]),
                                                                    ),
                                                                  ),
                                                                  const GraphDetailsWidget(
                                                                    firstTitle:
                                                                        "Planned",
                                                                    firstColor:
                                                                        AppColors
                                                                            .graphPurple,
                                                                    secondTitle:
                                                                        "Special",
                                                                    secondColor:
                                                                        AppColors
                                                                            .graphLightPurple,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            TimeGauge(
                                                              timeGauge:
                                                                  dashboardResponseData
                                                                      .data![0]
                                                                      .mykpi!
                                                                      .specialTime!,
                                                              timeValue:
                                                                  dashboardResponseData
                                                                      .data![0]
                                                                      .myKpiHr!
                                                                      .specialHours!,
                                                            ),
                                                          ],
                                                        )),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Expanded(
                                                            child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Card(
                                                              child: Column(
                                                                children: [
                                                                  const Text(
                                                                      "Activities"),
                                                                  ColumnGraphWidget(
                                                                    firstColor:
                                                                        AppColors
                                                                            .graphPurple,
                                                                    firstChartData: [
                                                                      ChartData(
                                                                          "CheckIn",
                                                                          dashboardResponseData
                                                                              .data![0]
                                                                              .mykpi!
                                                                              .checkins!)
                                                                    ],
                                                                    secondColor:
                                                                        AppColors
                                                                            .graphLightPurple,
                                                                    secondChartData: [],
                                                                  ),
                                                                  const GraphDetailsWidget(
                                                                    firstTitle:
                                                                        "Check-ins",
                                                                    firstColor:
                                                                        AppColors
                                                                            .graphPurple,
                                                                    secondTitle:
                                                                        "",
                                                                    secondColor:
                                                                        AppColors
                                                                            .lightgray_2,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            TimeGauge(
                                                              timeGauge:
                                                                  dashboardResponseData
                                                                      .data![0]
                                                                      .mykpi!
                                                                      .checkinTime!,
                                                              timeValue:
                                                                  dashboardResponseData
                                                                      .data![0]
                                                                      .myKpiHr!
                                                                      .checkInHours!,
                                                            ),
                                                          ],
                                                        )),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        Expanded(
                                                          child: MainDashboardItemCard(
                                                              onTap: () {
                                                                if (isCheckedIn) {
                                                                  showToastMessageBottom(
                                                                      false,
                                                                      "Please check out first and try again");
                                                                } else {
                                                                  Navigator.of(
                                                                          context)
                                                                      .push(MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              const MyJourneyPlanScreenNew()));
                                                                }
                                                              },
                                                              imageUrl:
                                                                  // "assets/dashboard/my_journey_plan.png",
                                                                  "assets/myicons/jp.png",
                                                              cardName: "Jp"),
                                                        ),
                                                        Expanded(
                                                          child: MainDashboardItemCard(
                                                              onTap: () {
                                                                if (isCheckedIn) {
                                                                  showToastMessageBottom(
                                                                      false,
                                                                      "Please check out first and try again");
                                                                } else {
                                                                  Navigator.of(
                                                                          context)
                                                                      .push(MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              const MyCoveragePlanScreenNew()));
                                                                }
                                                                // showToastMessage(false,"Coming Soon...");
                                                              },
                                                              imageUrl:
                                                                  // "assets/dashboard/my_coverage.png"
                                                                  "assets/myicons/coverage.png",
                                                              cardName: "Coverage"),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        Expanded(
                                                            child: Column(
                                                          children: [
                                                            Text(isCheckedIn
                                                                ? checkInTime !=
                                                                        ""
                                                                    ? DateFormat
                                                                            .jm()
                                                                        .format(
                                                                            DateTime.parse(checkInTime))
                                                                    : ""
                                                                : ""),
                                                            CheckInButton(
                                                                isCheckedIn:
                                                                    isCheckedIn,
                                                                isLoading2:
                                                                    isLoading2,
                                                                onTap: () {
                                                                  _getCurrentPosition(
                                                                      true);
                                                                }),
                                                          ],
                                                        )),
                                                        Expanded(
                                                            child: Column(
                                                          children: [
                                                            Text(!isCheckedIn
                                                                ? checkOutTime !=
                                                                        ""
                                                                    ? DateFormat
                                                                            .jm()
                                                                        .format(
                                                                            DateTime.parse(checkOutTime))
                                                                    : ""
                                                                : ""),
                                                            CheckOutButton(
                                                                isCheckedIn:
                                                                    isCheckedIn,
                                                                isLoading2:
                                                                    isLoading2,
                                                                onTap: () {
                                                                  _getCurrentPosition(
                                                                      true);
                                                                }),
                                                          ],
                                                        )),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        if (_selectedTab == 1)
                                          Expanded(
                                            child: SingleChildScrollView(
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              child: ContainerBackground(
                                                childWidget: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // const Text("My Team KPIs",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: AppColors.primaryColor),),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                            child: CircularPercentIndicatorWidget(
                                                                title:
                                                                    "Attendance",
                                                                imageStringIcon:
                                                                    "assets/myicons/attendance_graph_icon.png",
                                                                percentColor:
                                                                    AppColors
                                                                        .graphPurple,
                                                                percentText: dashboardResponseData
                                                                            .data![
                                                                                0]
                                                                            .teamkpi!
                                                                            .totalUsers! ==
                                                                        0
                                                                    ? 0.0
                                                                    : double.parse((dashboardResponseData.data![0].teamkpi!.totalPresent! /
                                                                            dashboardResponseData.data![0].teamkpi!.totalUsers!)
                                                                        .toString()),
                                                              )),
                                                        Expanded(
                                                            child: CircularPercentIndicatorWidget(
                                                                title: "JPC",
                                                                imageStringIcon:
                                                                    "assets/myicons/jpc_graph_icon.png",
                                                                percentColor:
                                                                    AppColors
                                                                        .graphPurple,
                                                                percentText: dashboardResponseData
                                                                        .data![
                                                                            0]
                                                                        .teamkpi!
                                                                        .totalJpc! /
                                                                    100)),
                                                        Expanded(
                                                          // issue lies here
                                                         // need to deside log
                                                            child: CircularProdectivityIndicatorWidget(
                                                                title:
                                                                    "Productivity",
                                                                imageStringIcon:
                                                                    "assets/myicons/productivity_graph_icon.png",
                                                                percentColor:
                                                                    AppColors
                                                                        .graphPurple,
                                                                percentText: dashboardResponseData.data![0].teamkpi!.totalProductivity! >= 100?100/100 : dashboardResponseData.data![0].teamkpi!.totalProductivity!/ 100,
                                                                centerText:  dashboardResponseData.data![0].teamkpi!.totalProductivity!,

                                                              )),
                                                      ],
                                                    ),
                                                    FullEfficiencyBar(
                                                      percentValue:
                                                          dashboardResponseData
                                                              .data![0]
                                                              .teamkpi!
                                                              .totalEffeciency!,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child:
                                                              MainDashboardItemCard(
                                                                  onTap: () {
                                                                    if (isCheckedIn) {
                                                                      showToastMessageBottom(
                                                                          false,
                                                                          "Please check out first and try again");
                                                                    } else {
                                                                      Navigator.of(
                                                                              context)
                                                                          .push(
                                                                              MaterialPageRoute(builder: (context) => const TeamAttendence()));
                                                                    }
                                                                    // showToastMessage(false,"Coming Soon...");
                                                                  },
                                                                  imageUrl:
                                                                      "assets/myicons/attendance.png",
                                                                  cardName:
                                                                      "Attendance"),
                                                        ),
                                                        Expanded(
                                                          child: MainDashboardItemCard(
                                                              onTap: () {
                                                                if (isCheckedIn) {
                                                                  showToastMessageBottom(
                                                                      false,
                                                                      "Please check out first and try again");
                                                                } else {
                                                                  Navigator.of(
                                                                          context)
                                                                      .push(MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              const VisitHistory()));
                                                                }

                                                                // showToastMessage(false,"Coming Soon...");
                                                              },
                                                              imageUrl:
                                                                  // "assets/dashboard/my_coverage.png"
                                                                  "assets/myicons/visithistory.png",
                                                              cardName: "Visits History"),
                                                        )
                                                      ],
                                                    ),

                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: MainDashboardItemCard(
                                                              onTap: () {
                                                                if (isCheckedIn) {
                                                                  showToastMessageBottom(
                                                                      false,
                                                                      "Please check out first and try again");
                                                                } else {
                                                                  Navigator.of(
                                                                          context)
                                                                      .push(MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              const TeamKpiScreen()));
                                                                }
                                                                // showToastMessage(false,"Coming Soon...");
                                                              },
                                                              imageUrl:
                                                                  // "assets/dashboard/my_coverage.png"
                                                                  "assets/myicons/teamkpi.png",
                                                              cardName: "KPIS"),
                                                        ),
                                                        Expanded(
                                                          child: MainDashboardItemCard(
                                                              onTap: () {
                                                                if (isCheckedIn) {
                                                                  showToastMessageBottom(
                                                                      false,
                                                                      "Please check out first and try again");
                                                                } else {
                                                                  Navigator.of(
                                                                          context)
                                                                      .push(MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              const SpecialVisitScreen()));
                                                                }
                                                                // showToastMessage(false,"Coming Soon...");
                                                              },
                                                              imageUrl:
                                                                  // "assets/dashboard/my_coverage.png"
                                                                  "assets/myicons/specialvisit.png",
                                                              cardName: "Special Visits"),
                                                        )
                                                      ],
                                                    ),

                                                    // InkWell(
                                                    //   onTap: () {
                                                    //     if (isCheckedIn) {
                                                    //       showToastMessage(false,
                                                    //           "Please check out first and try again");
                                                    //     } else {
                                                    //       Navigator.of(context).push(
                                                    //           MaterialPageRoute(
                                                    //               builder: (context) =>
                                                    //               const AttendenceHome()));
                                                    //     }
                                                    //     // showToastMessage(false,"Coming Soon...");
                                                    //   },
                                                    //   child: Card(
                                                    //     child: Container(
                                                    //       margin: const EdgeInsets.symmetric(vertical: 10),
                                                    //       padding: const EdgeInsets.all(5),
                                                    //       child: Row(
                                                    //         crossAxisAlignment: CrossAxisAlignment.center,
                                                    //         mainAxisAlignment: MainAxisAlignment.center,
                                                    //         children: [
                                                    //           Image.asset("assets/myicons/my_team_graph_icon.png",width: 23,height: 23,),
                                                    //           const SizedBox(width:15),
                                                    //           const Text("My Team",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400),)
                                                    //         ],
                                                    //       ),
                                                    //     ),
                                                    //   ),
                                                    // )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        if (_selectedTab == 2)
                                          Expanded(
                                            child: ContainerBackground(
                                              childWidget: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: MainDashboardItemCard(
                                                            onTap: () {
                                                              if (isCheckedIn) {
                                                                showToastMessageBottom(
                                                                    false,
                                                                    "Please check out first and try again");
                                                              } else {
                                                                Navigator.of(
                                                                        context)
                                                                    .push(MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                const KnowledgeShare()));
                                                              }
                                                              // showToastMessage(false,"Coming Soon...");
                                                            },
                                                            imageUrl:
                                                                // "assets/dashboard/my_coverage.png"
                                                                "assets/myicons/knowledge.png",
                                                            cardName: "Knowledge Share"),
                                                      ),
                                                      Expanded(
                                                        child: MainDashboardItemCard(
                                                            onTap: () {
                                                              if (isCheckedIn) {
                                                                showToastMessageBottom(
                                                                    false,
                                                                    "Please check out first and try again");
                                                              } else {
                                                                Navigator.of(
                                                                        context)
                                                                    .push(MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                const ClientScreen()));
                                                              }
                                                              // showToastMessage(false,"Coming Soon...");
                                                            },
                                                            imageUrl:
                                                                // "assets/dashboard/my_coverage.png"
                                                                "assets/myicons/client.png",
                                                            cardName: "Clients"),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: MainDashboardItemCard(
                                                            onTap: () {
                                                              if (isCheckedIn) {
                                                                showToastMessageBottom(
                                                                    false,
                                                                    "Please check out first and try again");
                                                              } else {
                                                                Navigator.of(
                                                                        context)
                                                                    .push(MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                const RecruitSuggestScreen()));
                                                              }
                                                              // showToastMessage(false,"Coming Soon...");
                                                            },
                                                            imageUrl:
                                                                // "assets/dashboard/my_coverage.png"
                                                                "assets/myicons/recruit_suggest.png",
                                                            cardName: "Recruit Suggest"),
                                                      ),
                                                      Expanded(
                                                        child: MainDashboardItemCard(
                                                            onTap: () {
                                                              if (isCheckedIn) {
                                                                showToastMessageBottom(
                                                                    false,
                                                                    "Please check out first and try again");
                                                              } else {
                                                                Navigator.of(
                                                                        context)
                                                                    .push(MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                const BusinessTripsScreen()));
                                                              }
                                                              // showToastMessage(false,"Coming Soon...");
                                                            },
                                                            imageUrl:
                                                                // "assets/dashboard/my_coverage.png"
                                                                "assets/myicons/business_trip.png",
                                                            cardName: "Business Trips"),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: MainDashboardItemCard(
                                                            onTap: () {
                                                              if (isCheckedIn) {
                                                                showToastMessageBottom(
                                                                    false,
                                                                    "Please check out first and try again");
                                                              } else {
                                                                Navigator.of(
                                                                        context)
                                                                    .push(MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                const TimeMotionScreen()));
                                                              }
                                                              // showToastMessage(false,"Coming Soon...");
                                                            },
                                                            imageUrl:
                                                                // "assets/dashboard/my_coverage.png"
                                                                "assets/myicons/time_motion.png",
                                                            cardName: "Time Motion Study"),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        if (isLoading2)
                                          const Center(
                                            child: CircularProgressIndicator(
                                              color: AppColors.primaryColor,
                                            ),
                                          )
                                      ],
                                    ),
                                  ),
                                ],
                              ))
              ])),
        ),
      ),
    );
  }

  Future<void> _getCurrentPosition(bool isAllow) async {
    final hasPermission = await handleLocationPermission();
    if (!hasPermission) return;
    if (isAllow) {
      setState(() {
        isLoading2 = true;
      });
    }
    await location.Geolocator.getCurrentPosition()
        .then((location.Position position) async {
      setState(() => _currentPosition = position);

      print("Current Position");
      print(_currentPosition);
      print(ipcLocation.length);

      //  double distanceInKm1 = await calculateDistance(ipcLocation[0].gps!,_currentPosition);
      // double distanceInKm2 = await calculateDistance(ipcLocation[1].gps!,_currentPosition);
      // double distanceInKm3 = await calculateDistance(ipcLocation[2].gps!,_currentPosition);

      String currentPosition =
          "${_currentPosition!.latitude},${_currentPosition!.longitude}";

      // if(distanceInKm1<1.2 || distanceInKm2<1.2 || distanceInKm3<1.2) {
      if (isAllow) {
        if (isCheckedIn) {
          checkOutUser(currentPosition);
        } else {
          pickedImage();
          // }
        }
      } else {
        saveUserCurrentLocation(currentPosition);
      }
      //   else {
      //   showToastMessage(false, "You are away from Store. please Go to store and start visit.");
      // }
      // pickedImage(journeyResponseListItem,_currentPosition,index);

      // print("Loaction distance");
      // print(distanceInKm1);
      // print(distanceInKm2);
      // print(distanceInKm3);
      setState(() {
        isLoading2 = false;
      });
    }).catchError((e) {
      print(e);
    });
  }

  Future<void> pickedImage() async {
    image = await picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        imageQuality: ImageValue.qualityValue);
    if (image == null) {
    } else {
      compressedImage = await compressAndGetFile(image!);

      showUploadOption();
    }
  }

  showUploadOption() {
    String currentPosition =
        "${_currentPosition!.latitude},${_currentPosition!.longitude}";
    showPopUpForImageUploadForComment(context, compressedImage!, () {
      // print(currentPosition);
      if (compressedImage != null && currentPosition != "") {
        checkInUser(currentPosition);
      }
    }, commentController);
  }

  checkInUser(String currentPosition) async {
    setState(() {
      isLoading2 = true;
    });
    await ImageToCloud()
        .uploadImageToCloud(compressedImage!, userId, "capture_photo",
            LicenseProvider.bucketName)
        .then(
      (imageName) {
        HTTPManager()
            .setCheckIn(
          CheckInStatusUpdateRequestModel(
              elId: userId,
              comment: commentController.text,
              checkInGps: currentPosition,
              photoName: imageName),
          // compressedImage!
        )
            .then((value) async {
          SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
          setState(() {
            checkInTime = value['data'][0]['checkin_time'];
            checkInId = value['data'][0]['id'].toString();
            isCheckedIn = true;
            sharedPreferences.setString(UserConstants().checkInId, checkInId!);
            commentController.clear();

            isLoading2 = false;
          });
          showToastMessageBottom(true, "Checked In Successfully");
          Navigator.of(context).pop();
        }).catchError((e) {
          setState(() {
            print(e.toString());
            showToastMessageBottom(false, e.toString());
            isLoading2 = false;
          });
        });
      },
    );
  }

  checkOutUser(String currentPosition) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? id1;
    setState(() {
      isLoading2 = true;
      id1 = sharedPreferences.getString(UserConstants().checkInId)!;
    });

    print(id1);

    HTTPManager()
        .setCheckOut(CheckOutStatusUpdateRequestModel(
            id: checkInId, elId: userId, checkOutGps: currentPosition))
        .then((value) {
      setState(() {
        isCheckedIn = false;
        checkOutTime = value['data']['checkout_time'];

        // checkListItemStatus[0] = checkInStatusDetailsItem;
        // sharedPreferences.setString(UserConstants().checkInId, checkListItem[0].id.toString());
        isLoading2 = false;
      });
      showToastMessageBottom(true, "Checked Out Successfully");
      // Navigator.of(context).pop();
    }).catchError((e) {
      setState(() {
        print(e.toString());
        showToastMessageBottom(false, e.toString());
        isLoading2 = false;
      });
    });
  }
}
