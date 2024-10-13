import 'package:c_supervisor/Screens/widgets/toast_message_show.dart';
import 'package:c_supervisor/provider/license_provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Model/request_model/image_upload_insde_store_request.dart';
import '../../Model/response_model/journey_responses_plan/journey_plan_response_list.dart';
import '../../Model/response_model/my_coverage_response/uploaded_store_images_list_response.dart';
import '../../Network/api_urls.dart';
import '../../Network/http_manager.dart';
import '../utills/app_colors_new.dart';
import '../utills/user_constants.dart';
import '../widgets/error_text_and_button.dart';
import '../widgets/header_background_new.dart';
import '../widgets/header_widgets_new.dart';

import '../widgets/show_image_in_full_screen.dart';

class MyCoverageGallery extends StatefulWidget {
  const MyCoverageGallery(
      {Key? key, required this.journeyResponseListItemDetails})
      : super(key: key);

  final JourneyResponseListItemDetails journeyResponseListItemDetails;

  @override
  State<MyCoverageGallery> createState() => _MyCoverageGalleryState();
}

class _MyCoverageGalleryState extends State<MyCoverageGallery> {
  String userName = "";
  String userId = "";
  bool isLoading = true;
  bool isDeleteLoading = false;
  List<StoreImageResponseItem> storeImageList = <StoreImageResponseItem>[];
  bool isError = false;
  String errorText = "";

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

    getStoreImageList();
  }

  getStoreImageList() {
    setState(() {
      isLoading = true;
    });

    HTTPManager()
        .storeImagesList(UploadedImagesRequestModel(
      elId: userId,
      workingId: widget.journeyResponseListItemDetails.workingId.toString(),
      storeId: widget.journeyResponseListItemDetails.storeId.toString(),
    ))
        .then((value) {
      setState(() {
        storeImageList = value.data!;
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
      body: HeaderBackgroundNew(
        childWidgets: [
          const HeaderWidgetsNew(
            pageTitle: "My Coverage Gallery",
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
                    : IgnorePointer(
                        ignoring: isDeleteLoading,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          child: isError
                              ? ErrorTextAndButton(
                                  onTap: () {
                                    getStoreImageList();
                                  },
                                  errorText: errorText)
                              : storeImageList.isEmpty
                                  ? const Center(
                                      child: Text("No Images yet"),
                                    )
                                  : GridView.builder(
                                      itemCount: storeImageList.length,
                                      shrinkWrap: true,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        childAspectRatio: (163.5 / 135),
                                        crossAxisCount: 2,
                                      ),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        // print(
                                        //     "${LicenseProvider.imageBasePath + "capture_photo/"}${storeImageList[index].imageName}");
                                        // print("${ApplicationURLs.BASE_URL_IMAGE}${storeImageList[index].imageName}");
                                        return InkWell(
                                          onTap: () {
                                            Navigator.of(context)
                                                .push(
                                              MaterialPageRoute(
                                                builder: (context) => FullImageScreen(
                                                    imageUrl:
                                                        // "${ApplicationURLs.BASE_URL_IMAGE}${storeImageList[index].imageName}"
                                                        "${LicenseProvider.gcsPath}capture_photo/${storeImageList[index].imageName}"
                                                    // "${LicenseProvider.imageBasePath + "capture_photo/"}${storeImageList[index].imageName}",
                                                    ),
                                              ),
                                            )
                                                .then((value) {
                                              getStoreImageList();
                                            });
                                          },
                                          child: Card(
                                              semanticContainer: true,
                                              clipBehavior:
                                                  Clip.antiAliasWithSaveLayer,
                                              shadowColor: Colors.black12,
                                              elevation: 10,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                              child: Stack(
                                                children: [
                                                  Image.network(
                                                    "${LicenseProvider.gcsPath}capture_photo/${storeImageList[index].imageName}",
                                                    // "${ApplicationURLs.BASE_URL_IMAGE}${storeImageList[index].imageName}",
                                                    // "${LicenseProvider.imageBasePath + "capture_photo/"}${storeImageList[index].imageName}",
                                                    fit: BoxFit.cover,
                                                    height: double.infinity,
                                                    width: double.infinity,
                                                    errorBuilder:
                                                        (BuildContext context,
                                                            Object exception,
                                                            StackTrace?
                                                                stackTrace) {
                                                      return const Icon(
                                                        Icons.error,
                                                        color:
                                                            AppColors.redColor,
                                                        size: 35,
                                                      );
                                                    },
                                                    loadingBuilder: (BuildContext
                                                            context,
                                                        Widget child,
                                                        ImageChunkEvent?
                                                            loadingProgress) {
                                                      if (loadingProgress ==
                                                          null) return child;
                                                      return Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          color: AppColors
                                                              .primaryColor,
                                                          value: loadingProgress
                                                                      .expectedTotalBytes !=
                                                                  null
                                                              ? loadingProgress
                                                                      .cumulativeBytesLoaded /
                                                                  loadingProgress
                                                                      .expectedTotalBytes!
                                                              : null,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                  Positioned(
                                                      right: 5,
                                                      top: 5,
                                                      child: InkWell(
                                                        onTap: () async {
                                                          await showDialog<
                                                              bool>(
                                                            context: context,
                                                            builder: (context) {
                                                              return AlertDialog(
                                                                title: const Text(
                                                                    'Are you sure you want to delete this image ?'),
                                                                actions: [
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context,
                                                                          false);
                                                                    },
                                                                    child:
                                                                        const Text(
                                                                      'No',
                                                                      style: TextStyle(
                                                                          color:
                                                                              AppColors.primaryColor),
                                                                    ),
                                                                  ),
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      deleteImageFromStore(
                                                                          index,
                                                                          storeImageList[
                                                                              index]);
                                                                    },
                                                                    child:
                                                                        const Text(
                                                                      'Yes',
                                                                      style: TextStyle(
                                                                          color:
                                                                              AppColors.primaryColor),
                                                                    ),
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          );
                                                        },
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5),
                                                          decoration: BoxDecoration(
                                                              color: AppColors
                                                                  .white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          50)),
                                                          child: const Icon(
                                                            Icons.delete,
                                                            color: AppColors
                                                                .redColor,
                                                            size: 25,
                                                          ),
                                                        ),
                                                      ))
                                                ],
                                              )),
                                        );
                                      },
                                    ),
                        ),
                      ),
                if (isDeleteLoading)
                  const Align(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ))
              ],
            ),
          )
        ],
      ),
    );
  }

  deleteImageFromStore(
      int index, StoreImageResponseItem storeImageResponseItem) {
    setState(() {
      isDeleteLoading = true;
    });

    HTTPManager()
        .storeImagesDelete(DeleteImageRequestModel(
            imageId: storeImageResponseItem.id.toString(),
            storeId: storeImageResponseItem.storeId.toString(),
            elId: storeImageResponseItem.elId.toString(),
            workingId: storeImageResponseItem.workingId.toString()))
        .then((value) {
      setState(() {
        storeImageList.removeAt(index);
        isDeleteLoading = false;
      });
      Navigator.pop(context, false);
      showToastMessageBottom(true, "Image Deleted Successfully");
    }).catchError((e) {
      setState(() {
        isDeleteLoading = false;
      });
      showToastMessageBottom(false, e.toString());
    });
  }
}
