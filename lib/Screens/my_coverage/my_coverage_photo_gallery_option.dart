// ignore_for_file: avoid_print

import 'package:c_supervisor/Screens/utills/image_to_cloud.dart';
import 'package:c_supervisor/Screens/my_coverage/widgets/tme_bottom_sheet_user_list.dart';
import 'package:c_supervisor/Screens/utills/app_colors_new.dart';
import 'package:c_supervisor/Screens/widgets/large_button_in_footer.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Model/request_model/end_visit_request.dart';
import '../../Model/request_model/get_check_list_request.dart';
import '../../Model/request_model/image_upload_insde_store_request.dart';
import '../../Model/request_model/journey_plan_request.dart';
import '../../Model/request_model/update_tmr_user_in_coverage.dart';
import '../../Model/response_model/checklist_responses/check_list_response_list_model.dart';
import '../../Model/response_model/journey_responses_plan/journey_plan_response_list.dart';
import '../../Model/response_model/tmr_responses/tmr_list_response.dart';
import '../../Network/http_manager.dart';
import '../../provider/license_provider.dart';
import '../my_jp/my_journey_plan_check_list.dart';
import '../my_jp/widgets/my_journey_plan_module_card_item.dart';
import '../utills/image_compressed_functions.dart';
import '../utills/image_quality.dart';
import '../utills/location_calculation.dart';
import '../utills/location_permission_handle.dart';
import '../utills/user_constants.dart';
import '../widgets/alert_dialogues.dart';
import '../widgets/header_background_new.dart';
import '../widgets/header_widgets_new.dart';
import '../widgets/toast_message_show.dart';
import 'my_coverage_gallery.dart';

class MyCoveragePhotoGalleryOptions extends StatefulWidget {
  const MyCoveragePhotoGalleryOptions(
      {Key? key, required this.journeyResponseListItemDetails})
      : super(key: key);

  final JourneyResponseListItemDetails journeyResponseListItemDetails;

  @override
  State<MyCoveragePhotoGalleryOptions> createState() =>
      _MyCoveragePhotoGalleryOptionsState();
}

class _MyCoveragePhotoGalleryOptionsState
    extends State<MyCoveragePhotoGalleryOptions> {
  String userName = "";
  String userId = "";
  int? geoFence;
  int checkListPendingCount = 0;
  int totalScore = 0;
  int filledQuestionScore = 0;
  int selectedTmrUser = 0;
  late TmrUserItem tmrUserItem;

  bool isLoading = true;
  bool isLoadingLocation = false;
  bool isError = false;
  String errorText = "";

  ImagePicker picker = ImagePicker();
  XFile? image;
  XFile? compressedImage;
  Position? _currentPosition;

  late CheckListResponseModel checkListResponseModel;
  late TmrUserList tmrUserList;

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

    getCheckList(true);
    getTmrUserList(true);

    // getJourneyPlanList(true);
  }

  getCheckList(bool loader) {
    setState(() {
      isLoading = loader;
    });

    HTTPManager()
        .getCheckList(GetCheckListRequest(
            elId: userId,
            workingId:
                widget.journeyResponseListItemDetails.workingId.toString(),
            storeId: widget.journeyResponseListItemDetails.storeId.toString(),
            tmrId: widget.journeyResponseListItemDetails.tmrId.toString()))
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
            checkListResponseModel.data![i].score == 0.0 &&
                checkListResponseModel.data![i].isApplicable != "N") {
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

  getTmrUserList(bool loader) {
    setState(() {
      isLoading = loader;
    });

    HTTPManager()
        .tmrUserList(JourneyPlanRequestModel(elId: userId))
        .then((value) {
      setState(() {
        tmrUserList = value;
        if (tmrUserList.data!.isNotEmpty) {
          tmrUserItem = tmrUserList.data![0];
        }
        isLoading = false;
        isError = false;
      });
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
              pageTitle:
                  widget.journeyResponseListItemDetails.storeName.toString(),
              isBackButton: true,
              isDrawerButton: true,
            ),
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
                      MyJourneyPlanModuleCardItem(
                        onTap: () {
                          // _getCurrentPosition(true);
                          pickedImage(
                            widget.journeyResponseListItemDetails,
                          );
                        },
                        pendingCheckListCount: 0,
                        questionRating: 0,
                        cardName: 'Camera',
                        cardImage: 'assets/myicons/camera1.png',
                      ),
                      MyJourneyPlanModuleCardItem(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => MyCoverageGallery(
                                    journeyResponseListItemDetails:
                                        widget.journeyResponseListItemDetails,
                                  )));
                        },
                        pendingCheckListCount: 0,
                        questionRating: 0,
                        cardName: "Gallery",
                        cardImage: "assets/myicons/gallery.png",
                      ),
                      MyJourneyPlanModuleCardItem(
                        onTap: () {
                          if (filledQuestionScore == 0) {
                            selectedTmrUser = 0;
                            tmrBottomSheetUserList(context, tmrUserList,
                                selectedTmrUser, isLoadingLocation, (value) {
                              print(value.id);
                              print(value.fullName);
                              setState(() {
                                tmrUserItem = value;
                              });
                            }, () {
                              updateTmrUserInCoverage(
                                  userId,
                                  widget
                                      .journeyResponseListItemDetails.workingId
                                      .toString(),
                                  tmrUserItem.id.toString());
                            });
                          } else {
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                                    builder: (context) =>
                                        MyJourneyPlanCheckList(
                                          pageHeader: "My Coverage",
                                          checkListResponseModel:
                                              checkListResponseModel,
                                        )))
                                .then((value) {
                              getCheckList(false);
                              getTmrUserList(false);
                            });
                          }

                          // if (checkListResponseModel
                          //     .data!.isNotEmpty) {
                          //   Navigator.of(context)
                          //       .push(MaterialPageRoute(
                          //       builder: (context) =>
                          //           MyJourneyPlanCheckList(
                          //             pageHeader: "My Coverage",
                          //             checkListResponseModel:
                          //             checkListResponseModel,
                          //           )))
                          //       .then((value) {
                          //     // getCheckList(false);
                          //   });
                          // } else {
                          //   showToastMessage(
                          //       false, "Check list is empty");
                          // }
                        },
                        pendingCheckListCount: checkListPendingCount,
                        questionRating: filledQuestionScore == 0
                            ? 0
                            : totalScore / filledQuestionScore,
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
              onTap: () async {
                await showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text(
                          'Are you sure you want to finish this visit ?'),
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
                            Navigator.of(context).pop();
                            _getCurrentPosition(false);
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
              },
            )
          ],
        ),
      ),
    );
  }

  Future<void> _getCurrentPosition(bool takeImage) async {
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
          widget.journeyResponseListItemDetails.gcode!, _currentPosition);

      setState(() {
        isLoadingLocation = false;
      });

      print(distanceInKm);
      if (distanceInKm < 1.2) {
        String currentPosition =
            "${_currentPosition!.latitude},${_currentPosition!.longitude}";
        if (takeImage) {
          pickedImage(widget.journeyResponseListItemDetails);
        } else {
          endVisit(currentPosition);
        }
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

  Future<void> pickedImage(
    JourneyResponseListItemDetails journeyResponseListItem,
  ) async {
    image = await picker.pickImage(
        source: ImageSource.camera, imageQuality: ImageValue.qualityValue);
    if (image == null) {
    } else {
      print("hitting same position");
      print("Image Path");
      print(image!.path);
      compressedImage = await compressAndGetFile(image!);
      showUploadOption(journeyResponseListItem, compressedImage);
    }
  }

  showUploadOption(
      JourneyResponseListItemDetails journeyResponseListItem, XFile? image1) {
    showPopUpForImageUploadForComment(context, image1!, () {
      // String currentPosition = "${currentLocation!.latitude},${currentLocation.longitude}";

      if (image1 != null) {
        imageUploadInsideAppStore(journeyResponseListItem, image1);
      }
    }, commentController);
  }

  imageUploadInsideAppStore(
      JourneyResponseListItemDetails journeyResponseListItem,
      XFile? image1) async {
    await ImageToCloud()
        .uploadImageToCloud(
            image1!, userId, "capture_photo", LicenseProvider.bucketName)
        .then((imageName) {
      HTTPManager()
          .storeImagesUpload(ImageUploadInStoreRequestModel(
              elId: journeyResponseListItem.elId!.toString(),
              workingId: journeyResponseListItem.workingId.toString(),
              storeId: journeyResponseListItem.storeId.toString(),
              isSelfie: "N",
              selfieType: "0",
              comment: commentController.text,
              photoName: imageName))
          .then((value) {
        commentController.clear();
        Navigator.of(context).pop();
        setState(() {});
        showToastMessage(true, "Image Uploaded successfully");
      }).catchError((e) {
        showToastMessage(false, e.toString());
      });
    });
  }

  endVisit(String currentPosition) {
    setState(() {
      isLoading = true;
    });

    HTTPManager()
        .endVisit(EndVisitRequestModel(
            elId: widget.journeyResponseListItemDetails.elId.toString(),
            workingId:
                widget.journeyResponseListItemDetails.workingId!.toString(),
            checkInGps: currentPosition))
        .then((value) {
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

  updateTmrUserInCoverage(String elId, String workingId, String tmrId) {
    setState(() {
      isLoadingLocation = true;
    });
    Navigator.of(context).pop();
    HTTPManager()
        .updateTmrUserCoverage(UpdateTmrUserInCoverage(
      elId: elId,
      workingId: workingId,
      tmrId: tmrId,
    ))
        .then((value) {
      showToastMessage(true, "User update successfully");

      Navigator.of(context)
          .push(MaterialPageRoute(
              builder: (context) => MyJourneyPlanCheckList(
                    pageHeader: "My Coverage",
                    checkListResponseModel: checkListResponseModel,
                  )))
          .then((value) {
        getCheckList(false);
        getTmrUserList(false);
      });

      setState(() {
        isLoadingLocation = false;
      });
    }).catchError((e) {
      setState(() {
        showToastMessage(false, e.toString());
        isLoadingLocation = false;
      });
    });
  }
}
