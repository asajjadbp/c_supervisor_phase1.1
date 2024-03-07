import 'package:c_supervisor/Model/request_model/delete_special_visit.dart';
import 'package:c_supervisor/Model/response_model/my_team_responses/add_special_visit/client_list_model_response.dart';
import 'package:c_supervisor/Model/response_model/my_team_responses/add_special_visit/companies_list_model_response.dart';
import 'package:c_supervisor/Model/response_model/my_team_responses/add_special_visit/reason_list_model_response.dart';
import 'package:c_supervisor/Model/response_model/my_team_responses/add_special_visit/store_list_model_response.dart';
import 'package:c_supervisor/Screens/myteam/widgets/bottom_sheets_my_team.dart';
import 'package:c_supervisor/Screens/widgets/toast_message_show.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Model/request_model/journey_plan_request.dart';
import '../../Model/response_model/my_team_responses/add_special_visit/special_visit_list_model_response.dart';
import '../../Model/response_model/tmr_responses/tmr_list_response.dart';
import '../../Network/http_manager.dart';
import '../utills/app_colors_new.dart';
import '../utills/user_constants.dart';
import '../widgets/error_text_and_button.dart';
import '../widgets/header_background_new.dart';
import '../widgets/header_widgets_new.dart';
import 'add_special_visit_screen.dart';

class SpecialVisitScreen extends StatefulWidget {
  const SpecialVisitScreen({Key? key}) : super(key: key);

  @override
  State<SpecialVisitScreen> createState() => _SpecialVisitScreenState();
}

class _SpecialVisitScreenState extends State<SpecialVisitScreen> {

  String userName = "";
  String userId = "";
  int? geoFence;
  late TmrUserItem tmrUserItem;

  bool isLoading = true;
  bool isLoadingLocation = false;
  bool isError = false;
  String errorText = "";

  List<SpecialVisitListItem> specialVisitList = [];
  late TmrUserList tmrUserList;
  late ClientListResponseModel clientList;
  late StoresListResponseModel storesList;
  late CompaniesListResponseModel companiesList;
  late ReasonListResponseModel reasonsList;

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

    getSpecialVisitList(true);
    getTmrUserList(true);
    getClientList(true);
    getStoresList(true);
    getCompaniesList(true);
    getReasonList(true);

    // getJourneyPlanList(true);
  }

  getSpecialVisitList(bool loader) {

    setState(() {
      isLoading = loader;
    });

    HTTPManager()
        .specialVisitList(JourneyPlanRequestModel(
      elId: userId,))
        .then((value) {
      setState(() {

        specialVisitList = value.data!;
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

  getTmrUserList(bool loader) {

    setState(() {
      isLoading = loader;
    });

    HTTPManager()
        .tmrUserList(JourneyPlanRequestModel(
      elId: userId,))
        .then((value) {
      setState(() {

        tmrUserList = value;
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

  getClientList(bool loader) {

    setState(() {
      isLoading = loader;
    });

    HTTPManager()
        .clientList(JourneyPlanRequestModel(
      elId: userId,))
        .then((value) {
      setState(() {

        clientList = value;
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

  getStoresList(bool loader) {

    setState(() {
      isLoading = loader;
    });

    HTTPManager()
        .storeList(JourneyPlanRequestModel(
      elId: userId,))
        .then((value) {
      setState(() {

        storesList = value;
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

  getCompaniesList(bool loader) {

    setState(() {
      isLoading = loader;
    });

    HTTPManager()
        .companyList(JourneyPlanRequestModel(
      elId: userId,))
        .then((value) {
      setState(() {

        companiesList = value;
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

  getReasonList(bool loader) {

    setState(() {
      isLoading = loader;
    });

    HTTPManager()
        .reasonList()
        .then((value) {
      setState(() {

        reasonsList = value;
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
      floatingActionButton:  FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        onPressed: () {

          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AddSpecialVisitScreen(
            clientList: clientList,
            storesList: storesList,
            tmrUserList: tmrUserList,
            reasonsList: reasonsList,
          ))).then((value) {
            getSpecialVisitList(false);
          });
          // addSpecialVisitDropdownBottomSheet(context,
          //   initialClientList,clientList.data!,(value){setState(() {
          //     initialClientList = value;
          //   });},
          //     initialStoresList,storesList.data!,(value){setState(() {
          //       initialStoresList = value;
          //     });},
          //     initialTmrUserList,tmrUserList.data!,(value){setState(() {
          //       initialTmrUserList = value;
          //     });},
          //     initialReasonsList,reasonsList.data!,(value){setState(() {
          //       initialReasonsList = value;
          //     });},(){
          //
          //     }
          // );
        },
        child:const Icon(Icons.add,size: 30,color: AppColors.white,),
      ),
        body: HeaderBackgroundNew(
          childWidgets: [
            const HeaderWidgetsNew(
              pageTitle: "Special Visits",
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

                            getSpecialVisitList(true);
                            getTmrUserList(true);
                            getClientList(true);
                            getStoresList(true);
                            getCompaniesList(true);
                            getReasonList(true);

                          },
                          errorText: errorText)
                          : specialVisitList.isEmpty
                          ? const Center(
                        child: Text("No Special visit found"),
                      )
                          : ListView.builder(
                          padding: const EdgeInsets.only(bottom: 100),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: specialVisitList.length,
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
                                        Expanded(child: Text("Store: ${specialVisitList[index].store!}",overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.primaryColor),)),
                                        InkWell(
                                          onTap: () async {
                                            await showDialog<
                                                bool>(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      'Are you sure you want to delete this visit?'),
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
                                                        deleteSpecialVisit(
                                                            index,
                                                            specialVisitList[
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
                                    Text("Company: ${specialVisitList[index].companyName!}",overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.blue),),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(specialVisitList[index].reason!,overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.blue),),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text("Date: ${specialVisitList[index].visitDate!}",overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.blue),),
                                        Text("Time: ${specialVisitList[index].visitTime!}",overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.blue),),
                                      ],
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
                ))
          ],
        ));
  }

  deleteSpecialVisit(int index,SpecialVisitListItem specialVisitListItem) {
    setState(() {
      isLoadingLocation = true;
    });
    print(userId);
    print(specialVisitListItem.id);

    HTTPManager().deleteSpecialVisit(DeleteSpecialVisitRequestModel(elId: userId,id: specialVisitListItem.id.toString())).then((value) {
      specialVisitList.removeAt(index);
      setState(() {
        isLoadingLocation = false;
      });
      Navigator.of(context).pop();
      showToastMessage(true, "Visit deleted Successfully");
    }).catchError((e) {
      showToastMessage(false, e.toString());
      setState(() {
        isLoadingLocation = false;
      });
    });
  }
}
