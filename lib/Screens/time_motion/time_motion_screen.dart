import 'package:c_supervisor/Model/request_model/recruit_suggest.dart';
import 'package:c_supervisor/Model/request_model/time_motion.dart';
import 'package:c_supervisor/Model/response_model/recruit_suggest_responses/recruit_suggest_list_model.dart';
import 'package:c_supervisor/Model/response_model/time_motion_response/time_motion_list_response_model.dart';
import 'package:c_supervisor/Screens/time_motion/widgets/custom_minutes_text_fields.dart';
import 'package:c_supervisor/Screens/widgets/toast_message_show.dart';
import 'package:expand_widget/expand_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Model/request_model/journey_plan_request.dart';
import '../../Network/http_manager.dart';
import '../utills/app_colors_new.dart';
import '../utills/user_constants.dart';
import '../widgets/error_text_and_button.dart';
import '../widgets/header_background_new.dart';
import '../widgets/header_widgets_new.dart';
import '../widgets/large_button_in_footer.dart';
import 'add_time_motion_screen.dart';

class TimeMotionScreen extends StatefulWidget {
  const TimeMotionScreen({Key? key}) : super(key: key);

  @override
  State<TimeMotionScreen> createState() => _TimeMotionScreenState();
}

class _TimeMotionScreenState extends State<TimeMotionScreen> {

  String userName = "";
  String userId = "";
  int? geoFence;

  bool isLoading = true;
  bool isLoadingLocation = false;
  bool isError = false;
  String errorText = "";

  late TimeMotionListModel timeMotionListModel;

  List<TimeMotionItem> timeMotionList = [];

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

    getTimeMotionList(true);

  }

  getTimeMotionList(bool loader) {

    setState(() {
      isLoading = loader;
    });

    HTTPManager()
        .getTimeMotion(JourneyPlanRequestModel(
      elId: userId,))
        .then((value) {
      setState(() {
        timeMotionListModel = value;
        timeMotionList = value.data!;
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
        // floatingActionButton:  Visibility(
        //   visible: !isLoading,
        //   child: FloatingActionButton(
        //     backgroundColor: AppColors.primaryColor,
        //     onPressed: () {
        //
        //       Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
        //         AddTimeMotionScreen(timeMotion: TimeMotionItem(),isEdit:false))).then((value) {
        //         getTimeMotionList(false);
        //       });
        //
        //     },
        //     child:const Icon(Icons.add,size: 30,color: AppColors.white,),
        //   ),
        // ),
        body: HeaderBackgroundNew(
          childWidgets: [
            const HeaderWidgetsNew(
              pageTitle: "Time Motion Study",
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
                        : Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: isError
                          ? ErrorTextAndButton(
                          onTap: () {
                            getTimeMotionList(true);
                          },
                          errorText: errorText)
                          : timeMotionListModel.data!.isEmpty
                          ? const Center(
                        child: Text("No time motion found"),
                      )
                          : ListView.builder(
                          padding: const EdgeInsets.only(bottom: 100),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: timeMotionListModel.data!.length,
                          itemBuilder: (context, index) {
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              semanticContainer: true,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              shadowColor: Colors.black12,
                              elevation: 10,
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset("assets/myicons/company_icon.png",width: 18,height: 18,),
                                        const SizedBox(width: 5,),
                                        Text(timeMotionListModel.data![index].companyName!.toString(),overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.blue),),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Image.asset("assets/myicons/channel_icon.png",width: 18,height: 18,),
                                        const SizedBox(width: 5,),
                                        Text(timeMotionListModel.data![index].channelName!.toString(),overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.blue),),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Image.asset("assets/myicons/city_icon.png",width: 18,height: 18,),
                                        const SizedBox(width: 5,),
                                        Text(timeMotionListModel.data![index].cityName!.toString(),overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.primaryColor),),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Image.asset("assets/myicons/store_icon.png",width: 18,height: 18,),
                                        const SizedBox(width: 5,),
                                        Text(timeMotionListModel.data![index].storeName!.toString(),overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.primaryColor),),
                                      ],
                                    ),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: ExpandChild(
                                        indicatorIconSize: 30,
                                        indicatorAlignment:
                                        Alignment.bottomRight,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const  SizedBox(height: 10,),
                                            const Text("Categories",overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 20,color: AppColors.primaryColor),),
                                            ListView.builder(
                                              padding: const EdgeInsets.all(10),
                                              shrinkWrap: true,
                                                physics: const NeverScrollableScrollPhysics(),
                                                itemCount: timeMotionListModel.data![index].categories!.length,
                                                itemBuilder: (context,index1) {
                                                  return  Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(timeMotionListModel.data![index].categories![index1].categoryName!),
                                                      Container(
                                                        // height: 130,
                                                          margin: const EdgeInsets
                                                              .symmetric(vertical: 10),
                                                          child:
                                                          MinutesTextField(initialValue: timeMotionListModel.data![index].categories![index1].noMinutes!.toString(), onChangeValue: (value) {
                                                            setState(() {
                                                              timeMotionListModel.data![index].categories![index1].noMinutes = value;
                                                            });
                                                          })
                                                      ),
                                                    ],
                                                  );
                                                }),
                                          ],
                                        )
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                    if (isLoadingLocation)
                      const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
                      )
                  ],
                )),
            LargeButtonInFooter(
              buttonTitle: "Update Categories",
              onTap: (){
                updateTimeMotionStudy();
              },
            )
          ],
        ));
  }
  updateTimeMotionStudy() {
    setState(() {
      isLoadingLocation = true;
    });

    HTTPManager().updateTimeMotion(timeMotionListModel).then((value) {
      setState(() {
        isLoadingLocation = false;
      });

      showToastMessage(true, "Time motion updated successfully");
    }).catchError((e) {
      setState(() {
        isLoadingLocation = false;
      });
      showToastMessage(false, e.toString());
    });

  }
  deleteTimeMotion(int index,TimeMotionItem timeMotion) {
    setState(() {
      isLoadingLocation = true;
    });

    HTTPManager().deleteTimeMotion(DeleteTimeMotionRequestModel(elId: userId,id: timeMotionList[index].id.toString())).then((value) {
      timeMotionList.removeAt(index);
      setState(() {
        isLoadingLocation = false;
      });
      Navigator.of(context).pop();
      showToastMessage(true, "Recruit deleted Successfully");
    }).catchError((e) {
      showToastMessage(false, e.toString());
      setState(() {
        isLoadingLocation = false;
      });
    });
  }
}
