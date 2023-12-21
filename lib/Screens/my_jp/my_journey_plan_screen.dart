
// ignore_for_file: avoid_print

import 'package:c_supervisor/Model/request_model/journey_plan_request.dart';
import 'package:c_supervisor/Network/http_manager.dart';
import 'package:c_supervisor/Screens/my_jp/widgets/my_jp_card_for_details.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Model/request_model/start_journey_plan_request.dart';
import '../../Model/response_model/journey_responses_plan/journey_plan_response_list.dart';
import '../utills/app_colors_new.dart';
import '../utills/image_compressed_functions.dart';
import '../utills/location_calculation.dart';
import '../utills/location_permission_handle.dart';
import '../utills/user_constants.dart';
import '../widgets/alert_dialogues.dart';
import '../widgets/error_text_and_button.dart';
import '../widgets/header_background_new.dart';
import '../widgets/header_widgets_new.dart';
import '../widgets/text_fields/search_text_fields.dart';
import '../widgets/toast_message_show.dart';
import 'my_journey_plan_module_new.dart';
import 'package:image_picker/image_picker.dart';

class MyJourneyPlanScreenNew extends StatefulWidget {
  const MyJourneyPlanScreenNew({Key? key}) : super(key: key);

  @override
  State<MyJourneyPlanScreenNew> createState() => _MyJourneyPlanScreenNewState();
}

class _MyJourneyPlanScreenNewState extends State<MyJourneyPlanScreenNew> {

  String userName = "";
  String userId = "";
  int? geoFence;

  bool isLoading = true;
  List<JourneyResponseListItemDetails> journeyList = <JourneyResponseListItemDetails>[];
  List<JourneyResponseListItemDetails> journeySearchList = <JourneyResponseListItemDetails>[];
  bool isError = false;
  String errorText = "";

  ImagePicker picker = ImagePicker();
  XFile? image;
  XFile? compressedImage;
  Position? _currentPosition;
  Position? _currentPositionForList;

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    getUserData();
    getUserCurrentLocation();
    super.initState();
  }

  getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      userName = sharedPreferences.getString(UserConstants().userName)!;
      userId = sharedPreferences.getString(UserConstants().userId)!;
      geoFence = sharedPreferences.getInt(UserConstants().userGeoFence)!;
    });

    getJourneyPlanList(true);
  }

  getUserCurrentLocation() async {
    final hasPermission = await handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition()
        .then((Position position) async {
      setState(() => _currentPositionForList = position);

      print("Current Position");
      print(_currentPositionForList);

    }).catchError((e) {
      print(e);
    });
  }

  calculateDistanceForList(JourneyResponseListItemDetails journeyResponseListItemDetails) {

  }

  getJourneyPlanList(bool isLoader) {
    setState(() {
      isLoading = isLoader;
    });

    HTTPManager().userJourneyPlanList(JourneyPlanRequestModel(elId: userId)).then((value) {
      setState(() {
        journeyList = value.data!.planned!;
        isLoading = false;
        isError = false;
      });

    }).catchError((e){
      setState(() {
        isError = true;
        errorText = e.toString();
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HeaderBackgroundNew(
        childWidgets: [
          const HeaderWidgetsNew(pageTitle: "My JP",isBackButton: true,isDrawerButton: true,),
          SearchTextField(controller: searchController,hintText:'Search With Tmr Name',onChangeField: onSearchTextFieldChanged,),
          Expanded(
            child: isLoading ? const Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor,),
            ) : Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: isError ? ErrorTextAndButton(onTap: (){
                getJourneyPlanList(true);
              },errorText: errorText) : journeyList.isEmpty ? const Center(child: Text("No plans found"),) : searchController.text.isNotEmpty ? ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: journeySearchList.length,
                  itemBuilder: (context,index) {
                    return MyJpCardForDetail(
                      storeName: journeySearchList[index].storeName!,
                      visitStatus: journeySearchList[index].visitStatus!.toString(),
                      tmrName: journeySearchList[index].tmrName.toString(),
                      tmrId: journeySearchList[index].tmrId.toString(),
                      workingDate: journeySearchList[index].workingDate!,
                      buttonName: journeySearchList[index].visitStatus!.toString() == "0" ? "Evaluate" : "Resume Visit",
                      onMapTap: () {
                        // List<String> latLong = journeyList[index].gcode!.split(",");
                        //
                        // Navigator.of(context).push(MaterialPageRoute(builder: (context)=> GoogleMapScreen(currentLat: _currentPositionForList!.latitude.toString(),currentLong: _currentPositionForList!.longitude.toString(),storeLat:latLong[0] ,storeLong: latLong[1],))).then((value) {
                        //   getJourneyPlanList(false);
                        // });
                      },
                      onTap: (){
                        // _getCurrentPosition(journeyList[index],index);
                        if(journeyList[index].visitStatus!.toString() == "0" ) {
                          _getCurrentPosition(journeyList[index],index);
                        } else {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MyJourneyModuleNew(journeyResponseListItem: journeyList[index],))).then((value) {
                            getJourneyPlanList(false);
                          });
                        }
                      },
                    );
                  }
              ) : ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: journeyList.length,
                  itemBuilder: (context,index) {
                    return MyJpCardForDetail(
                      storeName: journeyList[index].storeName!,
                      visitStatus: journeyList[index].visitStatus!.toString(),
                      tmrName: journeyList[index].tmrName.toString(),
                      tmrId: journeyList[index].tmrId.toString(),
                      workingDate: journeyList[index].workingDate!,
                      onMapTap: () {
                        // List<String> latLong = journeyList[index].gcode!.split(",");
                        //
                        // Navigator.of(context).push(MaterialPageRoute(builder: (context)=> GoogleMapScreen(currentLat: _currentPositionForList!.latitude.toString(),currentLong: _currentPositionForList!.longitude.toString(),storeLat:latLong[0] ,storeLong: latLong[1],))).then((value) {
                        //   getJourneyPlanList(false);
                        // });
                      },
                      buttonName: journeyList[index].visitStatus!.toString() == "0" ? "Evaluate" : "Resume Visit",
                      onTap: (){
                        // _getCurrentPosition(journeyList[index],index);
                        if(journeyList[index].visitStatus!.toString() == "0" ) {
                          _getCurrentPosition(journeyList[index],index);
                        } else {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MyJourneyModuleNew(journeyResponseListItem: journeyList[index],))).then((value) {
                            getJourneyPlanList(false);
                          });
                        }
                      },
                    );
                  }
                  ),
            )
          )
        ],
      )
    );
  }

  onSearchTextFieldChanged(String text) async {
    journeySearchList.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    for (JourneyResponseListItemDetails journeyItem in journeyList) {
      if (journeyItem.tmrName!.toLowerCase().contains(text.toLowerCase())) {
        journeySearchList.add(journeyItem);
      }
    }

    setState(() {});
  }

  Future<void> _getCurrentPosition(JourneyResponseListItemDetails journeyResponseListItem,int index) async {
    final hasPermission = await handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition()
        .then((Position position) async {
      setState(() => _currentPosition = position);

      print("Current Position");
      print(_currentPosition);

        double  distanceInKm = await calculateDistance(
            journeyResponseListItem.gcode!, _currentPosition);

      print(distanceInKm);

      if(distanceInKm<1.2) {
       pickedImage(journeyResponseListItem,_currentPosition,index);
     } else {
       showToastMessage(false, "You are away from Store. please Go to store and start visit.");
     }
      // pickedImage(journeyResponseListItem,_currentPosition,index);

      print("Loaction distance");
      print(distanceInKm);

        }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> pickedImage(JourneyResponseListItemDetails journeyResponseListItem,Position? currentLocation,int index)  async {
    image = await picker.pickImage(source: ImageSource.camera );
    if(image == null) {

    } else {
      print("Image Path");
      print(image!.path);
      compressedImage = await compressAndGetFile(image!);
      showUploadOption(journeyResponseListItem, currentLocation,index,compressedImage);
    }
  }

  showUploadOption(JourneyResponseListItemDetails journeyResponseListItem,Position? currentLocation,int index, XFile? image1) {
    showPopUpForImageUpload(context,journeyResponseListItem, image1!, (){
      String currentPosition = "${currentLocation!.latitude},${currentLocation.longitude}";
      print(currentPosition);
      if(image1 !=null && currentLocation.longitude != null) {
        startVisitCall(journeyResponseListItem, currentLocation,index);
      }
    },currentLocation,"MyJp");
  }

  startVisitCall(JourneyResponseListItemDetails journeyResponseListItem,Position? currentLocation,int index) {
    String currentPosition = "${currentLocation!.latitude},${currentLocation.longitude}";
    print(currentPosition);
    HTTPManager().startJourneyPlan(StartJourneyPlanRequestModel(elId: journeyResponseListItem.elId!.toString(),workingId: journeyResponseListItem.workingId.toString(),storeId: journeyResponseListItem.storeId.toString(),tmrId: journeyResponseListItem.tmrId.toString(),checkInGps: currentPosition,),image!).then((value) {

      showToastMessage(true, "Visit started successfully");

      // setState(() {
      //   journeyList[index].visitStatus = "IN PROGRESS";
      // });
      Navigator.of(context).pop();
      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MyJourneyModuleNew(journeyResponseListItem: journeyResponseListItem,))).then((value) {
        getJourneyPlanList(false);
      });
      setState((){
        isLoading = false;
      });
    }).catchError((e){
      showToastMessage(false, e.toString());
      setState((){
        isLoading = false;
      });
    });
  }

}
