import 'package:c_supervisor/Model/response_model/my_team_responses/visits_history_responses/visit_history_list_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Model/request_model/journey_plan_request.dart';
import '../../Network/http_manager.dart';
import '../utills/app_colors_new.dart';
import '../utills/user_constants.dart';
import '../widgets/error_text_and_button.dart';
import '../widgets/header_background_new.dart';
import '../widgets/header_widgets_new.dart';

class VisitHistory extends StatefulWidget {
  const VisitHistory({Key? key}) : super(key: key);

  @override
  State<VisitHistory> createState() => _VisitHistoryState();
}

class _VisitHistoryState extends State<VisitHistory> {

  String userName = "";
  String userId = "";
  int? geoFence;

  bool isLoading = true;
  bool isLoadingLocation = false;

  List<VisitsHistoryResponseItem> visitHistoryList = <VisitsHistoryResponseItem>[];

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

    getVisitsHistoryList(true);
  }


  getVisitsHistoryList(bool isLoader) {
    setState(() {
      isLoading = isLoader;
    });


    HTTPManager()
        .getVisitHistoryList(JourneyPlanRequestModel(elId: userId))
        .then((value) {
      setState(() {
        visitHistoryList = value.data!;

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
              pageTitle: "Visit History",
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
                          getVisitsHistoryList(true);
                        },
                        errorText: errorText)
                        : visitHistoryList.isEmpty
                        ? const Center(
                      child: Text("No history found"),
                    )
                        : ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: visitHistoryList.length,
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
                                        Text(visitHistoryList[index].storeName!,style: const TextStyle(color: AppColors.primaryColor),),
                                        const SizedBox(height: 3,),
                                        Text(visitHistoryList[index].companyName!,style: const TextStyle(color: AppColors.paleYellow),),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          children: [
                                            const Text("Check In",style:  TextStyle(color: AppColors.greyColor)),
                                            Text(visitHistoryList[index].checkInTime!,style: const TextStyle(color: AppColors.primaryColor),),
                                          ],
                                        ),
                                      ),
                                      const Text("|",style:  TextStyle(color: AppColors.greyColor)),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            const Text("Check Out",style:  TextStyle(color: AppColors.greyColor)),
                                            Text(visitHistoryList[index].checkOutTime!,style: const TextStyle(color: AppColors.primaryColor),),
                                          ],
                                        ),
                                      ),
                                      const Text("|",style:  TextStyle(color: AppColors.greyColor)),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            const Text("Working HRS",style:  TextStyle(color: AppColors.greyColor)),
                                            Text(visitHistoryList[index].workingHours!,style: const TextStyle(color: AppColors.primaryColor),),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5,),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Container(
                                        decoration: BoxDecoration(
                                          color: visitHistoryList[index].isAvailability == 1 ? AppColors.blue : AppColors.white,
                                          border: Border.all(color: AppColors.blue),
                                          borderRadius: BorderRadius.circular(5)
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: 2,vertical: 5),
                                        child:   Center(child: Text("AVL",style: TextStyle(color: visitHistoryList[index].isAvailability == 1 ? AppColors.white : AppColors.blue),)),
                                      )),
                                      const SizedBox(width: 3,),
                                      Expanded(child: Container(
                                        decoration: BoxDecoration(
                                            color: visitHistoryList[index].isFreshness == 1 ? AppColors.blue : AppColors.white,
                                            border: Border.all(color: AppColors.blue),
                                            borderRadius: BorderRadius.circular(5)
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: 2,vertical: 5),
                                        child:   Center(child: Text("FRES",style: TextStyle(color: visitHistoryList[index].isFreshness == 1 ? AppColors.white : AppColors.blue),)),
                                      )),
                                      const SizedBox(width: 3,),
                                      Expanded(child: Container(
                                        decoration: BoxDecoration(
                                            color: visitHistoryList[index].isPlanogram == 1 ? AppColors.blue : AppColors.white,
                                            border: Border.all(color: AppColors.blue),
                                            borderRadius: BorderRadius.circular(5)
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: 2,vertical: 5),
                                        child:   Center(child: Text("PLANO",style: TextStyle(color: visitHistoryList[index].isPlanogram == 1 ? AppColors.white : AppColors.blue),)),
                                      )),
                                      const SizedBox(width: 3,),
                                      Expanded(
                                          child: Container(
                                        decoration: BoxDecoration(
                                            color: visitHistoryList[index].isSos == 1 ? AppColors.blue : AppColors.white,
                                            border: Border.all(color: AppColors.blue),
                                            borderRadius: BorderRadius.circular(5)
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: 2,vertical: 5),
                                        child:  Center(child: Text("SOS",style: TextStyle(color: visitHistoryList[index].isSos == 1 ? AppColors.white : AppColors.blue),)),
                                      )),
                                      const SizedBox(width: 3,),
                                      Expanded(child: Container(
                                        decoration: BoxDecoration(
                                            color: visitHistoryList[index].isRtv == 1 ? AppColors.blue : AppColors.white,
                                            border: Border.all(color: AppColors.blue),
                                            borderRadius: BorderRadius.circular(5)
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: 2,vertical: 5),
                                        child:  Center(child: Text("RTV",style: TextStyle(color: visitHistoryList[index].isRtv == 1 ? AppColors.white : AppColors.blue),)),
                                      )),

                                    ],
                                  ),
                                  const SizedBox(height: 5,),
                                  // IgnorePointer(
                                  //   ignoring: false,
                                  //   child: ElevatedButton(
                                  //     onPressed: () {
                                  //
                                  //     },
                                  //     style: ElevatedButton.styleFrom(
                                  //       backgroundColor: false
                                  //           ? AppColors.lightgreytn
                                  //           : AppColors.primaryColor,
                                  //       padding: EdgeInsets.symmetric(
                                  //           horizontal: MediaQuery.of(context).size.width/3, vertical: 10),
                                  //     ),
                                  //     child: const Text("INSPECT"),
                                  //   ),
                                  // ),
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
}
