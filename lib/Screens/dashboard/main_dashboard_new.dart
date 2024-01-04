// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:c_supervisor/Model/request_model/save_user_location_request.dart';
import 'package:c_supervisor/Network/http_manager.dart';
import 'package:c_supervisor/Screens/dashboard/widgets/main_dashboard_card_item.dart';
import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Model/request_model/check_in_status_request.dart';
import '../../Model/response_model/check_in_response/check_in_response.dart';
import '../../Model/response_model/check_in_response/check_in_status_response.dart';
import '../../Model/response_model/check_in_response/check_in_status_response_details.dart';
import '../my_coverage/my_coverage_plan_screen.dart';
import '../my_jp/my_journey_plan_screen.dart';
import '../utills/app_colors_new.dart';
import '../utills/image_compressed_functions.dart';
import '../utills/location_permission_handle.dart';
import '../utills/user_constants.dart';
import '../utills/vpn_detector_handler.dart';
import '../widgets/alert_dialogues.dart';
import '../widgets/error_text_and_button.dart';
import '../widgets/header_background_new.dart';
import '../widgets/header_widgets_new.dart';
import '../widgets/toast_message_show.dart';
import 'package:intl/intl.dart';

class MainDashboardNew extends StatefulWidget {
  const MainDashboardNew({Key? key}) : super(key: key);

  @override
  State<MainDashboardNew> createState() => _MainDashboardNewState();
}

class _MainDashboardNewState extends State<MainDashboardNew> {

  String userName = "";
  String userId = "";
  ImagePicker picker = ImagePicker();
  XFile? image;
  XFile? compressedImage;
  Position? _currentPosition;

  bool isLoading = true;
  bool isLoading1 = false;
  bool isLoading2 = false;
  bool isError = false;
  String errorText = "";
  String errorText1 = "";

  bool isCheckedIn = false;
  String? checkInId;
  String checkInTime = "";
  String checkOutTime = "";

  Timer? timer;
  bool? isVpnConnected;

  List<CheckInStatusItem> checkListItem = <CheckInStatusItem>[];
  List<CheckInStatusDetailsItem> checkListItemStatus = <CheckInStatusDetailsItem>[];

  TextEditingController commentController = TextEditingController();

  List<IpcLocationResponseItem> ipcLocation= <IpcLocationResponseItem>[];

  @override
  void initState() {
    getUserData();
    getIpcLocations();
    checkVpnDetector();
    super.initState();
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
    });
    getCheckInStatus();
    Timer.periodic(const Duration(minutes: 15), (Timer t) => _getCurrentPosition(false));
  }

  saveUserCurrentLocation(String currentPosition) {
    HTTPManager().saveUserCurrentLocation(SaveUserLocationRequestModel(elId:userId,latLong: currentPosition)).then((value) {
      print(value);
    }).catchError((e) {
      print(e.toString());
    });
  }

  getIpcLocations() {
    setState(() {
      isLoading = true;
    });

    HTTPManager().getIPCLocation().then((value) {
      setState(() {
        ipcLocation = value.data!;

        isLoading = false;
        isError = false;
      });
    }).catchError((e) {
      setState(() {
        print(e.toString());
        isLoading = false;
        isError = true;
        errorText = e.toString();
      });
    });
  }

  getCheckInStatus() {
    setState(() {
      isLoading1 = true;
    });

    HTTPManager().getCheckInStatus(CheckInRequestModel(elId:userId)).then((value) {
      setState(() {
        checkListItemStatus = value.data!;

        print(checkListItemStatus[0].checkoutStatus!);

        if(checkListItemStatus.isNotEmpty) {
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
                    child: const Text('No',style: TextStyle(color: AppColors.primaryColor),),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                      exit(0);
                    },
                    child: const Text('Yes',style: TextStyle(color: AppColors.primaryColor),),
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
               HeaderWidgetsNew(pageTitle: "Welcome $userName",isBackButton: false,isDrawerButton: true),
              Expanded(
                child:isLoading || isLoading1 ? const Center(child: CircularProgressIndicator(color: AppColors.primaryColor,),) : isError ?
                ErrorTextAndButton(onTap: (){
                  getIpcLocations();
                  getCheckInStatus();
                },errorText: errorText)
                    : Stack(
                      children: [
                        GridView(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: (163.5 / 135),
                        crossAxisCount: 2,
                  ),
                  children:  [
                        MainDashboardItemCard(
                            onTap: (){
                              if(isCheckedIn) {
                                showToastMessage(false,"Please check out first and try again");
                              } else {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (
                                        context) => const MyJourneyPlanScreenNew()));
                              }
                            },imageUrl: "assets/dashboard/my_journey_plan.png", cardName: "My Jp"),
                        MainDashboardItemCard(onTap:(){
                          if(isCheckedIn) {
                            showToastMessage(false,"Please check out first and try again");
                          } else {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (
                                    context) => const MyCoveragePlanScreenNew()));
                          }
                          // showToastMessage(false,"Coming Soon...");
                        },imageUrl:"assets/dashboard/my_coverage.png", cardName:"My Coverage"),
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
                        if(isLoading2)
                          const Center(child: CircularProgressIndicator(color: AppColors.primaryColor,),)
                      ],
                    ),
              ),

                isLoading || isLoading1 ? Container() : Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(isCheckedIn ? checkInTime != "" ? DateFormat.jm().format(DateTime.parse(checkInTime)) : "" : ""),
                        InkWell(
                          onTap: () {
                            if(!isCheckedIn) {
                              _getCurrentPosition(true);
                            } else {
                              showToastMessage(false, "You need to Check out first");
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            width: MediaQuery.of(context).size.width,
                            decoration:  BoxDecoration(
                              border: Border.all(color: AppColors.primaryColor),
                                color: !isCheckedIn ? isLoading2? AppColors.lightgreytn : AppColors.primaryColor : AppColors.white,
                                borderRadius: const BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10))
                            ),
                            child:  Text("Check In",style: TextStyle(fontSize:20,color: !isCheckedIn ? AppColors.white : AppColors.greyColor),),
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
                        Text(!isCheckedIn ? checkOutTime != "" ? DateFormat.jm().format(DateTime.parse(checkOutTime)) : "" : ""),
                        InkWell(
                          onTap: () {
                            if(isCheckedIn) {
                              _getCurrentPosition(true);
                            } else {
                              showToastMessage(false, "You need to Check In first");
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                border: Border.all(color: AppColors.primaryColor),
                                color: isCheckedIn ? isLoading2? AppColors.lightgreytn : AppColors.primaryColor : AppColors.white,
                                borderRadius: const BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10))
                            ),
                            child:   Text("Check Out",style: TextStyle(fontSize:20,color:isCheckedIn ? AppColors.white : AppColors.greyColor),),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )

            ],
          ),
        )
      ),
    );
  }

  Future<void> _getCurrentPosition(bool isAllow) async {
    final hasPermission = await handleLocationPermission();
    if (!hasPermission) return;
    if(isAllow) {
    setState(() {
      isLoading2 = true;
    });}
    await Geolocator.getCurrentPosition()
        .then((Position position) async {
      setState(() => _currentPosition = position);

      print("Current Position");
      print(_currentPosition);
      print(ipcLocation.length);

      //  double distanceInKm1 = await calculateDistance(ipcLocation[0].gps!,_currentPosition);
      // double distanceInKm2 = await calculateDistance(ipcLocation[1].gps!,_currentPosition);
      // double distanceInKm3 = await calculateDistance(ipcLocation[2].gps!,_currentPosition);

      String currentPosition = "${_currentPosition!.latitude},${_currentPosition!.longitude}";

      // if(distanceInKm1<1.2 || distanceInKm2<1.2 || distanceInKm3<1.2) {
         if(isAllow) {
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

  Future<void> pickedImage()  async {
    image = await picker.pickImage(source: ImageSource.camera, preferredCameraDevice: CameraDevice.front,);
    if(image == null) {

    } else {
      print("Image Path");
      print(image!.path);
      compressedImage = await compressAndGetFile(image!);
      showUploadOption();
    }
  }

  showUploadOption() {
    String currentPosition = "${_currentPosition!.latitude},${_currentPosition!.longitude}";
    showPopUpForImageUploadForComment(context, compressedImage!, (){
      print(currentPosition);
      if(compressedImage !=null && currentPosition != "") {
          checkInUser(currentPosition);
      }
    },commentController);
  }

  checkInUser(String currentPosition) {
    setState(() {
      isLoading2 = true;
    });

    HTTPManager().setCheckIn(CheckInStatusUpdateRequestModel(elId: userId,comment: commentController.text,checkInGps:currentPosition ), compressedImage!).then((value) async {
      print("Checkin Reponse");
      print(value);
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      setState(() {

        checkInTime = value['data'][0]['checkin_time'];
        checkInId = value['data'][0]['id'].toString();
        isCheckedIn = true;
        sharedPreferences.setString(UserConstants().checkInId, checkInId!);
        commentController.clear();

        isLoading2 = false;
      });
      showToastMessage(true, "Checked In Successfully");
      Navigator.of(context).pop();
    }).catchError((e) {
      setState(() {
        print(e.toString());
        showToastMessage(false, e.toString());
        isLoading2 = false;
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

    HTTPManager().setCheckOut(CheckOutStatusUpdateRequestModel(id:checkInId,elId: userId,checkOutGps:currentPosition)).then((value) {

      setState(() {
        isCheckedIn = false;
        checkOutTime = value['data']['checkout_time'];

        // checkListItemStatus[0] = checkInStatusDetailsItem;
        // sharedPreferences.setString(UserConstants().checkInId, checkListItem[0].id.toString());
        isLoading2 = false;
      });
      showToastMessage(true, "Checked Out Successfully");
      // Navigator.of(context).pop();
    }).catchError((e) {
      setState(() {
        print(e.toString());
        showToastMessage(false, e.toString());
        isLoading2 = false;
      });
    });

  }

}
