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
import '../widgets/text_fields/search_text_fields.dart';
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

  TextEditingController searchController = TextEditingController();
  List<SpecialVisitListItem> specialVisitSearchList =
  <SpecialVisitListItem>[];

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
    // getTmrUserList(true);
    // getClientList(true);
    // getStoresList(true);
    // getCompaniesList(true);
    // getReasonList(true);

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
      floatingActionButton:  Visibility(
        visible: !isLoading,
        child: FloatingActionButton(
          backgroundColor: AppColors.primaryColor,
          onPressed: () {
            // if(clientList.data!.isNotEmpty && storesList.data!.isNotEmpty && tmrUserList.data!.isNotEmpty && reasonsList.data!.isNotEmpty) {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                  const AddSpecialVisitScreen())).then((value) {
                getSpecialVisitList(false);
              });
            // } else {
            //   showToastMessage(false, "Please refresh your screen");
            // }
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
                        : Column(
                          children: [
                            SearchTextField(
                              controller: searchController,
                              hintText: 'Search With Store Name',
                              onChangeField: onSearchTextFieldChanged,
                            ),
                            Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: isError
                              ? ErrorTextAndButton(
                              onTap: () {
                                getSpecialVisitList(true);

                              },
                              errorText: errorText)
                              : specialVisitList.isEmpty
                              ? const Center(
                            child: Text("No Special visit found"),
                      ) : searchController.text.isNotEmpty
                          ? specialVisitSearchList.isEmpty ? const Center(
                        child: Text("Nothing found with this name"),
                      ) : ListView.builder(
                          padding: const EdgeInsets.only(bottom: 100),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: specialVisitSearchList.length,
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
                                        Expanded(child: Row(
                                          children: [
                                            const Icon(Icons.store,color: AppColors.primaryColor,size: 18,),
                                            const SizedBox(width: 5,),
                                            Text(specialVisitSearchList[index].store!,overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.primaryColor),),
                                          ],
                                        )),
                                        // InkWell(
                                        //   onTap: () async {
                                        //     await showDialog<
                                        //         bool>(
                                        //       context: context,
                                        //       builder: (context) {
                                        //         return AlertDialog(
                                        //           title: const Text(
                                        //               'Are you sure you want to delete this visit?'),
                                        //           actions: [
                                        //             TextButton(
                                        //               onPressed:
                                        //                   () {
                                        //                 Navigator.pop(
                                        //                     context,
                                        //                     false);
                                        //               },
                                        //               child:
                                        //               const Text(
                                        //                 'No',
                                        //                 style: TextStyle(
                                        //                     color:
                                        //                     AppColors.primaryColor),
                                        //               ),
                                        //             ),
                                        //             TextButton(
                                        //               onPressed:
                                        //                   () {
                                        //                 deleteSpecialVisit(
                                        //                     index,
                                        //                     specialVisitList[
                                        //                     index]);
                                        //               },
                                        //               child:
                                        //               const Text(
                                        //                 'Yes',
                                        //                 style: TextStyle(
                                        //                     color:
                                        //                     AppColors.primaryColor),
                                        //               ),
                                        //             ),
                                        //           ],
                                        //         );
                                        //       },
                                        //     );
                                        //   },
                                        //   child: Container(
                                        //     padding:
                                        //     const EdgeInsets
                                        //         .all(5),
                                        //     decoration: BoxDecoration(
                                        //         color: AppColors
                                        //             .white,
                                        //         borderRadius:
                                        //         BorderRadius
                                        //             .circular(
                                        //             50)),
                                        //     child: const Icon(
                                        //       Icons.delete,
                                        //       color: AppColors
                                        //           .redColor,
                                        //       size: 25,
                                        //     ),
                                        //   ),
                                        // )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.person_2_outlined,size: 18,),
                                        const SizedBox(width: 5,),
                                        Text(specialVisitSearchList[index].companyName!,overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.blue),),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Image.asset("assets/myicons/reason.png",width: 18,height: 18,),
                                        const SizedBox(width: 5,),
                                        Text(specialVisitSearchList[index].reason!,overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.blue),),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(Icons.calendar_month,color: AppColors.primaryColor,size: 18,),
                                            const SizedBox(width: 5,),
                                            Text(specialVisitSearchList[index].visitDate!,overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.blue),),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Icon(Icons.watch_later_outlined,color: AppColors.primaryColor,size: 18,),
                                            const SizedBox(width: 5,),
                                            Text(specialVisitSearchList[index].visitTime!,overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.blue),),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          })
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
                                            Expanded(child: Row(
                                              children: [
                                                const Icon(Icons.store, size: 18,color: AppColors.primaryColor,),
                                                const SizedBox(width: 5,),
                                                Text(specialVisitList[index].store!,overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.primaryColor),),
                                              ],
                                            )),
                                            // InkWell(
                                            //   onTap: () async {
                                            //     await showDialog<
                                            //         bool>(
                                            //       context: context,
                                            //       builder: (context) {
                                            //         return AlertDialog(
                                            //           title: const Text(
                                            //               'Are you sure you want to delete this visit?'),
                                            //           actions: [
                                            //             TextButton(
                                            //               onPressed:
                                            //                   () {
                                            //                 Navigator.pop(
                                            //                     context,
                                            //                     false);
                                            //               },
                                            //               child:
                                            //               const Text(
                                            //                 'No',
                                            //                 style: TextStyle(
                                            //                     color:
                                            //                     AppColors.primaryColor),
                                            //               ),
                                            //             ),
                                            //             TextButton(
                                            //               onPressed:
                                            //                   () {
                                            //                 deleteSpecialVisit(
                                            //                     index,
                                            //                     specialVisitList[
                                            //                     index]);
                                            //               },
                                            //               child:
                                            //               const Text(
                                            //                 'Yes',
                                            //                 style: TextStyle(
                                            //                     color:
                                            //                     AppColors.primaryColor),
                                            //               ),
                                            //             ),
                                            //           ],
                                            //         );
                                            //       },
                                            //     );
                                            //   },
                                            //   child: Container(
                                            //     padding:
                                            //     const EdgeInsets
                                            //         .all(5),
                                            //     decoration: BoxDecoration(
                                            //         color: AppColors
                                            //             .white,
                                            //         borderRadius:
                                            //         BorderRadius
                                            //             .circular(
                                            //             50)),
                                            //     child: const Icon(
                                            //       Icons.delete,
                                            //       color: AppColors
                                            //           .redColor,
                                            //       size: 25,
                                            //     ),
                                            //   ),
                                            // )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            const Icon(Icons.person_2_outlined,color: AppColors.primaryColor,size: 18,),
                                            const SizedBox(width: 5,),
                                            Text(specialVisitList[index].companyName!,overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.blue),),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Image.asset("assets/myicons/reason.png",width: 18,height: 18,),
                                            const SizedBox(width: 5,),
                                            Text(specialVisitList[index].reason!,overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.blue),),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(Icons.calendar_month_outlined,color: AppColors.primaryColor,size: 18,),
                                                const SizedBox(width: 5,),
                                                Text(specialVisitList[index].visitDate!,overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.blue),),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Icon(Icons.watch_later_outlined, color: AppColors.primaryColor,size: 18),
                                                const SizedBox(width: 5,),
                                                Text(specialVisitList[index].visitTime!,overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.blue),),
                                              ],
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }),
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
                ))
          ],
        ));
  }

  onSearchTextFieldChanged(String text) async {
    specialVisitSearchList.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    for (SpecialVisitListItem specialVisitListItem in specialVisitList) {
      if (specialVisitListItem.store.toString().toLowerCase().contains(text.toLowerCase())) {
        specialVisitSearchList.add(specialVisitListItem);
      }
    }

    setState(() {});
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
