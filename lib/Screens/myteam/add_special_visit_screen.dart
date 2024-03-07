import 'package:c_supervisor/Network/http_manager.dart';
import 'package:c_supervisor/Screens/widgets/toast_message_show.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Model/request_model/save_special_visit.dart';
import '../../Model/response_model/my_team_responses/add_special_visit/client_list_model_response.dart';
import '../../Model/response_model/my_team_responses/add_special_visit/reason_list_model_response.dart';
import '../../Model/response_model/my_team_responses/add_special_visit/store_list_model_response.dart';
import '../../Model/response_model/tmr_responses/tmr_list_response.dart';
import '../utills/app_colors_new.dart';
import '../utills/user_constants.dart';
import '../widgets/header_background_new.dart';
import '../widgets/header_widgets_new.dart';
import 'package:intl/intl.dart';

class AddSpecialVisitScreen extends StatefulWidget {
  const AddSpecialVisitScreen({Key? key,required this.clientList,required this.storesList,required this.tmrUserList,required this.reasonsList}) : super(key: key);

  final TmrUserList tmrUserList;
  final ClientListResponseModel clientList;
  final StoresListResponseModel storesList;
  final ReasonListResponseModel reasonsList;

  @override
  State<AddSpecialVisitScreen> createState() => _AddSpecialVisitScreenState();
}

class _AddSpecialVisitScreenState extends State<AddSpecialVisitScreen> {

  late TmrUserItem initialTmrUserList;
  late ClientListItem initialClientList;
   late StoresListItem initialStoresList;
   late ReasonListItem initialReasonsList;

  String userName = "";
  String userId = "";
  int? geoFence;

   bool isLoading = false;

  DateTime selectedDate = DateTime.now();
  String formattedTime = "--:-- --";
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2201));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
  
   @override
  void initState() {
    // TODO: implement initState
    setState(() {
      initialClientList = widget.clientList.data![0];
      initialStoresList = widget.storesList.data![0];
      initialTmrUserList = widget.tmrUserList.data![0];
      initialReasonsList = widget.reasonsList.data![0];
    });
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
    // getJourneyPlanList(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HeaderBackgroundNew(
        childWidgets: [
          const HeaderWidgetsNew(
            pageTitle: "Add Special Visit",
            isBackButton: true,
            isDrawerButton: true,
          ),
          Expanded(
              child: IgnorePointer(
                ignoring: isLoading,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 50,),
                            const Text("  Select Client",style: TextStyle(color: AppColors.primaryColor),),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              margin:const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                              decoration: BoxDecoration(
                                  border: Border.all(color: AppColors.primaryColor)
                              ),
                              child: DropdownButtonHideUnderline(
                                  child: DropdownButton<ClientListItem>(
                                      value: initialClientList,
                                      isExpanded: true,
                                      items: widget.clientList.data!.map((ClientListItem items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text(items.companyName!,overflow: TextOverflow.ellipsis,),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState((){
                                          initialClientList = value!;
                                        });
                                      })),
                            ),
                            const SizedBox(height: 5,),
                            const Text("  Select Store",style: TextStyle(color: AppColors.primaryColor),),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              margin:const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                              decoration: BoxDecoration(
                                  border: Border.all(color: AppColors.primaryColor)
                              ),
                              child: DropdownButtonHideUnderline(
                                  child: DropdownButton<StoresListItem>(
                                      value: initialStoresList,
                                      isExpanded: true,
                                      items: widget.storesList.data!.map((StoresListItem items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text(items.name!,overflow: TextOverflow.ellipsis,),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState((){
                                          initialStoresList = value!;
                                        });
                                      })),
                            ),
                            const SizedBox(height: 5,),
                            const Text("  Select TMR",style: TextStyle(color: AppColors.primaryColor),),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              margin:const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                              decoration: BoxDecoration(
                                  border: Border.all(color: AppColors.primaryColor)
                              ),
                              child: DropdownButtonHideUnderline(
                                  child: DropdownButton<TmrUserItem>(
                                      value: initialTmrUserList,
                                      isExpanded: true,
                                      items: widget.tmrUserList.data!.map((TmrUserItem items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text(items.fullName!,overflow: TextOverflow.ellipsis,),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState((){
                                          initialTmrUserList = value!;
                                        });
                                      })),
                            ),
                            const SizedBox(height: 5,),
                            const Text("  Select Reason",style: TextStyle(color: AppColors.primaryColor),),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              margin:const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                              decoration: BoxDecoration(
                                  border: Border.all(color: AppColors.primaryColor)
                              ),
                              child: DropdownButtonHideUnderline(
                                  child: DropdownButton<ReasonListItem>(
                                      value: initialReasonsList,
                                      isExpanded: true,
                                      items: widget.reasonsList.data!.map((ReasonListItem items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text(items.reason!,overflow: TextOverflow.ellipsis,),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          initialReasonsList = value!;
                                        });
                                      })),
                            ),
                            const SizedBox(height: 5,),
                            const Text("  Select Date",style: TextStyle(color: AppColors.primaryColor),),
                            InkWell(
                              onTap: ()=>_selectDate(context),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                                margin:const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                                decoration: BoxDecoration(
                                    border: Border.all(color: AppColors.primaryColor)
                                ),
                                child: Text(DateFormat('MM/dd/yyyy').format(selectedDate)),
                              ),
                            ),
                            const SizedBox(height: 5,),
                            const Text("  Select Time",style: TextStyle(color: AppColors.primaryColor),),
                            InkWell(
                              onTap: () async {
                                TimeOfDay? pickedTime =  await showTimePicker(
                                  initialTime: TimeOfDay.now(),
                                  context: context, //context of current state
                                );

                                if(pickedTime != null ){

                                  DateTime parsedTime = DateFormat.jm().parse(pickedTime.format(context).toString());

                                  setState(() {
                                    formattedTime = DateFormat('HH:mm:ss').format(parsedTime);
                                  });

                                }else{
                                  print("Time is not selected");
                                }
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                                margin:const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                                decoration: BoxDecoration(
                                    border: Border.all(color: AppColors.primaryColor)
                                ),
                                child: Text(formattedTime),
                              ),
                            ),
                            const SizedBox(height:5),
                            ElevatedButton(
                              onPressed: () {
                                if(formattedTime != "--:-- --") {
                                  addSpecialVisit();
                                } else {
                                  showToastMessage(false, "Please select a date");
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                padding: EdgeInsets.symmetric(
                                    horizontal: MediaQuery.of(context).size.width/4, vertical: 10),
                              ),
                              child: const Text("Submit"),
                            ),
                            const SizedBox(height: 5,),
                          ],
                        ),
                      ),
                    ),
                    if(isLoading)
                      const CircularProgressIndicator(color: AppColors.primaryColor,),
                  ],
                ),
              ))
        ],
      ),
    );
  }
  addSpecialVisit() {
    setState(() {
      isLoading = true;
    });
    HTTPManager().saveSpecialVisit(SaveSpecialVisitRequestModel(
      elId: userId,
      companyId: initialClientList.companyId.toString(),
      storeId: initialStoresList.id.toString(),
      reason: initialReasonsList.reason,
      userId: initialTmrUserList.id.toString(),
      visitDate: DateFormat('MM/dd/yyyy').format(selectedDate),
      visitTime: formattedTime,
    )).then((value) {

      print(value);

      showToastMessage(true,"Special visit added successfully");
      Navigator.of(context).pop();
      setState(() {
        isLoading = false;
      });
    }).catchError((e) {
      print(e.toString());
      showToastMessage(false,e.toString());
      setState(() {
        isLoading = false;
      });
    });


  }
}
