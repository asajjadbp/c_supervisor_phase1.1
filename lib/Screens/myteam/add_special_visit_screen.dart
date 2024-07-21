import 'dart:convert';

import 'package:c_supervisor/Model/response_model/common_list/comon_list_response_model.dart';
import 'package:c_supervisor/Network/http_manager.dart';
import 'package:c_supervisor/Screens/widgets/toast_message_show.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Model/request_model/journey_plan_request.dart';
import '../../Model/request_model/save_special_visit.dart';
import '../../Model/response_model/my_team_responses/add_special_visit/client_list_model_response.dart';
import '../../Model/response_model/my_team_responses/add_special_visit/companies_list_model_response.dart';
import '../../Model/response_model/my_team_responses/add_special_visit/reason_list_model_response.dart';
import '../../Model/response_model/my_team_responses/add_special_visit/store_list_model_response.dart';
import '../../Model/response_model/tmr_responses/tmr_list_response.dart';
import '../recruite_suggest/widgets/recruite_suggest_bottom_sheets.dart';
import '../utills/app_colors_new.dart';
import '../utills/user_constants.dart';
import '../widgets/header_background_new.dart';
import '../widgets/header_widgets_new.dart';
import 'package:intl/intl.dart';

class AddSpecialVisitScreen extends StatefulWidget {
  const AddSpecialVisitScreen({Key? key,}) : super(key: key);


  @override
  State<AddSpecialVisitScreen> createState() => _AddSpecialVisitScreenState();
}

class _AddSpecialVisitScreenState extends State<AddSpecialVisitScreen> {

  late TmrUserItem initialTmrUserList;
  late ClientListItem initialClientList;
   late StoresListItem initialStoresList;
  late StoresListItem initialCitiesList;
  late StoresListItem initialChainList;
  late StoresListItem initialRegionList;
   late ReasonListItem initialReasonsList;

  late SingleValueDropDownController _valueDropDownController;
  late SingleValueDropDownController _chainValueDropDownController;
  late SingleValueDropDownController _clientValueDropDownController;


  List <TmrUserItem> tmrUserList = <TmrUserItem>[TmrUserItem(id: 0,fullName: "Select Tmr",email: "")];
  late ClientListResponseModel clientList;
  late StoresListResponseModel storesList;
  late StoresListResponseModel citiesList;
  late StoresListResponseModel chainList;
  late StoresListResponseModel regionList;
  late CompaniesListResponseModel companiesList;
  late ReasonListResponseModel reasonsList;

  String userName = "";
  String userId = "";
  int? geoFence;

  final GlobalKey<FormState> _formKey = GlobalKey();

  bool isLoading1 = true;
  bool isLoading2 = true;
  bool isLoading3 = false;
  bool isLoading4 = true;
  bool isLoading5 = true;
  bool isLoading6 = false;
  bool isLoading7 = false;
  bool isLoading8 = true;

  TextEditingController storeController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  late CommonListItem initialCommonListItem;

   bool isLoading = false;
  bool isError = false;
  String errorText = "";

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

     _valueDropDownController = SingleValueDropDownController();
     _chainValueDropDownController =SingleValueDropDownController();
     _clientValueDropDownController = SingleValueDropDownController();

    getUserData();
    setState(() {
      timeController.text = "--:-- --";
    });
     super.initState();

  }

  getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      userName = sharedPreferences.getString(UserConstants().userName)!;
      userId = sharedPreferences.getString(UserConstants().userId)!;
      geoFence = sharedPreferences.getInt(UserConstants().userGeoFence)!;
    });

    initialTmrUserList = tmrUserList[0];


    getTmrUserList(true);
    getClientList(true);
    getChainList(true);
    getCompaniesList(true);
    getReasonList(true);
    getRegionList(true);

  }


  getRegionList(bool loader) {

    setState(() {
      isLoading8 = loader;
    });

    HTTPManager().regionsList(JourneyPlanRequestModel(elId: userId)).then((value) {
      setState(() {

        regionList = value;

        initialRegionList = regionList.data![0];

        getCitiesList(true);
        isError = false;
      });

    }).catchError((e) {
      setState(() {
        isError = true;
        errorText = e.toString();
        isLoading8 = false;
      });
    });
  }

  getTmrUserList(bool loader) {

    setState(() {
      isLoading1 = loader;
    });

    HTTPManager()
        .tmrUserList(JourneyPlanRequestModel(
      elId: userId))
        .then((value) {
      setState(() {

        tmrUserList = value.data!;

        initialTmrUserList = tmrUserList[0];
        isLoading1 = false;
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
      isLoading2 = loader;
    });

    HTTPManager()
        .clientList(JourneyPlanRequestModel(
      elId: userId,))
        .then((value) {
      setState(() {

        clientList = value;

        initialClientList = clientList.data![0];
        _clientValueDropDownController.dropDownValue = DropDownValueModel(name: initialClientList.companyName!, value: initialClientList);

        isLoading2 = false;
        isError = false;
      });

    }).catchError((e) {
      setState(() {
        isError = true;
        errorText = e.toString();
        isLoading2 = false;
      });
    });
  }

  getStoresList(bool loader) {

    setState(() {
      isLoading = loader;
    });

    HTTPManager()
        .storeList(TmrUserListRequestModel(
      elId: userId,
        cityId: initialCitiesList.id!.toString(),
      chainId: initialChainList.id!.toString()
    ))
        .then((value) {
      setState(() {

        storesList = value;

        initialStoresList = storesList.data![0];
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

  getCitiesList(bool loader) {

    setState(() {
      isLoading = loader;
    });

    HTTPManager().citiesList(CityListRequestModel(elId: userId,regionId: initialRegionList.id.toString())).then((value) {
      setState(() {

        citiesList = value;

        initialCitiesList = citiesList.data![0];
        _valueDropDownController.dropDownValue = DropDownValueModel(name: initialCitiesList.name!, value: initialCitiesList.id);
        isLoading = false;
        isLoading8 = false;
        getStoresList(true);
        isError = false;
      });

    }).catchError((e) {
      setState(() {
        isError = true;
        errorText = e.toString();
        isLoading = false;
        isLoading8 = false;
      });
    });
  }

  getChainList(bool loader) {

    setState(() {
      isLoading7 = loader;
    });

    HTTPManager().chainList(JourneyPlanRequestModel(elId: userId)).then((value) {
      setState(() {

        chainList = value;

        initialChainList = chainList.data![0];
        _chainValueDropDownController.dropDownValue = DropDownValueModel(name: initialChainList.name!, value: initialChainList.id);
        isLoading7 = false;
        getStoresList(true);
        isError = false;
      });

    }).catchError((e) {
      setState(() {
        isError = true;
        errorText = e.toString();
        isLoading7 = false;
      });
    });
  }

  getCompaniesList(bool loader) {

    setState(() {
      isLoading4 = loader;
    });

    HTTPManager()
        .companyList(JourneyPlanRequestModel(
      elId: userId,))
        .then((value) {
      setState(() {

        companiesList = value;
        isLoading4 = false;
        isError = false;
      });

    }).catchError((e) {
      setState(() {
        isError = true;
        errorText = e.toString();
        isLoading4 = false;
      });
    });
  }

  getReasonList(bool loader) {

    setState(() {
      isLoading5 = loader;
    });

    HTTPManager()
        .reasonList()
        .then((value) {
      setState(() {

        reasonsList = value;
        print("REASON LIST");
        print(reasonsList.data!.length);
        initialReasonsList = reasonsList.data![0];
        isLoading5 = false;
        isError = false;
      });

    }).catchError((e) {
      setState(() {
        isError = true;
        errorText = e.toString();
        isLoading5 = false;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _valueDropDownController.dispose();
    _chainValueDropDownController.dispose();
    _clientValueDropDownController.dispose();
    super.dispose();
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
              child: isLoading1 || isLoading2 || isLoading3 || isLoading4 || isLoading5 || isLoading6 || isLoading7 || isLoading8 ? const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryColor,
                ),
              ) : IgnorePointer(
                ignoring: isLoading,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Form(
                      key: _formKey,
                      child: Container(
                        alignment: Alignment.topCenter,
                        decoration: const BoxDecoration(color: AppColors.white),
                        margin: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(height: 50,),
                              const Text("  Select Region",style: TextStyle(color: AppColors.primaryColor),),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                margin:const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                                decoration: BoxDecoration(
                                    border: Border.all(color: AppColors.primaryColor)
                                ),
                                child: DropdownButtonHideUnderline(
                                    child: DropdownButton<StoresListItem>(
                                        value: initialRegionList,
                                        isExpanded: true,
                                        items: regionList.data!.map((StoresListItem items) {
                                          return DropdownMenuItem(
                                            value: items,
                                            child: Text(items.name!,overflow: TextOverflow.ellipsis,),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setState((){
                                            initialRegionList = value!;
                                            _valueDropDownController.clearDropDown();
                                          });
                                          getCitiesList(true);
                                        })),
                              ),
                              const Text("  Select City",style: TextStyle(color: AppColors.primaryColor),),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                margin:const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                                decoration: BoxDecoration(
                                    border: Border.all(color: AppColors.primaryColor)
                                ),
                                child: DropdownButtonHideUnderline(
                                    child: DropDownTextField(
                                      textFieldDecoration:const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Select City",
                                        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 2),
                                      ),
                                      listPadding: ListPadding(top: 20),
                                      enableSearch: true,
                                      clearOption: false,
                                      controller: _valueDropDownController,
                                      dropDownList: citiesList.data!.map<DropDownValueModel>((StoresListItem value) {
                                        return DropDownValueModel(
                                            value: value.id,
                                            name: value.name!
                                        );
                                      }).toList(),
                                      onChanged: (val) {
                                        //print("Value Selected");
                                        setState(() {
                                          initialCitiesList = StoresListItem(id: _valueDropDownController.dropDownValue!.value,name: _valueDropDownController.dropDownValue!.name);
                                           print(jsonEncode(initialCitiesList));
                                          storeController.clear();
                                          getStoresList(true);
                                        });
                                      },
                                    )

                                    // DropdownButton<StoresListItem>(
                                    //     value: initialCitiesList,
                                    //     isExpanded: true,
                                    //     hint: const Text("Select City"),
                                    //     items: citiesList.data!.map((StoresListItem items) {
                                    //       return DropdownMenuItem(
                                    //         value: items,
                                    //         child: Text(items.name!,overflow: TextOverflow.ellipsis,),
                                    //       );
                                    //     }).toList(),
                                    //     onChanged: (value) {
                                    //       setState((){
                                    //         initialCitiesList = value!;
                                    //         storeController.clear();
                                    //         getStoresList(true);
                                    //       });
                                    //     })


                                ),
                              ),
                              const Text("  Select Chain",style: TextStyle(color: AppColors.primaryColor),),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                margin:const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                                decoration: BoxDecoration(
                                    border: Border.all(color: AppColors.primaryColor)
                                ),
                                child: DropdownButtonHideUnderline(
                                    child:
                                    DropDownTextField(
                                      textFieldDecoration:const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Select Chain",
                                        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 2),
                                      ),
                                      listPadding: ListPadding(top: 20),
                                      enableSearch: true,
                                      clearOption: false,
                                      controller: _chainValueDropDownController,
                                      dropDownList: chainList.data!.map<DropDownValueModel>((StoresListItem value) {
                                        return DropDownValueModel(
                                            value: value.id,
                                            name: value.name!
                                        );
                                      }).toList(),
                                      onChanged: (val) {
                                        //print("Value Selected");
                                        setState(() {
                                          initialChainList = StoresListItem(id: _chainValueDropDownController.dropDownValue!.value,name: _chainValueDropDownController.dropDownValue!.name);
                                          print(jsonEncode(initialChainList));
                                          storeController.clear();
                                          getStoresList(true);
                                        });
                                      },
                                    )



                                    // DropdownButton<StoresListItem>(
                                    //     value: initialChainList,
                                    //     isExpanded: true,
                                    //     items: chainList.data!.map((StoresListItem items) {
                                    //       return DropdownMenuItem(
                                    //         value: items,
                                    //         child: Text(items.name!,overflow: TextOverflow.ellipsis,),
                                    //       );
                                    //     }).toList(),
                                    //     onChanged: (value) {
                                    //       setState((){
                                    //         initialChainList = value!;
                                    //         storeController.clear();
                                    //         getStoresList(true);
                                    //       });
                                    //     })
                              ),
                              ),
                              const SizedBox(height: 5,),
                              const Text("  Select Client",style: TextStyle(color: AppColors.primaryColor),),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                margin:const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                                decoration: BoxDecoration(
                                    border: Border.all(color: AppColors.primaryColor)
                                ),
                                child: DropdownButtonHideUnderline(
                                    child: DropDownTextField(
                                      textFieldDecoration:const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Select Client",
                                        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 2),
                                      ),
                                      listPadding: ListPadding(top: 20),
                                      enableSearch: true,
                                      clearOption: false,
                                      controller: _clientValueDropDownController,
                                      dropDownList: clientList.data!.map<DropDownValueModel>((ClientListItem value) {
                                        return DropDownValueModel(
                                            value: value,
                                            name: value.companyName!
                                        );
                                      }).toList(),
                                      onChanged: (val) {
                                        //print("Value Selected");
                                        setState(() {
                                          initialClientList = _clientValueDropDownController.dropDownValue!.value;
                                          print(jsonEncode(initialClientList));

                                        });
                                      },
                                    )


                                    // DropdownButton<ClientListItem>(
                                    //     value: initialClientList,
                                    //     isExpanded: true,
                                    //     items: clientList.data!.map((ClientListItem items) {
                                    //       return DropdownMenuItem(
                                    //         value: items,
                                    //         child: Text(items.companyName!,overflow: TextOverflow.ellipsis,),
                                    //       );
                                    //     }).toList(),
                                    //     onChanged: (value) {
                                    //       setState((){
                                    //         initialClientList = value!;
                                    //       });
                                    //     })

                                ),
                              ),
                              const SizedBox(height: 5,),
                              const Text("  Select Store",style: TextStyle(color: AppColors.primaryColor),),
                              Container(
                                margin:const EdgeInsets.symmetric(horizontal: 5),
                                child: TextFormField(
                                  readOnly: true,
                                  onTap: () {
                                    storeListBottomSheet(context,storesList.data!,(value) {
                                      setState(() {
                                        storeController.text = value.name!;
                                        initialStoresList = value;
                                      });
                                    });
                                  },
                                  controller: storeController,
                                  validator: (value) {
                                    if(value!.isEmpty) {
                                      return "Store field required";
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: const InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppColors.primaryColor,
                                        )),
                                    border: OutlineInputBorder(

                                        borderSide: BorderSide(
                                            color: AppColors.primaryColor, width: 1.0)),
                                    labelStyle: TextStyle(color: AppColors.black),
                                    hintText: 'Store',
                                    hintStyle: TextStyle(color: AppColors.greyColor),
                                    contentPadding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),),
                                  keyboardType: TextInputType.text,
                                  style: const TextStyle(color: AppColors.primaryColor),
                                ),
                              ),
                              // Container(
                              //   width: MediaQuery.of(context).size.width,
                              //   padding: const EdgeInsets.symmetric(horizontal: 5),
                              //   margin:const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                              //   decoration: BoxDecoration(
                              //       border: Border.all(color: AppColors.primaryColor)
                              //   ),
                              //   child: DropdownButtonHideUnderline(
                              //       child: DropdownButton<StoresListItem>(
                              //           value: initialStoresList,
                              //           isExpanded: true,
                              //           items: storesList.data!.map((StoresListItem items) {
                              //             return DropdownMenuItem(
                              //               value: items,
                              //               child: Text(items.name!,overflow: TextOverflow.ellipsis,),
                              //             );
                              //           }).toList(),
                              //           onChanged: (value) {
                              //             setState((){
                              //               initialStoresList = value!;
                              //             });
                              //           })),
                              // ),
                              const SizedBox(height: 5,),
                              const Text("  Select User",style: TextStyle(color: AppColors.primaryColor),),
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
                                        hint:const Text("Select Tmr"),
                                        items: tmrUserList.map((TmrUserItem items) {
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
                                        items: reasonsList.data!.map((ReasonListItem items) {
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
                                  padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 15),
                                  margin:const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: AppColors.primaryColor)
                                  ),
                                  child: Text(DateFormat('MM/dd/yyyy').format(selectedDate)),
                                ),
                              ),
                              const SizedBox(height: 5,),
                              const Text("  Select Time",style: TextStyle(color: AppColors.primaryColor),),

                              Container(
                                margin:const EdgeInsets.symmetric(horizontal: 5),
                                child: TextFormField(
                                  readOnly: true,
                                  onTap: () async {
                                    TimeOfDay? pickedTime =  await showTimePicker(
                                      initialTime: TimeOfDay.now(),
                                      context: context, //context of current state
                                    );

                                    if(pickedTime != null ){

                                      DateTime parsedTime = DateFormat.jm().parse(pickedTime.format(context).toString());

                                      setState(() {
                                        formattedTime = DateFormat('HH:mm:ss').format(parsedTime);
                                        timeController.text = formattedTime;
                                      });

                                    }else{
                                      print("Time is not selected");
                                    }
                                  },
                                  controller: timeController,
                                  validator: (value) {
                                    if(value!.isEmpty || value == "--:-- --") {
                                      return "Time field required";
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: const InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppColors.primaryColor,
                                        )),
                                    border: OutlineInputBorder(

                                        borderSide: BorderSide(
                                            color: AppColors.primaryColor, width: 1.0)),
                                    labelStyle: TextStyle(color: AppColors.black),
                                    hintText: 'Select Time',
                                    hintStyle: TextStyle(color: AppColors.greyColor),
                                    contentPadding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),),
                                  keyboardType: TextInputType.text,
                                  style: const TextStyle(color: AppColors.primaryColor),
                                ),
                              ),


                              // InkWell(
                              //
                              //   child: Container(
                              //     width: MediaQuery.of(context).size.width,
                              //     padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 15),
                              //     margin:const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                              //     decoration: BoxDecoration(
                              //         border: Border.all(color: AppColors.primaryColor)
                              //     ),
                              //     child: Text(formattedTime),
                              //   ),
                              // ),
                              const SizedBox(height:15),
                              InkWell(
                                onTap: () {
                                    addSpecialVisit();
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                                  decoration:  BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient:const LinearGradient(
                                        colors: [
                                          Color(0xFF0F408D),
                                          Color(0xFF6A82A9),
                                        ],
                                      )
                                  ),
                                  child: const Text("Submit",style: TextStyle(color: AppColors.white),),),
                              ),

                              const SizedBox(height: 5,),
                            ],
                          ),
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
    if (_formKey.currentState!.validate()) {
      if(tmrUserList.isEmpty) {
        showToastMessage(false, "Pleas Select Tmr");
        return;
      }
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

        showToastMessage(true, "Special visit added successfully");
        Navigator.of(context).pop();
        setState(() {
          isLoading = false;
        });
      }).catchError((e) {
        print(e.toString());
        showToastMessage(false, e.toString());
        setState(() {
          isLoading = false;
        });
      });
    }
  }
}
