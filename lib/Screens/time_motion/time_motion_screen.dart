import 'package:c_supervisor/Model/request_model/recruit_suggest.dart';
import 'package:c_supervisor/Model/request_model/time_motion.dart';
import 'package:c_supervisor/Model/response_model/recruit_suggest_responses/recruit_suggest_list_model.dart';
import 'package:c_supervisor/Model/response_model/time_motion_response/time_motion_list_response_model.dart';
import 'package:c_supervisor/Screens/widgets/toast_message_show.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Model/request_model/journey_plan_request.dart';
import '../../Network/http_manager.dart';
import '../utills/app_colors_new.dart';
import '../utills/user_constants.dart';
import '../widgets/error_text_and_button.dart';
import '../widgets/header_background_new.dart';
import '../widgets/header_widgets_new.dart';
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

  List<TimeMotion> timeMotionList = [];

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
        floatingActionButton:  Visibility(
          visible: !isLoading,
          child: FloatingActionButton(
            backgroundColor: AppColors.primaryColor,
            onPressed: () {

              Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                AddTimeMotionScreen(timeMotion: TimeMotion(),isEdit:false))).then((value) {
                getTimeMotionList(false);
              });

            },
            child:const Icon(Icons.add,size: 30,color: AppColors.white,),
          ),
        ),
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
                          : timeMotionList.isEmpty
                          ? const Center(
                        child: Text("No time motion found"),
                      )
                          : ListView.builder(
                          padding: const EdgeInsets.only(bottom: 100),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: timeMotionList.length,
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
                                        Expanded(child: Text("Company: ${timeMotionList[index].companyName}",overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.primaryColor),)),
                                        InkWell(
                                          onTap: () {
                                            Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                                                AddTimeMotionScreen(timeMotion: timeMotionList[index],isEdit:true))).then((value) {
                                              getTimeMotionList(false);
                                            });
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
                                              Icons.edit,
                                              color: AppColors
                                                  .primaryColor,
                                              size: 25,
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            await showDialog<
                                                bool>(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      'Are you sure you want to delete this time motion?'),
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
                                                        deleteTimeMotion(
                                                            index,
                                                            timeMotionList[
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
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text("City: ${timeMotionList[index].cityName!}",overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.primaryColor),),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text("Channel: ${timeMotionList[index].channelName!}",overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.primaryColor),),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text("Time: ${timeMotionList[index].noMinutes!} min",maxLines: 1,overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.primaryColor),),
                                    const SizedBox(
                                      height: 5,
                                    ),
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
                ))
          ],
        ));
  }

  deleteTimeMotion(int index,TimeMotion timeMotion) {
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
