// ignore_for_file: avoid_print

import 'package:c_supervisor/Screens/my_jp/widgets/my_journey_plan_module_card_item.dart';
import 'package:c_supervisor/Screens/utills/location_permission_handle.dart';
import 'package:c_supervisor/Screens/widgets/toast_message_show.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Model/request_model/end_visit_request.dart';
import '../../Model/request_model/get_check_list_request.dart';
import '../../Model/request_model/image_upload_insde_store_request.dart';
import '../../Model/response_model/checklist_responses/check_list_response_list_model.dart';
import '../../Model/response_model/journey_responses_plan/journey_plan_response_list.dart';
import '../../Network/http_manager.dart';
import '../my_coverage/my_coverage_gallery.dart';
import '../utills/app_colors_new.dart';
import '../utills/image_compressed_functions.dart';
import '../utills/image_quality.dart';
import '../utills/location_calculation.dart';
import '../utills/user_constants.dart';
import '../widgets/alert_dialogues.dart';
import '../widgets/error_text_and_button.dart';
import '../widgets/header_background_new.dart';
import '../widgets/header_widgets_new.dart';
import '../widgets/large_button_in_footer.dart';
import 'my_journey_plan_check_list.dart';

class MyJourneyModuleNew extends StatefulWidget {
  const MyJourneyModuleNew({Key? key, required this.journeyResponseListItem})
      : super(key: key);
  final JourneyResponseListItemDetails journeyResponseListItem;
  @override
  State<MyJourneyModuleNew> createState() => _MyJourneyModuleNewState();
}

class _MyJourneyModuleNewState extends State<MyJourneyModuleNew> {
  String userName = "";
  String userId = "";
  int? geoFence;
  int totalScore = 0;
  int filledQuestionScore = 0;

  bool isLoading = true;
  bool isError = false;
  bool isEndLoading = false;
  String errorText = "";

  bool isLoadingLocation = false;

  late CheckListResponseModel checkListResponseModel;
  Position? _currentPosition;
  int checkListPendingCount = 0;

  ImagePicker picker = ImagePicker();
  XFile? image;
  XFile? compressedImage;

  TextEditingController commentController = TextEditingController();

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
      geoFence = sharedPreferences.getInt(UserConstants().userGeoFence)!;
    });

    getCheckList(true);
  }

  getCheckList(bool loader) {
    setState(() {
      isLoading = loader;
    });

    HTTPManager()
        .getCheckList(GetCheckListRequest(
            elId: userId,
            workingId: widget.journeyResponseListItem.workingId.toString(),
            storeId: widget.journeyResponseListItem.storeId.toString(),
            tmrId: widget.journeyResponseListItem.tmrId.toString()))
        .then((value) {
      setState(() {
        checkListPendingCount = 0;
        checkListResponseModel = value;
        isLoading = false;
        isError = false;
      });

      totalScore = 0;

      for (int i = 0; i < checkListResponseModel.data!.length; i++) {
        totalScore = totalScore + checkListResponseModel.data![i].score!;

        if (checkListResponseModel.data![i].score == 0 ||
            checkListResponseModel.data![i].score == 0.0) {
          setState(() {
            checkListPendingCount = checkListPendingCount + 1;
          });
        }
      }
      filledQuestionScore =
          checkListResponseModel.data!.length - checkListPendingCount;
      // print("Total question");
      // print(checkListResponseModel.data!.length);
      // print("filled question");
      // print(filledQuestionScore);
      // print("pending question");
      // print(checkListPendingCount);
      // print(totalScore);
    }).catchError((e) {
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
      body: IgnorePointer(
        ignoring: isLoadingLocation,
        child: HeaderBackgroundNew(
          childWidgets: [
            HeaderWidgetsNew(
              pageTitle: widget.journeyResponseListItem.storeName.toString(),
              // "Journey Plan Module",
              isBackButton: true,
              isDrawerButton: true,
            ),
            Expanded(
              child: Stack(
                children: [
                  isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryColor,
                          ),
                        )
                      : isError
                          ? ErrorTextAndButton(
                              onTap: () {
                                getCheckList(true);
                              },
                              errorText: errorText)
                          : GridView(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: (163.5 / 135),
                                crossAxisCount: 2,
                              ),
                              children: [
                                // MyJourneyPlanModuleCardItem(
                                //   onTap: () {},
                                //   cardName: 'Photos',
                                //   cardImage: 'assets/icons/images.png',
                                // ),
                                MyJourneyPlanModuleCardItem(
                                  onTap: () {
                                    _getCurrentPosition1(true);
                                  },
                                  pendingCheckListCount: 0,
                                  questionRating: 0,
                                  cardName: 'Camera',
                                  cardImage: 'assets/myicons/camera1.png',
                                ),

                                MyJourneyPlanModuleCardItem(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MyCoverageGallery(
                                                  journeyResponseListItemDetails:
                                                      widget
                                                          .journeyResponseListItem,
                                                )));
                                  },
                                  pendingCheckListCount: 0,
                                  questionRating: 0,
                                  cardName: "Gallery",
                                  cardImage: "assets/myicons/gallery.png",
                                ),
                                MyJourneyPlanModuleCardItem(
                                  onTap: () {
                                    if (checkListResponseModel
                                        .data!.isNotEmpty) {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  MyJourneyPlanCheckList(
                                                    checkListResponseModel:
                                                        checkListResponseModel,
                                                  )))
                                          .then((value) {
                                        getCheckList(false);
                                      });
                                    } else {
                                      showToastMessage(
                                          false, "Check list is empty");
                                    }
                                  },
                                  pendingCheckListCount: checkListPendingCount,
                                  questionRating:
                                      totalScore / filledQuestionScore,
                                  cardName: "Check List",
                                  cardImage: "assets/myicons/checklist.png",
                                ),
                              ],
                            ),
                  if (isLoadingLocation)
                    const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    )
                ],
              ),
            ),
            LargeButtonInFooter(
              buttonTitle: "Finish Visit",
              onTap: () {
                _getCurrentPosition();
              },
            )
          ],
        ),
      ),
    );
  }

  Future<void> _getCurrentPosition1(bool takeImage) async {
    setState(() {
      isLoadingLocation = true;
    });

    final hasPermission = await handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition().then((Position position) async {
      setState(() => _currentPosition = position);

      print("Current Position");
      print(_currentPosition);

      double distanceInKm = await calculateDistance(
          widget.journeyResponseListItem.gcode!, _currentPosition);
      print(distanceInKm);

      setState(() {
        isLoadingLocation = false;
      });

      if (distanceInKm < 1.2) {
        String currentPosition =
            "${_currentPosition!.latitude},${_currentPosition!.longitude}";
        if (takeImage) {
          pickedImage(widget.journeyResponseListItem, currentPosition);
        } else {
          endVisit(currentPosition);
        }
      } else {
        showToastMessage(false,
            "You are away from Store. please Go to store and end visit.($distanceInKm)km");
      }
    }).catchError((e) {
      setState(() {
        isLoadingLocation = false;
      });
      debugPrint(e);
    });
  }

  Future<void> pickedImage(
      JourneyResponseListItemDetails journeyResponseListItem,
      String currentLocation) async {
    image = await picker.pickImage(
        source: ImageSource.camera, imageQuality: ImageValue.qualityValue);
    if (image == null) {
    } else {
      print("Image Path");
      print(image!.path);
      compressedImage = await compressAndGetFile(image!);
      showUploadOption(
          journeyResponseListItem, currentLocation, compressedImage);
    }
  }

  showUploadOption(JourneyResponseListItemDetails journeyResponseListItem,
      String currentLocation, XFile? image1) {
    showPopUpForImageUploadForComment(context, image1!, () {
      // String currentPosition = "${currentLocation!.latitude},${currentLocation.longitude}";
      print(currentLocation);
      if (image1 != null && currentLocation != "") {
        imageUploadInsideAppStore(
            journeyResponseListItem, currentLocation, image1);
      }
    }, commentController);
  }

  imageUploadInsideAppStore(
      JourneyResponseListItemDetails journeyResponseListItem,
      String currentLocation,
      XFile? image1) {
    HTTPManager()
        .storeImagesUpload(
            ImageUploadInStoreRequestModel(
                elId: journeyResponseListItem.elId!.toString(),
                workingId: journeyResponseListItem.workingId.toString(),
                storeId: journeyResponseListItem.storeId.toString(),
                checkInGps: currentLocation,
                comment: commentController.text),
            image1!)
        .then((value) {
      commentController.clear();
      Navigator.of(context).pop();
      setState(() {});
      showToastMessage(true, "Image Uploaded successfully");
    }).catchError((e) {
      showToastMessage(false, e.toString());
      Navigator.of(context).pop();
    });
  }

  Future<void> _getCurrentPosition() async {
    setState(() {
      isLoadingLocation = true;
    });

    final hasPermission = await handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition().then((Position position) async {
      setState(() => _currentPosition = position);

      print("Current Position");
      print(_currentPosition);

      double distanceInKm = await calculateDistance(
          widget.journeyResponseListItem.gcode!, _currentPosition);
      print(distanceInKm);
      if (distanceInKm < 1.2) {
        String currentPosition =
            "${_currentPosition!.latitude},${_currentPosition!.longitude}";

        endVisit(currentPosition);
      } else {
        showToastMessage(false,
            "You are away from Store. please Go to store and end visit.($distanceInKm)km");
      }
      setState(() {
        isLoadingLocation = false;
      });
    }).catchError((e) {
      setState(() {
        isLoadingLocation = false;
      });
      debugPrint(e);
    });
  }

  endVisit(String currentPosition) {
    setState(() {
      isLoading = true;
    });

    HTTPManager()
        .endVisit(EndVisitRequestModel(
            elId: widget.journeyResponseListItem.elId.toString(),
            workingId: widget.journeyResponseListItem.workingId!.toString(),
            checkInGps: currentPosition))
        .then((value) {
      setState(() {
        isLoading = false;
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
