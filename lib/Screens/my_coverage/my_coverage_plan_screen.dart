
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
import '../widgets/toast_message_show.dart';
import 'package:image_picker/image_picker.dart';

import 'my_coverage_photo_gallery_option.dart';

class MyCoveragePlanScreenNew extends StatefulWidget {
  const MyCoveragePlanScreenNew({Key? key}) : super(key: key);

  @override
  State<MyCoveragePlanScreenNew> createState() => _MyCoveragePlanScreenNewState();
}

class _MyCoveragePlanScreenNewState extends State<MyCoveragePlanScreenNew> {

  String userName = "";
  String userId = "";
  bool isLoading = true;
  List<JourneyResponseListItemDetails> journeyList = <JourneyResponseListItemDetails>[];
  bool isError = false;
  String errorText = "";

  ImagePicker picker = ImagePicker();
  XFile? image;
  XFile? compressedImage;
  Position? _currentPosition;

  @override
  void initState() {

    getUserData();
    super.initState();
  }

  getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      userName = sharedPreferences.getString(UserConstants().userName)!;
      userId = sharedPreferences.getString(UserConstants().userId)!;
    });

    getJourneyPlanList(true);
  }

  getJourneyPlanList(bool isLoader) {
    setState(() {
      isLoading = isLoader;
    });

    HTTPManager().userJourneyPlanList(JourneyPlanRequestModel(elId: userId)).then((value) {
      setState(() {
        journeyList = value.data!.special!;
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
          const HeaderWidgetsNew(pageTitle: "My Coverage",isBackButton: true,isDrawerButton: true,),
          Expanded(
            child: isLoading ? const Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor,),
            ) : Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: isError ? ErrorTextAndButton(onTap: (){
                getJourneyPlanList(true);
              },errorText: errorText) : journeyList.isEmpty ? const Center(child: Text("No plans found"),) : ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: journeyList.length,
                  itemBuilder: (context,index) {
                    return MyJpCardForDetail(
                      storeName: journeyList[index].storeName!,
                      visitStatus: journeyList[index].visitStatus!.toString(),
                      tmrName: journeyList[index].tmrId.toString(),
                      tmrId: journeyList[index].tmrName.toString(),
                      workingDate: journeyList[index].workingDate!,
                      onTap: (){
                        // _getCurrentPosition(journeyList[index],index);
                        if(journeyList[index].visitStatus!.toString() == "0" ) {
                          _getCurrentPosition(journeyList[index],index);
                        } else {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MyCoveragePhotoGalleryOptions(journeyResponseListItemDetails: journeyList[index],))).then((value) {
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

  Future<void> _getCurrentPosition(JourneyResponseListItemDetails journeyResponseListItem,int index) async {
    final hasPermission = await handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition()
        .then((Position position) async {
      setState(() => _currentPosition = position);
      
      print("Current Position");
      print(_currentPosition);

     double distanceInKm = await calculateDistance(journeyResponseListItem.gcode!,_currentPosition);

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
    showPopUpForImageUpload(context, image1!, (){
      String currentPosition = "${currentLocation!.latitude},${currentLocation.longitude}";
      print(currentPosition);
      if(image1 !=null && currentLocation.longitude != null) {
        startVisitCall(journeyResponseListItem, currentLocation,index);
      }
    });
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
      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MyCoveragePhotoGalleryOptions(journeyResponseListItemDetails: journeyResponseListItem,))).then((value) {
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
