import 'dart:io';

import 'package:c_supervisor/Screens/utills/image_to_cloud.dart';
import 'package:c_supervisor/Screens/authentication/login_screen.dart';
import 'package:c_supervisor/Screens/utills/app_colors_new.dart';
import 'package:c_supervisor/Screens/widgets/toast_message_show.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import '../../Model/request_model/start_journey_plan_request.dart';
import '../../Model/request_model/upload_check_list_photo_request.dart';
import '../../Model/response_model/journey_responses_plan/journey_plan_response_list.dart';
import '../../Network/http_manager.dart';
import '../../provider/license_provider.dart';
import '../my_coverage/my_coverage_photo_gallery_option.dart';
import '../my_jp/my_journey_plan_module_new.dart';
import '../utills/user_session.dart';
import 'comment_text_field_for_pop_up.dart';

showPopUponBackButton(BuildContext context) {
  // set up the buttons
  Widget cancelButton = TextButton(
    child: const Text("No"),
    onPressed: () {
      Navigator.of(context).pop();
      // _changeProfile(userNameController.text,emailController.text,_timezone,firebaseDeviceToken);
    },
  );
  Widget continueButton = TextButton(
    child: const Text("Yes"),
    onPressed: () {
      UserSessionState().clearUserSession();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("Logout"),
    content: const Text("Are you sure you want to logout?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showPopUpForImageUpload(
    BuildContext context,
    JourneyResponseListItemDetails journeyResponseListItemDetails,
    XFile imageFile,
    Function onTap,
    Position? currentPosition,
    String type) {
  bool isLoading = false;
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("Picked Image"),
    content:
        StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: IgnorePointer(
          ignoring: isLoading,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Expanded(
                    child: isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primaryColor,
                            ),
                          )
                        : Image.file(File(imageFile.path))),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        setState(() {
                          // isGoalsTabActive = true;
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(color: AppColors.primaryColor)),
                        child: const Icon(
                          Icons.close,
                          color: AppColors.redColor,
                          size: 40,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        onTap();
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(color: AppColors.primaryColor)),
                        child: const Icon(
                          Icons.check,
                          color: AppColors.primaryColor,
                          size: 40,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    }),
  );

  // show the dialog
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showPopUpForCheckListImageUpload(BuildContext context, XFile imageFile,
    Function onTap, String selectedId, String elId, String userId) {
  bool isLoading = false;
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("Picked Image"),
    content:
        StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: IgnorePointer(
          ignoring: isLoading,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Expanded(
                    child: isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primaryColor,
                            ),
                          )
                        : Image.file(File(imageFile.path))),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        setState(() {
                          // isGoalsTabActive = true;
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(color: AppColors.primaryColor)),
                        child: const Icon(
                          Icons.close,
                          color: AppColors.redColor,
                          size: 40,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isLoading = true;
                        });

                        ImageToCloud()
                            .uploadImageToCloud(imageFile, userId,
                                "capture_photo", LicenseProvider.bucketName)
                            .then((imageName) {
                          HTTPManager()
                              .checkListPostImage(
                            UploadCheckListRequestModel(
                                id: selectedId,
                                elId: elId,
                                photoName: imageName),
                          )
                              .then((value) {
                            showToastMessageBottom(
                                true, "Image uploaded successfully");
                            setState(() {
                              isLoading = false;
                            });
                            Navigator.of(context).pop();
                          }).catchError((e) {
                            setState(() {
                              isLoading = false;
                            });
                            showToastMessageBottom(false, e.toString());
                          });
                          // Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MyJourneyModuleNew(journeyResponseListItem: journeyResponseListItem,)));
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(color: AppColors.primaryColor)),
                        child: const Icon(
                          Icons.check,
                          color: AppColors.primaryColor,
                          size: 40,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    }),
  );

  // show the dialog
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showPopUpForImageUploadForComment(
  BuildContext context,
  XFile imageFile,
  Function onTap,
  TextEditingController controller,
) {
  bool isLoading = false;
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("Upload Image"),
    content:
        StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: IgnorePointer(
          ignoring: isLoading,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Expanded(
                    child: isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primaryColor,
                            ),
                          )
                        : SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              children: [
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.2,
                                    width: MediaQuery.of(context).size.width,
                                    child: Image.file(File(imageFile.path))),
                                const SizedBox(
                                  height: 5,
                                ),
                                PopUpCommentTextField(
                                  textEditingController: controller,
                                  onChangeValue: (String value) {},
                                )
                              ],
                            ),
                          )),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        setState(() {
                          // isGoalsTabActive = true;
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(color: AppColors.primaryColor)),
                        child: const Icon(
                          Icons.close,
                          color: AppColors.redColor,
                          size: 40,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isLoading = true;
                        });
                        onTap();
                        // setState((){
                        //   isLoading = false;
                        // });
                        // Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MyJourneyModuleNew(journeyResponseListItem: journeyResponseListItem,)));
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(color: AppColors.primaryColor)),
                        child: const Icon(
                          Icons.check,
                          color: AppColors.primaryColor,
                          size: 40,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    }),
  );

  // show the dialog
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
