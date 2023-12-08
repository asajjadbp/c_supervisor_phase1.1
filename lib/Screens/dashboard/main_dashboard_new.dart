import 'dart:io';

import 'package:c_supervisor/Network/http_manager.dart';
import 'package:c_supervisor/Screens/dashboard/widgets/main_dashboard_card_item.dart';
import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Model/request_model/check_in_status_request.dart';
import '../../Model/response_model/check_in_response/check_in_response.dart';
import '../../Model/response_model/check_in_response/check_in_status_response.dart';
import '../my_coverage/my_coverage_plan_screen.dart';
import '../my_jp/my_journey_plan_screen.dart';
import '../utills/app_colors_new.dart';
import '../utills/image_compressed_functions.dart';
import '../utills/location_calculation.dart';
import '../utills/location_permission_handle.dart';
import '../utills/user_constants.dart';
import '../widgets/alert_dialogues.dart';
import '../widgets/error_text_and_button.dart';
import '../widgets/header_background_new.dart';
import '../widgets/header_widgets_new.dart';
import '../widgets/large_button_in_footer.dart';
import '../widgets/toast_message_show.dart';

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

  List<CheckInStatusItem> checkListItem = <CheckInStatusItem>[];

  TextEditingController commentController = TextEditingController();

  List<IpcLocationResponseItem> ipcLocation= <IpcLocationResponseItem>[];

  @override
  void initState() {
    getUserData();
    getIpcLocations();
    super.initState();
  }

  getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      userName = sharedPreferences.getString(UserConstants().userName)!;
      userId = sharedPreferences.getString(UserConstants().userId)!;
    });
    getCheckInStatus();
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
        isCheckedIn = value['data'][0]['checked_in'];
        isLoading1 = false;
        isError = false;
      });
    }).catchError((e) {
      setState(() {
        print(e.toString());
        isLoading1 = false;
        isError = true;
        errorText1 = e.toString();
      });
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
                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const MyJourneyPlanScreenNew()));
                          },imageUrl: "assets/dashboard/my_journey_plan.png", cardName: "My Jp"),
                      MainDashboardItemCard(onTap:(){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const MyCoveragePlanScreenNew()));
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
                        const Center(child: CircularProgressIndicator(),)
                    ],
                  ),
            ),
            if(!isLoading || !isLoading1)
            LargeButtonInFooter(buttonTitle:isCheckedIn ? "Check Out" : "Check In", onTap: (){
              _getCurrentPosition();
            },)

          ],
        )
      ),
    );
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition()
        .then((Position position) async {
      setState(() => _currentPosition = position);

      print("Current Position");
      print(_currentPosition);
      print(ipcLocation.length);

       double distanceInKm1 = await calculateDistance(ipcLocation[0].gps!,_currentPosition);
      double distanceInKm2 = await calculateDistance(ipcLocation[1].gps!,_currentPosition);
      double distanceInKm3 = await calculateDistance(ipcLocation[2].gps!,_currentPosition);

      if(distanceInKm1<1.2 || distanceInKm2<1.2 || distanceInKm3<1.2) {
        if(isCheckedIn) {
          String currentPosition = "${_currentPosition!.latitude},${_currentPosition!.longitude}";
          checkOutUser(currentPosition);
        } else {
          pickedImage();
        }

      } else {
        showToastMessage(false, "You are away from Store. please Go to store and start visit.");
      }
      // pickedImage(journeyResponseListItem,_currentPosition,index);

      print("Loaction distance");
      print(distanceInKm1);
      print(distanceInKm2);
      print(distanceInKm3);

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
    showPopUpForImageUploadForComment(context, compressedImage!, (){
      String currentPosition = "${_currentPosition!.latitude},${_currentPosition!.longitude}";
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
        checkListItem = value.data!;
        isCheckedIn = true;
        sharedPreferences.setString(UserConstants().checkInId, checkListItem[0].id.toString());
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

    HTTPManager().setCheckOut(CheckOutStatusUpdateRequestModel(id:id1,elId: userId,checkOutGps:currentPosition )).then((value) {

      setState(() {
        isCheckedIn = false;
        // sharedPreferences.setString(UserConstants().checkInId, checkListItem[0].id.toString());
        isLoading2 = false;
      });
      showToastMessage(true, "Checked Out Successfully");
      Navigator.of(context).pop();
    }).catchError((e) {
      setState(() {
        print(e.toString());
        showToastMessage(false, e.toString());
        isLoading2 = false;
      });
    });

  }

}
