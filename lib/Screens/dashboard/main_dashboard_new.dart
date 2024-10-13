// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:c_supervisor/Model/request_model/save_user_location_request.dart';
import 'package:c_supervisor/Network/http_manager.dart';
import 'package:c_supervisor/Screens/utills/image_to_cloud.dart';
import 'package:c_supervisor/Screens/attendence/attendence_home.dart';
import 'package:c_supervisor/Screens/clients/client_screen.dart';
import 'package:c_supervisor/Screens/dashboard/widgets/main_dashboard_card_item.dart';
import 'package:c_supervisor/Screens/knowledge/knowledge_share.dart';
import 'package:c_supervisor/Screens/recruite_suggest/recruit_suggest_screen.dart';
import 'package:c_supervisor/Screens/time_motion/time_motion_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

import 'package:image_picker/image_picker.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Model/request_model/check_in_status_request.dart';
import '../../Model/response_model/check_in_response/check_in_response.dart';
import '../../Model/response_model/check_in_response/check_in_status_response.dart';
import '../../Model/response_model/check_in_response/check_in_status_response_details.dart';
import '../../provider/license_provider.dart';
import '../buisness_trips/business_trips_screen.dart';
import '../my_coverage/my_coverage_plan_screen.dart';
import '../my_jp/my_journey_plan_screen.dart';
import '../utills/app_colors_new.dart';
import '../utills/image_compressed_functions.dart';
import '../utills/image_quality.dart';
import '../utills/location_permission_handle.dart';
import '../utills/user_constants.dart';
import '../utills/vpn_detector_handler.dart';
import '../widgets/alert_dialogues.dart';
import '../widgets/error_text_and_button.dart';
import '../widgets/header_background_new.dart';
import '../widgets/header_widgets_new.dart';
import '../widgets/toast_message_show.dart';
import 'package:intl/intl.dart';

import 'package:device_info_plus/device_info_plus.dart';

class MainDashboardNew extends StatefulWidget {
  const MainDashboardNew({Key? key}) : super(key: key);

  @override
  State<MainDashboardNew> createState() => _MainDashboardNewState();
}

class _MainDashboardNewState extends State<MainDashboardNew> {
  String userName = "";
  String userId = "";
  int backgroundService = 0 ;
  ImagePicker picker = ImagePicker();
  XFile? image;
  XFile? compressedImage;
  Position? _currentPosition;

  bool isLoading1 = false;
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

  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  List<CheckInStatusItem> checkListItem = <CheckInStatusItem>[];
  List<CheckInStatusDetailsItem> checkListItemStatus =
      <CheckInStatusDetailsItem>[];

  TextEditingController commentController = TextEditingController();

  List<IpcLocationResponseItem> ipcLocation = <IpcLocationResponseItem>[];

  @override
  void initState() {
    getUserData();
    updateAvailable();
   // checkUpdate();
    // getIpcLocations();
    checkVpnDetector();

    super.initState();
  }

  // Map<String, dynamic> _readLinuxDeviceInfo(LinuxDeviceInfo data) {
  //   return <String, dynamic>{
  //     'name': data.name,
  //     'version': data.version,
  //     'id': data.id,
  //     'idLike': data.idLike,
  //     'versionCodename': data.versionCodename,
  //     'versionId': data.versionId,
  //     'prettyName': data.prettyName,
  //     'buildId': data.buildId,
  //     'variant': data.variant,
  //     'variantId': data.variantId,
  //     'machineId': data.machineId,
  //   };
  // }
  //
  // Map<String, dynamic> _readWebBrowserInfo(WebBrowserInfo data) {
  //   return <String, dynamic>{
  //     'browserName': describeEnum(data.browserName),
  //     'appCodeName': data.appCodeName,
  //     'appName': data.appName,
  //     'appVersion': data.appVersion,
  //     'deviceMemory': data.deviceMemory,
  //     'language': data.language,
  //     'languages': data.languages,
  //     'platform': data.platform,
  //     'product': data.product,
  //     'productSub': data.productSub,
  //     'userAgent': data.userAgent,
  //     'vendor': data.vendor,
  //     'vendorSub': data.vendorSub,
  //     'hardwareConcurrency': data.hardwareConcurrency,
  //     'maxTouchPoints': data.maxTouchPoints,
  //   };
  // }
  //
  // Map<String, dynamic> _readMacOsDeviceInfo(MacOsDeviceInfo data) {
  //   return <String, dynamic>{
  //     'computerName': data.computerName,
  //     'hostName': data.hostName,
  //     'arch': data.arch,
  //     'model': data.model,
  //     'kernelVersion': data.kernelVersion,
  //     'majorVersion': data.majorVersion,
  //     'minorVersion': data.minorVersion,
  //     'patchVersion': data.patchVersion,
  //     'osRelease': data.osRelease,
  //     'activeCPUs': data.activeCPUs,
  //     'memorySize': data.memorySize,
  //     'cpuFrequency': data.cpuFrequency,
  //     'systemGUID': data.systemGUID,
  //   };
  // }
  //
  // Map<String, dynamic> _readWindowsDeviceInfo(WindowsDeviceInfo data) {
  //   return <String, dynamic>{
  //     'numberOfCores': data.numberOfCores,
  //     'computerName': data.computerName,
  //     'systemMemoryInMegabytes': data.systemMemoryInMegabytes,
  //     'userName': data.userName,
  //     'majorVersion': data.majorVersion,
  //     'minorVersion': data.minorVersion,
  //     'buildNumber': data.buildNumber,
  //     'platformId': data.platformId,
  //     'csdVersion': data.csdVersion,
  //     'servicePackMajor': data.servicePackMajor,
  //     'servicePackMinor': data.servicePackMinor,
  //     'suitMask': data.suitMask,
  //     'productType': data.productType,
  //     'reserved': data.reserved,
  //     'buildLab': data.buildLab,
  //     'buildLabEx': data.buildLabEx,
  //     'digitalProductId': data.digitalProductId,
  //     'displayVersion': data.displayVersion,
  //     'editionId': data.editionId,
  //     'installDate': data.installDate,
  //     'productId': data.productId,
  //     'productName': data.productName,
  //     'registeredOwner': data.registeredOwner,
  //     'releaseId': data.releaseId,
  //     'deviceId': data.deviceId,
  //   };
  // }

  updateAvailable() {
    // Instantiate NewVersion manager object (Using GCP Console app as example)
   //com.catalist.csupervisor
    final newVersion = NewVersionPlus(
      iOSId: 'com.catalist.csupervisor',
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

  // basicStatusCheck(NewVersionPlus newVersion) async {
  //   final version = await newVersion.getVersionStatus();
  //   if (version != null) {
  //     release = version.releaseNotes ?? "";
  //     setState(() {});
  //   }
  //   newVersion.showAlertIfNecessary(
  //     context: context,
  //     launchModeVersion: LaunchModeVersion.external,
  //   );
  // }

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

  // checkUpdate() async {
  //   try {
  //     final newVersion = NewVersion(
  //       iOSId: 'com.cStoreSltc.cStoreStkkc',
  //       androidId: 'com.catalist.csupervisor',
  //     );

  //     final status = await newVersion.getVersionStatus();
  //     if (status != null) {
  //       if (status.canUpdate)
  //         newVersion.showUpdateDialog(
  //           allowDismissal: false,
  //           context: context,
  //           versionStatus: status,
  //           dialogTitle: 'Update',
  //           dialogText:
  //               'Please update your app to ${status.storeVersion} version',
  //         );
  //     }
  //   } catch (error) {
  //     print(error);
  //   }
  // }

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
    //  this is left for api change
    if(backgroundService== 1 || backgroundService == 1.0)
    {Timer.periodic(
        const Duration(minutes: 15), (Timer t) => _getCurrentPosition(false));}
    else
      print("no background services");
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

  // getIpcLocations() {
  //   setState(() {
  //     isLoading = true;
  //   });
  //
  //   HTTPManager().getIPCLocation().then((value) {
  //     setState(() {
  //       ipcLocation = value.data!;
  //
  //       isLoading = false;
  //       isError = false;
  //     });
  //   }).catchError((e) {
  //     setState(() {
  //       print(e.toString());
  //       isLoading = false;
  //       isError = true;
  //       errorText = e.toString();
  //     });
  //   });
  // }

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
            ignoring: isLoading2,
            child: HeaderBackgroundNew(
              childWidgets: [
                HeaderWidgetsNew(
                    pageTitle: "Welcome $userName",
                    isBackButton: false,
                    isDrawerButton: true),
                Expanded(
                  child: isLoading1
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
                              },
                              errorText: errorText)
                          : Stack(
                              children: [
                                GridView(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: (163.5 / 135),
                                    crossAxisCount: 2,
                                  ),
                                  children: [
                                    MainDashboardItemCard(
                                        onTap: () {
                                          if (isCheckedIn) {
                                            showToastMessageBottom(false,
                                                "Please check out first and try again");
                                          } else {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const MyJourneyPlanScreenNew()));
                                          }
                                        },
                                        imageUrl:
                                            // "assets/dashboard/my_journey_plan.png",
                                            "assets/myicons/jp.png",
                                        cardName: "My Jp"),
                                    MainDashboardItemCard(
                                        onTap: () {
                                          if (isCheckedIn) {
                                            showToastMessageBottom(false,
                                                "Please check out first and try again");
                                          } else {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const MyCoveragePlanScreenNew()));
                                          }
                                          // showToastMessage(false,"Coming Soon...");
                                        },
                                        imageUrl:
                                            // "assets/dashboard/my_coverage.png"
                                            "assets/myicons/coverage.png",
                                        cardName: "My Coverage"),
                                    MainDashboardItemCard(
                                        onTap: () {
                                          if (isCheckedIn) {
                                            showToastMessageBottom(false,
                                                "Please check out first and try again");
                                          } else {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const AttendenceHome()));
                                          }
                                          // showToastMessage(false,"Coming Soon...");
                                        },
                                        imageUrl:
                                            // "assets/dashboard/my_coverage.png"
                                            "assets/myicons/team.png",
                                        cardName: "My Team"),
                                    MainDashboardItemCard(
                                        onTap: () {
                                          if (isCheckedIn) {
                                            showToastMessageBottom(false,
                                                "Please check out first and try again");
                                          } else {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const KnowledgeShare()));
                                          }
                                          // showToastMessage(false,"Coming Soon...");
                                        },
                                        imageUrl:
                                            // "assets/dashboard/my_coverage.png"
                                            "assets/myicons/knowledge.png",
                                        cardName: "Knowledge Share"),
                                    MainDashboardItemCard(
                                        onTap: () {
                                          if (isCheckedIn) {
                                            showToastMessageBottom(false,
                                                "Please check out first and try again");
                                          } else {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const ClientScreen()));
                                          }
                                          // showToastMessage(false,"Coming Soon...");
                                        },
                                        imageUrl:
                                            // "assets/dashboard/my_coverage.png"
                                            "assets/myicons/client.png",
                                        cardName: "Clients"),
                                    MainDashboardItemCard(
                                        onTap: () {
                                          if (isCheckedIn) {
                                            showToastMessageBottom(false,
                                                "Please check out first and try again");
                                          } else {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const RecruitSuggestScreen()));
                                          }
                                          // showToastMessage(false,"Coming Soon...");
                                        },
                                        imageUrl:
                                            // "assets/dashboard/my_coverage.png"
                                            "assets/myicons/recruit_suggest.png",
                                        cardName: "Recruit Suggest"),
                                    MainDashboardItemCard(
                                        onTap: () {
                                          if (isCheckedIn) {
                                            showToastMessageBottom(false,
                                                "Please check out first and try again");
                                          } else {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const BusinessTripsScreen()));
                                          }
                                          // showToastMessage(false,"Coming Soon...");
                                        },
                                        imageUrl:
                                            // "assets/dashboard/my_coverage.png"
                                            "assets/myicons/business_trip.png",
                                        cardName: "Business Trips"),
                                    MainDashboardItemCard(
                                        onTap: () {
                                          if (isCheckedIn) {
                                            showToastMessageBottom(false,
                                                "Please check out first and try again");
                                          } else {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const TimeMotionScreen()));
                                          }
                                          // showToastMessage(false,"Coming Soon...");
                                        },
                                        imageUrl:
                                            // "assets/dashboard/my_coverage.png"
                                            "assets/myicons/time_motion.png",
                                        cardName: "Time Motion Study"),

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
                                if (isLoading2)
                                  const Center(
                                    child: CircularProgressIndicator(
                                      color: AppColors.primaryColor,
                                    ),
                                  )
                              ],
                            ),
                ),
                isLoading1
                    ? Container()
                    : Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(isCheckedIn
                                    ? checkInTime != ""
                                        ? DateFormat.jm()
                                            .format(DateTime.parse(checkInTime))
                                        : ""
                                    : ""),
                                InkWell(
                                  onTap: () {
                                    if (!isCheckedIn) {
                                      _getCurrentPosition(true);
                                    } else {
                                      showToastMessageBottom(
                                          false, "You need to Check out first");
                                    }
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 10),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        gradient: !isCheckedIn
                                            ? isLoading2
                                                ? const LinearGradient(
                                                    colors: [
                                                      AppColors.greyColor,
                                                      AppColors.greyColor,
                                                    ],
                                                  )
                                                : const LinearGradient(
                                                    colors: [
                                                      Color(0xFF0F408D),
                                                      Color(0xFF6A82A9),
                                                    ],
                                                  )
                                            : const LinearGradient(
                                                colors: [
                                                  Color(0xFFFFFFFF),
                                                  Color(0xFFFFFFFF),
                                                ],
                                              ),
                                        border: Border.all(
                                            color: AppColors.primaryColor),
                                        borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            topLeft: Radius.circular(10))),
                                    child: Text(
                                      "Check In",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: !isCheckedIn
                                              ? AppColors.white
                                              : AppColors.greyColor),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(!isCheckedIn
                                    ? checkOutTime != ""
                                        ? DateFormat.jm().format(
                                            DateTime.parse(checkOutTime))
                                        : ""
                                    : ""),
                                InkWell(
                                  onTap: () {
                                    if (isCheckedIn) {
                                      _getCurrentPosition(true);
                                    } else {
                                      showToastMessageBottom(
                                          false, "You need to Check In first");
                                    }
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 10),
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AppColors.primaryColor),
                                        gradient: isCheckedIn
                                            ? isLoading2
                                                ? const LinearGradient(
                                                    colors: [
                                                      AppColors.greyColor,
                                                      AppColors.greyColor,
                                                    ],
                                                  )
                                                : const LinearGradient(
                                                    colors: [
                                                      Color(0xFF0F408D),
                                                      Color(0xFF6A82A9),
                                                    ],
                                                  )
                                            : const LinearGradient(
                                                colors: [
                                                  Color(0xFFFFFFFF),
                                                  Color(0xFFFFFFFF),
                                                ],
                                              ),
                                        borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            topLeft: Radius.circular(10))),
                                    child: Text(
                                      "Check Out",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: isCheckedIn
                                              ? AppColors.white
                                              : AppColors.greyColor),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
              ],
            ),
          )),
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
    await Geolocator.getCurrentPosition().then((Position position) async {
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
    print("it is not correct");
    image = await picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        imageQuality: ImageValue.qualityValue);
    if (image == null) {
    } else {
      print("Image Path");
      print(image!.path);
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

    ImageToCloud()
        .uploadImageToCloud(compressedImage!, userId, "capture_photo",
            LicenseProvider.bucketName)
        .then((imageName) {
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
        print("Checkin Reponse");
        print(value);
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
    });
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
