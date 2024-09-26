// ignore_for_file: avoid_print

import 'package:c_supervisor/Screens/utills/image_to_cloud.dart';
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
import '../../Model/response_model/my_coverage_response/uploaded_store_images_list_response.dart';
import '../../Network/http_manager.dart';
import '../../provider/license_provider.dart';
import '../my_coverage/my_coverage_gallery.dart';
import '../my_coverage/widgets/tme_bottom_sheet_user_list.dart';
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

  bool selfieWithTmr = false;
  bool selfieWithTmrWorking = false;
  bool selfieWithTmrCompleted = false;

  bool isLoadingLocation = false;

  late CheckListResponseModel checkListResponseModel;
  Position? _currentPosition;
  int checkListPendingCount = 0;

  ImagePicker picker = ImagePicker();
  XFile? image;
  XFile? compressedImage;

  List<StoreSelfieAvailabilityResponseItem>
      storeSelfieAvailabilityResponseItem =
      <StoreSelfieAvailabilityResponseItem>[];

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
    getStoreImageList(true);
  }

  getStoreImageList(bool loader) {
    setState(() {
      isLoading = loader;
    });

    HTTPManager()
        .storeSelfieAvailability(UploadedImagesRequestModel(
      elId: userId,
      workingId: widget.journeyResponseListItem.workingId.toString(),
      storeId: widget.journeyResponseListItem.storeId.toString(),
    ))
        .then((value) {
      setState(() {
        setState(() {
          selfieWithTmr = false;
          selfieWithTmrWorking = false;
          selfieWithTmrCompleted = false;
        });

        storeSelfieAvailabilityResponseItem = value.data!;

        if (storeSelfieAvailabilityResponseItem.isEmpty) {
          setState(() {
            selfieWithTmr = false;
            selfieWithTmrWorking = false;
            selfieWithTmrCompleted = false;
          });
        } else {
          for (int i = 0; i < storeSelfieAvailabilityResponseItem.length; i++) {
            if (storeSelfieAvailabilityResponseItem[i].selfieType == 1) {
              setState(() {
                selfieWithTmr = true;
              });
            } else if (storeSelfieAvailabilityResponseItem[i].selfieType == 2) {
              setState(() {
                selfieWithTmrWorking = true;
              });
            } else if (storeSelfieAvailabilityResponseItem[i].selfieType == 3) {
              setState(() {
                selfieWithTmrCompleted = true;
              });
            }
            print(selfieWithTmr);
            print(selfieWithTmrWorking);
            print(selfieWithTmrCompleted);
          }
        }

        isLoading = false;
        isError = false;
      });
      setState(() {});
    }).catchError((e) {
      setState(() {
        isError = true;
        errorText = e.toString();
        isLoading = false;
      });
    });
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
                                getStoreImageList(true);
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
                                    pickedImage(widget.journeyResponseListItem,
                                        "N", "0");
                                  },
                                  pendingCheckListCount: 0,
                                  questionRating: 0,
                                  cardName: 'Camera',
                                  cardImage: 'assets/myicons/camera1.png',
                                ),

                                MyJourneyPlanModuleCardItem(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) =>
                                                MyCoverageGallery(
                                                  journeyResponseListItemDetails:
                                                      widget
                                                          .journeyResponseListItem,
                                                )))
                                        .then((value) {
                                      getStoreImageList(false);
                                    });
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
                                                    pageHeader: "Journey Plan",
                                                    checkListResponseModel:
                                                        checkListResponseModel,
                                                  )))
                                          .then((value) {
                                        getCheckList(false);
                                        getStoreImageList(false);
                                      });
                                    } else {
                                      showToastMessage(
                                          false, "Check list is empty");
                                    }
                                  },
                                  pendingCheckListCount: checkListPendingCount,
                                  questionRating: filledQuestionScore == 0
                                      ? 0
                                      : totalScore / filledQuestionScore,
                                  cardName: "Check List",
                                  cardImage: "assets/myicons/checklist.png",
                                ),
                                MyJourneyPlanModuleCardItem(
                                  onTap: () {
                                    // showModalBottomSheet(
                                    //     context: context,
                                    //     isScrollControlled: true,
                                    //     backgroundColor: Colors.transparent,
                                    //     builder: (context) => StatefulBuilder(
                                    //         builder: (BuildContext context, StateSetter menuState){
                                    //           return Container(
                                    //               height: MediaQuery.of(context).size.height * 0.25,
                                    //               decoration: const BoxDecoration(
                                    //                 color: Colors.white,
                                    //                 borderRadius: BorderRadius.only(
                                    //                   topLeft: Radius.circular(25.0),
                                    //                   topRight: Radius.circular(25.0),
                                    //                 ),
                                    //               ),
                                    //               child: Column(
                                    //                 children: [
                                    //                   const SizedBox(height: 11,),
                                    //                   Expanded(
                                    //                       child: ListView(
                                    //                         shrinkWrap: true,
                                    //                         scrollDirection: Axis.vertical,
                                    //                         children: [
                                    //                           InkWell(
                                    //                             onTap: () {
                                    //                               Navigator.of(context).pop();
                                    //                               // if(isSelfieWithTmr != "1") {
                                    //                               setState(() {
                                    //                                 pickedImage(widget.journeyResponseListItem,"Y","1");
                                    //                               });
                                    //                               // }
                                    //                             },
                                    //                             child:  Padding(
                                    //                                 padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                                    //                                 child: Row(
                                    //                                   children: [
                                    //                                     const Expanded(child: Text("Take Selfie with TMR",style: TextStyle(fontSize: 15),)),
                                    //                                     if(selfieWithTmr)
                                    //                                     const Icon(Icons.check, color: AppColors.primaryColor,)
                                    //                                   ],
                                    //                                 )),
                                    //                           ),
                                    //                           const Divider(color: AppColors.primaryColor,),
                                    //                           InkWell(
                                    //                             onTap: () {
                                    //                               Navigator.of(context).pop();
                                    //                               // if(isSelfieWithTmrWorking != "2") {
                                    //                               setState(() {
                                    //                                 pickedImage(widget.journeyResponseListItem,"Y","2");
                                    //                               });
                                    //                               // }
                                    //                             },
                                    //                             child:  Padding(
                                    //                                 padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                                    //                                 child: Row(
                                    //                                   children: [
                                    //                                     const Expanded(child: Text("Take Picture of TMR during work",style: TextStyle(fontSize: 15),)),
                                    //                                     if(selfieWithTmrWorking)
                                    //                                     const Icon(Icons.check, color: AppColors.primaryColor,)
                                    //                                   ],
                                    //                                 )),
                                    //                           ),
                                    //                           const Divider(color: AppColors.primaryColor,),
                                    //                           InkWell(
                                    //                             onTap: () {
                                    //                               Navigator.of(context).pop();
                                    //                               // if(isSelfieWithTmrCompleted != "3") {
                                    //                               setState(() {
                                    //                                 pickedImage(widget.journeyResponseListItem,"Y","3");
                                    //                               });
                                    //                               // }
                                    //                             },
                                    //                             child:  Padding(
                                    //                                 padding:const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                                    //                                 child: Row(
                                    //                                   children: [
                                    //                                     const Expanded(child: Text("Take Picture when TMR completed his work(optional)",style: TextStyle(fontSize: 15),)),
                                    //                                     if(selfieWithTmrCompleted)
                                    //                                     const Icon(Icons.check, color: AppColors.primaryColor,)
                                    //                                   ],
                                    //                                 )),
                                    //                           ),
                                    //                           const Divider(color: AppColors.primaryColor,),
                                    //                         ],
                                    //                       )),
                                    //                   // IgnorePointer(
                                    //                   //   ignoring: isLoadingLocation,
                                    //                   //   child: ElevatedButton(
                                    //                   //     onPressed: () {
                                    //                   //       onTap();
                                    //                   //     },
                                    //                   //     style: ElevatedButton.styleFrom(
                                    //                   //       backgroundColor: isLoadingLocation
                                    //                   //           ? AppColors.lightgreytn
                                    //                   //           : AppColors.primaryColor,
                                    //                   //       padding: const EdgeInsets.symmetric(
                                    //                   //           horizontal: 20, vertical: 10),
                                    //                   //     ),
                                    //                   //     child: const Text(" Next "),
                                    //                   //   ),
                                    //                   // ),
                                    //                   const SizedBox(height: 5,),
                                    //                 ],
                                    //               )
                                    //           );
                                    //         })
                                    // );
                                    selfieOptionForJpBottomSheet(
                                        context,
                                        false,
                                        selfieWithTmr,
                                        selfieWithTmrWorking,
                                        selfieWithTmrCompleted, (value) {
                                      print(value);
                                      Navigator.of(context).pop();
                                      pickedImage(
                                          widget.journeyResponseListItem,
                                          "Y",
                                          value);
                                      // _getCurrentPosition1(true,"Y",value);
                                    });
                                  },
                                  pendingCheckListCount: 0,
                                  questionRating: 0,
                                  cardName: "Selfie",
                                  cardImage: "assets/myicons/selfie.png",
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
                            _getCurrentPosition();
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

  Future<void> pickedImage(
    JourneyResponseListItemDetails journeyResponseListItem,
    String isSelfie,
    String selfieType,
  ) async {
    image = await picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice:
            isSelfie == "Y" ? CameraDevice.front : CameraDevice.rear,
        imageQuality: ImageValue.qualityValue);
    if (image == null) {
    } else {
      print("hitting same position");
      print("Image Path");
      print(image!.path);
      compressedImage = await compressAndGetFile(image!);
      showUploadOption(
          journeyResponseListItem, isSelfie, selfieType, compressedImage);
    }
  }

  showUploadOption(JourneyResponseListItemDetails journeyResponseListItem,
      String isSelfie, String selfieType, XFile? image1) {
    showPopUpForImageUploadForComment(context, image1!, () {
      // String currentPosition = "${currentLocation!.latitude},${currentLocation.longitude}";

      if (image1 != null) {
        imageUploadInsideAppStore(
            journeyResponseListItem, isSelfie, selfieType, image1);
      }
    }, commentController);
  }

  imageUploadInsideAppStore(
      JourneyResponseListItemDetails journeyResponseListItem,
      String isSelfie,
      String selfieType,
      XFile? image1) {
    ImageToCloud()
        .uploadImageToCloud(
            image1!, userId, "capture_photo", LicenseProvider.bucketName)
        .then((imageName) {
      HTTPManager()
          .storeImagesUpload(ImageUploadInStoreRequestModel(
              elId: journeyResponseListItem.elId!.toString(),
              workingId: journeyResponseListItem.workingId.toString(),
              storeId: journeyResponseListItem.storeId.toString(),
              isSelfie: isSelfie,
              selfieType: selfieType,
              comment: commentController.text,
              photoName: imageName))
          .then((value) {
        commentController.clear();
        Navigator.of(context).pop();
        getStoreImageList(false);
        setState(() {});
        showToastMessage(true, "Image Uploaded successfully");
      }).catchError((e) {
        showToastMessage(false, e.toString());
        Navigator.of(context).pop();
      });
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
      if (distanceInKm < 1.2 ) {
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
