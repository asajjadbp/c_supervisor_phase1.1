// ignore_for_file: avoid_print

import 'package:c_supervisor/Screens/widgets/large_button_in_footer.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Model/request_model/end_visit_request.dart';
import '../../Model/request_model/image_upload_insde_store_request.dart';
import '../../Model/response_model/journey_responses_plan/journey_plan_response_list.dart';
import '../../Network/http_manager.dart';
import '../my_jp/widgets/my_journey_plan_module_card_item.dart';
import '../utills/image_compressed_functions.dart';
import '../utills/location_calculation.dart';
import '../utills/location_permission_handle.dart';
import '../utills/user_constants.dart';
import '../widgets/alert_dialogues.dart';
import '../widgets/header_background_new.dart';
import '../widgets/header_widgets_new.dart';
import '../widgets/toast_message_show.dart';
import 'my_coverage_gallery.dart';

class MyCoveragePhotoGalleryOptions extends StatefulWidget {
  const MyCoveragePhotoGalleryOptions({Key? key,required this.journeyResponseListItemDetails}) : super(key: key);

  final JourneyResponseListItemDetails journeyResponseListItemDetails;

  @override
  State<MyCoveragePhotoGalleryOptions> createState() => _MyCoveragePhotoGalleryOptionsState();
}

class _MyCoveragePhotoGalleryOptionsState extends State<MyCoveragePhotoGalleryOptions> {

  String userName = "";
  String userId = "";
  int? geoFence;

  bool isLoading = true;

  ImagePicker picker = ImagePicker();
  XFile? image;
  XFile? compressedImage;
  Position? _currentPosition;

  TextEditingController commentController = TextEditingController();

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
      geoFence = sharedPreferences.getInt(UserConstants().userGeoFence)!;
    });

    // getJourneyPlanList(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HeaderBackgroundNew(
        childWidgets: [
          const HeaderWidgetsNew(pageTitle: "My Coverage",isBackButton: true,isDrawerButton: true,),
          Expanded(
            child: GridView(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: (163.5 / 135),
                crossAxisCount: 2,
              ),
              children:  [
                MyJourneyPlanModuleCardItem(
                  onTap: () {
                    _getCurrentPosition(true);
                  },
                  pendingCheckListCount: 0,
                  cardName: 'Camera',
                  cardImage: 'assets/icons/camera.png',
                ),

                MyJourneyPlanModuleCardItem(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MyCoverageGallery(journeyResponseListItemDetails: widget.journeyResponseListItemDetails,)));
                  },
                  pendingCheckListCount: 0,
                  cardName: "Gallery",
                  cardImage:  "assets/icons/gallery.png",
                ),

              ],
            ),
          ),
          LargeButtonInFooter(buttonTitle: "Finish Visit", onTap: (){_getCurrentPosition(false);},)
        ],
      ),
    );
  }

  Future<void> _getCurrentPosition(bool takeImage) async {
    final hasPermission = await handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition()
        .then((Position position) async {
      setState(() => _currentPosition = position);

      print("Current Position");
      print(_currentPosition);

      double distanceInKm = await calculateDistance(
            widget.journeyResponseListItemDetails.gcode!, _currentPosition);
      print(distanceInKm);
      if(distanceInKm<1.2) {
        String currentPosition = "${_currentPosition!.latitude},${_currentPosition!.longitude}";
        if(takeImage) {
         pickedImage(widget.journeyResponseListItemDetails, currentPosition);
        } else {
          endVisit(currentPosition);
        }

      } else {
        showToastMessage(false, "You are away from Store. please Go to store and end visit.");
      }

    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> pickedImage(JourneyResponseListItemDetails journeyResponseListItem,String currentLocation)  async {
    image = await picker.pickImage(source: ImageSource.camera );
    if(image == null) {

    } else {
      print("Image Path");
      print(image!.path);
      compressedImage = await compressAndGetFile(image!);
      showUploadOption(journeyResponseListItem, currentLocation,compressedImage);
    }
  }

  showUploadOption(JourneyResponseListItemDetails journeyResponseListItem,String currentLocation, XFile? image1) {
    showPopUpForImageUploadForComment(context, image1!, (){
      // String currentPosition = "${currentLocation!.latitude},${currentLocation.longitude}";
      print(currentLocation);
      if(image1 !=null && currentLocation != "") {
        imageUploadInsideAppStore(journeyResponseListItem, currentLocation,image1);
      }
    },commentController);
  }

  imageUploadInsideAppStore(JourneyResponseListItemDetails journeyResponseListItem,String currentLocation, XFile? image1) {
    HTTPManager().storeImagesUpload(ImageUploadInStoreRequestModel(elId: journeyResponseListItem.elId!.toString(),workingId: journeyResponseListItem.workingId.toString(),storeId: journeyResponseListItem.storeId.toString(),checkInGps: currentLocation,comment: commentController.text), image1!).then((value) {
      commentController.clear();
      Navigator.of(context).pop();
      setState(() {

      });
      showToastMessage(true, "Image Uploaded successfully");
    }).catchError((e) {
      showToastMessage(false, e.toString());
    });
  }

  endVisit(String currentPosition) {
    setState(() {
      isLoading = true;
    });

    HTTPManager().endVisit(EndVisitRequestModel(elId: widget.journeyResponseListItemDetails.elId.toString(),workingId: widget.journeyResponseListItemDetails.workingId!.toString(),checkInGps: currentPosition )).then((value) {

      setState(() {
        isLoading = true;
      });
      Navigator.of(context).pop();
      showToastMessage(true, "Visit Ended successfully");

    }).catchError((e) {
      setState(() {
        isLoading = false;
      });
      // print(e);
      showToastMessage(false, e.toString());
    });

  }

}
