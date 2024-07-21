// ignore_for_file: avoid_print

import 'package:c_supervisor/Model/request_model/upload_check_list_photo_request.dart';
import 'package:c_supervisor/Network/http_manager.dart';
import 'package:c_supervisor/Screens/utills/image_to_cloud.dart';
import 'package:c_supervisor/Screens/my_jp/widgets/check_list_comment_field.dart';
import 'package:c_supervisor/Screens/utills/image_quality.dart';
import 'package:c_supervisor/Screens/widgets/toast_message_show.dart';
import 'package:expand_widget/expand_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Model/response_model/checklist_responses/check_list_response_list_model.dart';
import '../../provider/license_provider.dart';
import '../utills/app_colors_new.dart';
import '../utills/image_compressed_functions.dart';
import '../utills/user_constants.dart';
import '../widgets/alert_dialogues.dart';
import '../widgets/large_button_in_footer.dart';

class MyJourneyPlanCheckList extends StatefulWidget {
  const MyJourneyPlanCheckList(
      {Key? key,
      required this.checkListResponseModel,
      required this.pageHeader})
      : super(key: key);

  final CheckListResponseModel checkListResponseModel;
  final String pageHeader;

  @override
  State<MyJourneyPlanCheckList> createState() => _MyJourneyPlanCheckListState();
}

class _MyJourneyPlanCheckListState extends State<MyJourneyPlanCheckList> {
  TextEditingController commentTextEditingController = TextEditingController();
  bool isLoading = false;
  XFile? image;
  XFile? compressedImage;
  String userName = "";
  String userId = "";
  ImagePicker picker = ImagePicker();

  @override
  void initState() {
    // TODO: implement initStat
    getUserData();
    super.initState();
  }

  getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      userName = sharedPreferences.getString(UserConstants().userName)!;
      userId = sharedPreferences.getString(UserConstants().userId)!;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("${widget.pageHeader} Check List"),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: AnimationLimiter(
                    child: ListView.separated(
                        physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
                        itemCount: widget.checkListResponseModel.data!.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          //controllerList[0].text = "widget.checkListResponseModel.data![index].comment!";
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            delay: const Duration(milliseconds: 100),
                            child: SlideAnimation(
                                duration: const Duration(milliseconds: 2500),
                                curve: Curves.fastLinearToSlowEaseIn,
                                horizontalOffset: -300,
                                verticalOffset: -850,
                                child: Card(
                                  elevation: 5,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 5),
                                        Text(
                                          widget.checkListResponseModel
                                              .data![index].checkList!,
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                const Text(
                                                  "Rate: ",
                                                  style: TextStyle(
                                                      color: AppColors
                                                          .primaryColor,
                                                      fontSize: 18),
                                                ),
                                                RatingBar.builder(
                                                  updateOnDrag: false,
                                                  ignoreGestures: widget
                                                          .checkListResponseModel
                                                          .data![index]
                                                          .isApplicable ==
                                                      "N",
                                                  initialRating: widget
                                                      .checkListResponseModel
                                                      .data![index]
                                                      .score!
                                                      .toDouble(),
                                                  itemSize: 25,
                                                  direction: Axis.horizontal,
                                                  //allowHalfRating: false,
                                                  itemCount: 5,
                                                  itemPadding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 1.0),
                                                  itemBuilder: (context, _) =>
                                                      const Icon(
                                                    Icons.star,
                                                    color:
                                                        AppColors.primaryColor,
                                                  ),
                                                  onRatingUpdate: (rating) {
                                                    setState(() {
                                                      widget
                                                          .checkListResponseModel
                                                          .data![index]
                                                          .score = rating.toInt();
                                                    });
                                                  },
                                                )
                                              ],
                                            ),
                                            widget
                                                        .checkListResponseModel
                                                        .data![index]
                                                        .isApplicable !=
                                                    "N"
                                                ? InkWell(
                                                    onTap: () {
                                                      pickedImage(
                                                          widget
                                                              .checkListResponseModel
                                                              .data![index]
                                                              .checklistResultId
                                                              .toString(),
                                                          userId,
                                                          index);
                                                    },
                                                    child: Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              right: 5),
                                                      child: const Icon(
                                                        Icons.camera_alt,
                                                        color: AppColors
                                                            .primaryColor,
                                                        size: 30,
                                                      ),
                                                    ),
                                                  )
                                                : InkWell(
                                                    onTap: () async {
                                                      await showDialog<bool>(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            title: const Text(
                                                                'Do you want to answer this question?'),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context,
                                                                      false);
                                                                },
                                                                child:
                                                                    const Text(
                                                                  'No',
                                                                  style: TextStyle(
                                                                      color: AppColors
                                                                          .primaryColor),
                                                                ),
                                                              ),
                                                              TextButton(
                                                                onPressed: () {
                                                                  setState(() {
                                                                    widget
                                                                        .checkListResponseModel
                                                                        .data![
                                                                            index]
                                                                        .isApplicable = "Y";
                                                                  });
                                                                  print(widget
                                                                      .checkListResponseModel
                                                                      .data![
                                                                          index]
                                                                      .isApplicable);
                                                                  Navigator.pop(
                                                                      context,
                                                                      false);
                                                                },
                                                                child:
                                                                    const Text(
                                                                  'Yes',
                                                                  style: TextStyle(
                                                                      color: AppColors
                                                                          .primaryColor),
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: const Align(
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: Icon(
                                                        Icons.lock,
                                                        color: AppColors
                                                            .primaryColor,
                                                        size: 30,
                                                      ),
                                                    ),
                                                  )
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        if (widget.checkListResponseModel
                                                .data![index].isApplicable !=
                                            "N")
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: ExpandChild(
                                              indicatorIconSize: 30,
                                              indicatorAlignment:
                                                  Alignment.bottomRight,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    // height: 130,
                                                    margin: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 10),
                                                    child:
                                                        CheckListCommentTextField(
                                                      initialValue: widget
                                                          .checkListResponseModel
                                                          .data![index]
                                                          .comment!,
                                                      onChangeValue: (value) {
                                                        setState(() {
                                                          widget
                                                              .checkListResponseModel
                                                              .data![index]
                                                              .comment = value;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                      ],
                                    ),
                                  ),
                                )),
                          );
                        }),
                  ),
                ),
                LargeButtonInFooter(
                  buttonTitle: "Submit All",
                  onTap: () {
                    updateCheckList();
                  },
                ),
              ],
            ),
            if (isLoading)
              const Center(
                child: CircularProgressIndicator(),
              )
          ],
        ));
  }

  Future<void> pickedImage(String selectedId, String elId, int index) async {
    image = await picker.pickImage(
        source: ImageSource.camera, imageQuality: ImageValue.qualityValue);
    if (image == null) {
    } else {
      print("Image Path");
      print(image!.path);
      compressedImage = await compressAndGetFile(image!);
      showUploadOption(selectedId, elId, index, compressedImage);
    }
  }

  showUploadOption(String selectedId, String elId, int index, XFile? image1) {
    showPopUpForCheckListImageUpload(context, image1!, () {
      // String currentPosition = "${currentLocation!.latitude},${currentLocation.longitude}";
      // print(currentPosition);
      if (image1 != null) {
        uploadCommentSectionImage(selectedId, elId, index, image1);
      }
    }, selectedId, elId, userId);
  }

  uploadCommentSectionImage(
      String selectedId, String elId, int index, XFile? image1) async {
    print(selectedId);
    print(elId);
    await ImageToCloud()
        .uploadImageToCloud(
            image1!, userId, "capture_photo", LicenseProvider.bucketName)
        .then((imageName) {
      HTTPManager()
          .checkListPostImage(UploadCheckListRequestModel(
              id: selectedId, elId: elId, photoName: imageName))
          .then((value) {
        showToastMessage(true, value.msg.toString());
        Navigator.of(context).pop();
      }).catchError((e) {
        showToastMessage(false, e.toString());
      });
    });
  }

  updateCheckList() {
    setState(() {
      isLoading = true;
    });

    HTTPManager()
        .updateCheckListWithJson(widget.checkListResponseModel)
        .then((value) {
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pop();
      showToastMessage(true, "Check List Updated successfully");
    }).catchError((e) {
      setState(() {
        isLoading = false;
      });
      print(e);
      showToastMessage(false, e.toString());
    });
  }
}
