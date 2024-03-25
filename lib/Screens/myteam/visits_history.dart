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
import '../widgets/text_fields/search_text_fields.dart';

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

  List<VisitsHistoryResponseItem> visitHistorySearchList =
  <VisitsHistoryResponseItem>[];

  TextEditingController searchController = TextEditingController();

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

    if (visitHistorySearchList.isNotEmpty) {
      visitHistorySearchList = <VisitsHistoryResponseItem>[];
      searchController.clear();
      FocusScope.of(context).unfocus();
    }

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
                      : Column(
                        children: [
                          SearchTextField(
                            controller: searchController,
                            hintText: 'Search With Store Name',
                            onChangeField: onSearchTextFieldChanged,
                          ),
                          Expanded(
                            child: Container(
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
                              : searchController.text.isNotEmpty
                        ? visitHistorySearchList.isEmpty ? const Center(
                      child: Text("Nothing found with this name"),
                    ) : ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: visitHistorySearchList.length,
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
                                        Row(
                                          children: [
                                            const Icon(Icons.person_2_outlined,size: 18,),
                                            const SizedBox(width: 5,),
                                            Expanded(child: Text(visitHistorySearchList[index].fullName!,overflow: TextOverflow.ellipsis,maxLines: 1,style: const TextStyle(color: AppColors.primaryColor),)),
                                          ],
                                        ),
                                        const SizedBox(height: 5,),
                                        Row(
                                          children: [
                                            const Icon(Icons.store,color: AppColors.primaryColor,size: 18,),
                                            const SizedBox(width: 5,),
                                            Text(visitHistorySearchList[index].storeName!,style: const TextStyle(color: AppColors.primaryColor),),
                                          ],
                                        ),
                                        const SizedBox(height: 3,),
                                        Row(
                                          children: [
                                            Image.asset("assets/myicons/company_icon.png",width: 18,height: 18,),
                                            const SizedBox(width: 5,),
                                            Text(visitHistorySearchList[index].companyName!,style: const TextStyle(color: AppColors.primaryColor),),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Image.asset("assets/myicons/check_in_icon.png",width: 18,height: 18,),
                                            const SizedBox(width: 5,),
                                            Text(visitHistorySearchList[index].checkInTime!,style: const TextStyle(color: AppColors.primaryColor),),
                                          ],
                                        ),
                                      ),
                                      const Text("|",style:  TextStyle(color: AppColors.greyColor)),
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Image.asset("assets/myicons/check_out_icon.png",width: 18,height: 18,),
                                            const SizedBox(width: 5,),
                                            Text(visitHistorySearchList[index].checkOutTime!,style: const TextStyle(color: AppColors.primaryColor),),
                                          ],
                                        ),
                                      ),
                                      const Text("|",style:  TextStyle(color: AppColors.greyColor)),
                                      Expanded(
                                        child: Row(
                                          children: [
                                            const Icon(Icons.watch_later_outlined,color: AppColors.primaryColor,size: 18,),
                                            const SizedBox(width: 5,),
                                            Text(visitHistorySearchList[index].workingHours!,style: const TextStyle(color: AppColors.primaryColor),),
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
                                                color: visitHistorySearchList[index].isAvailability == 1 ? AppColors.blue : AppColors.white,
                                                border: Border.all(color: AppColors.blue),
                                                borderRadius: BorderRadius.circular(5)
                                            ),
                                            padding: const EdgeInsets.symmetric(horizontal: 2,vertical: 5),
                                            child:   Center(child: Text("AVL",style: TextStyle(color: visitHistorySearchList[index].isAvailability == 1 ? AppColors.white : AppColors.blue),)),
                                          )),
                                      const SizedBox(width: 3,),
                                      Expanded(child: Container(
                                        decoration: BoxDecoration(
                                            color: visitHistorySearchList[index].isFreshness == 1 ? AppColors.blue : AppColors.white,
                                            border: Border.all(color: AppColors.blue),
                                            borderRadius: BorderRadius.circular(5)
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: 2,vertical: 5),
                                        child:   Center(child: Text("FRES",style: TextStyle(color: visitHistorySearchList[index].isFreshness == 1 ? AppColors.white : AppColors.blue),)),
                                      )),
                                      const SizedBox(width: 3,),
                                      Expanded(child: Container(
                                        decoration: BoxDecoration(
                                            color: visitHistorySearchList[index].isPlanogram == 1 ? AppColors.blue : AppColors.white,
                                            border: Border.all(color: AppColors.blue),
                                            borderRadius: BorderRadius.circular(5)
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: 2,vertical: 5),
                                        child:   Center(child: Text("PLANO",style: TextStyle(color: visitHistorySearchList[index].isPlanogram == 1 ? AppColors.white : AppColors.blue),)),
                                      )),
                                      const SizedBox(width: 3,),
                                      Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: visitHistorySearchList[index].isSos == 1 ? AppColors.blue : AppColors.white,
                                                border: Border.all(color: AppColors.blue),
                                                borderRadius: BorderRadius.circular(5)
                                            ),
                                            padding: const EdgeInsets.symmetric(horizontal: 2,vertical: 5),
                                            child:  Center(child: Text("SOS",style: TextStyle(color: visitHistorySearchList[index].isSos == 1 ? AppColors.white : AppColors.blue),)),
                                          )),
                                      const SizedBox(width: 3,),
                                      Expanded(child: Container(
                                        decoration: BoxDecoration(
                                            color: visitHistorySearchList[index].isRtv == 1 ? AppColors.blue : AppColors.white,
                                            border: Border.all(color: AppColors.blue),
                                            borderRadius: BorderRadius.circular(5)
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: 2,vertical: 5),
                                        child:  Center(child: Text("RTV",style: TextStyle(color: visitHistorySearchList[index].isRtv == 1 ? AppColors.white : AppColors.blue),)),
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
                        })
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
                                              Row(
                                                children: [
                                                  const Icon(Icons.person_2_outlined,size: 18,),
                                                  const SizedBox(width: 5,),
                                                  Expanded(child: Text(visitHistoryList[index].fullName!,overflow: TextOverflow.ellipsis,maxLines: 1,style: const TextStyle(color: AppColors.primaryColor),)),
                                                ],
                                              ),
                                              const SizedBox(height: 5,),
                                              Row(
                                                children: [
                                                  const Icon(Icons.store,color: AppColors.primaryColor,size: 18,),
                                                  const SizedBox(width: 5,),
                                                  Text(visitHistoryList[index].storeName!,style: const TextStyle(color: AppColors.primaryColor),),
                                                ],
                                              ),
                                              const SizedBox(height: 3,),
                                              Row(
                                                children: [
                                                  Image.asset("assets/myicons/company_icon.png",width: 18,height: 18,),
                                                  const SizedBox(width: 5,),
                                                  Text(visitHistoryList[index].companyName!,style: const TextStyle(color: AppColors.primaryColor),),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  Image.asset("assets/myicons/check_in_icon.png",width: 18,height: 18,),
                                                  const SizedBox(width: 5,),
                                                  Expanded(child: Text(visitHistoryList[index].checkInTime!,style: const TextStyle(color: AppColors.primaryColor),)),
                                                ],
                                              ),
                                            ),
                                            const Text("|",style:  TextStyle(color: AppColors.greyColor)),
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  Image.asset("assets/myicons/check_out_icon.png",width: 18,height: 18,),
                                                  const SizedBox(width: 5,),
                                                  Expanded(child: Text(visitHistoryList[index].checkOutTime!,style: const TextStyle(color: AppColors.primaryColor),)),
                                                ],
                                              ),
                                            ),
                                            const Text("|",style:  TextStyle(color: AppColors.greyColor)),
                                            Expanded(
                                              child: Row(
                                                children: [
                                                 const Icon(Icons.watch_later_outlined,color: AppColors.primaryColor,size: 18,),
                                                  const SizedBox(width: 5,),
                                                  Expanded(child: Text(visitHistoryList[index].workingHours!,style: const TextStyle(color: AppColors.primaryColor),)),
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
            )
          ],
        ),
      ),
    );
  }

  onSearchTextFieldChanged(String text) async {
    visitHistorySearchList.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    for (VisitsHistoryResponseItem visitHistoryItem in visitHistoryList) {
      if (visitHistoryItem.storeName.toString().toLowerCase().contains(text.toLowerCase())) {
        visitHistorySearchList.add(visitHistoryItem);
      }
    }

    setState(() {});
  }

}
