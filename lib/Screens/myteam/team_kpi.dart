import 'package:c_supervisor/Model/response_model/my_team_responses/team_kpi_reponses/feedback_list_response_model.dart';
import 'package:c_supervisor/Model/response_model/my_team_responses/team_kpi_reponses/team_kpi_list_response_model.dart';
import 'package:c_supervisor/Screens/myteam/widgets/bottom_sheets_my_team.dart';
import 'package:c_supervisor/Screens/widgets/toast_message_show.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Model/request_model/journey_plan_request.dart';
import '../../Model/request_model/update_efficiency_feedback_request_model.dart';
import '../../Network/http_manager.dart';
import '../utills/app_colors_new.dart';
import '../utills/user_constants.dart';
import '../widgets/error_text_and_button.dart';
import '../widgets/header_background_new.dart';
import '../widgets/header_widgets_new.dart';

class TeamKpiScreen extends StatefulWidget {
  const TeamKpiScreen({Key? key}) : super(key: key);

  @override
  State<TeamKpiScreen> createState() => _TeamKpiScreenState();
}

class _TeamKpiScreenState extends State<TeamKpiScreen> {

  String userName = "";
  String userId = "";
  int? geoFence;

  bool isLoading = true;
  bool isLoadingLocation = false;

  List<TeamKpiResponseItem> teamKpiList = <TeamKpiResponseItem>[];
  List<FeedbackListItem> feedbackList = <FeedbackListItem>[];
  late FeedbackListItem feedbackListItem;

  bool isError = false;
  String errorText = "";

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

    getTeamKpiList(true);
    getfeedbackListItem(true);
  }

  getfeedbackListItem(bool isLoader) {
    setState(() {
      isLoading = isLoader;
    });


    HTTPManager()
        .getFeedBackList()
        .then((value) {
      setState(() {
        feedbackList = value.data!;
        feedbackListItem = feedbackList[0];
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

  getTeamKpiList(bool isLoader) {
    setState(() {
      isLoading = isLoader;
    });


    HTTPManager()
        .getMyTeamKpiList(JourneyPlanRequestModel(elId: userId))
        .then((value) {
      setState(() {
        teamKpiList = value.data!;

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
        ignoring: isLoading,
        child: HeaderBackgroundNew(
          childWidgets: [
            const HeaderWidgetsNew(
              pageTitle: "Team KPIS",
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
                          getTeamKpiList(true);
                        },
                        errorText: errorText)
                        : teamKpiList.isEmpty
                        ? const Center(
                      child: Text("No history found"),
                    )
                        : ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: teamKpiList.length,
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
                              padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                              child: Column(
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    margin:const EdgeInsets.only(left: 25,bottom: 5,top: 5),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(teamKpiList[index].userName!.toString(),style: const TextStyle(color: AppColors.primaryColor),),
                                        const SizedBox(height: 3,),
                                        Text("ID: ${teamKpiList[index].userId!}",style: const TextStyle(color: AppColors.paleYellow),),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                       Expanded(
                                        child: Container(
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.all(10),
                                          margin: const EdgeInsets.all(2),
                                          decoration:  BoxDecoration(
                                              border: Border.all(color: AppColors.primaryColor,),
                                              borderRadius:const BorderRadius.all(Radius.circular(5))
                                          ),
                                          child: const Column(
                                            children: [
                                              Text("P",style:  TextStyle(color: AppColors.blue)),
                                              Text("ATT",style: TextStyle(color: AppColors.blue),),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.all(10),
                                          margin: const EdgeInsets.all(2),
                                          decoration:  BoxDecoration(
                                              border: Border.all(color: AppColors.primaryColor,),
                                              borderRadius:const BorderRadius.all(Radius.circular(5))
                                          ),
                                          child: Column(
                                            children: [
                                              Text("${teamKpiList[index].compliance} %",style:  const TextStyle(color: AppColors.blue)),
                                              const Text("JPC",style: TextStyle(color: AppColors.blue),),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.all(10),
                                          margin: const EdgeInsets.all(2),
                                          decoration:  BoxDecoration(
                                              border: Border.all(color: AppColors.primaryColor,),
                                              borderRadius:const BorderRadius.all(Radius.circular(5))
                                          ),
                                          child: Column(
                                            children: [
                                              Text("${teamKpiList[index].productivity} %",style:  const TextStyle(color: AppColors.blue)),
                                              const Text("PRO",style: TextStyle(color: AppColors.blue),),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.all(10),
                                          margin: const EdgeInsets.all(2),
                                          decoration:  BoxDecoration(
                                              border: Border.all(color: AppColors.primaryColor,),
                                              borderRadius:const BorderRadius.all(Radius.circular(5))
                                          ),
                                          child: Column(
                                            children: [
                                              Text("${teamKpiList[index].efficiencyN} %",style:  const TextStyle(color: AppColors.blue)),
                                              const Text("EEF",style: TextStyle(color: AppColors.blue),),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5,),
                                  IgnorePointer(
                                    ignoring: false,
                                    child: Container(
                                      margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.2),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          feedbackDropdownBottomSheet(context,feedbackListItem,feedbackList,
                                                  (value){
                                                      setState(() {
                                                        feedbackListItem = value;
                                                      });
                                                  },
                                                  (){
                                            print(feedbackListItem.name);
                                                      Navigator.of(context).pop();
                                            updateFeedbackTeamKpi(index);
                                                  }
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: false
                                              ? AppColors.lightgreytn
                                              : AppColors.primaryColor,
                                          padding: const EdgeInsets.symmetric(vertical: 5),
                                        ),
                                        child: const Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Expanded(child: Text("   Select Your Feedback")),
                                            Icon(Icons.keyboard_arrow_down_outlined,color: AppColors.white,)
                                          ],
                                        ),
                                      ),
                                    ),
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
              ),
            )
          ],
        ),
      ),
    );
  }

  updateFeedbackTeamKpi (int index) {
    print(feedbackListItem.name);
    setState(() {
      isLoadingLocation = true;
    });
      HTTPManager().updateFeedBackInKpi(UpdateEfficiencyFeedbackRequestModel(
        userId: teamKpiList[index].userId.toString(),
        effComment: feedbackListItem.name,
        id:teamKpiList[index].id
      )).then((value) {
        setState(() {
          isLoadingLocation = false;
        });
        getTeamKpiList(false);
        showToastMessage(true, "Feedback added successfully");
      }).catchError((e) {
        setState(() {
          isLoadingLocation = false;
        });
        showToastMessage(false, e.toString());
      });
  }
}
