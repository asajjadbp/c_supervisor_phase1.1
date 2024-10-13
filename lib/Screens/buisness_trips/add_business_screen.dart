// ignore_for_file: avoid_print

import 'dart:io';

import 'package:c_supervisor/Model/request_model/business_trips.dart';
import 'package:c_supervisor/Model/response_model/my_team_responses/add_special_visit/store_list_model_response.dart';
import 'package:c_supervisor/Network/http_manager.dart';
import 'package:c_supervisor/Screens/widgets/toast_message_show.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Model/request_model/common_api_call_request.dart';
import '../../Model/request_model/journey_plan_request.dart';
import '../../Model/response_model/business_trips_response/business_trips_list_model.dart';
import '../../Model/response_model/common_list/comon_list_response_model.dart';
import '../recruite_suggest/widgets/recruite_suggest_bottom_sheets.dart';
import '../utills/app_colors_new.dart';
import '../utills/user_constants.dart';
import '../widgets/header_background_new.dart';
import '../widgets/header_widgets_new.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;


class AddBusinessTripScreen extends StatefulWidget {
  const AddBusinessTripScreen({Key? key,required this.businessTrips,required this.isEdit}) : super(key: key);

  final BusinessTrips businessTrips;
  final bool isEdit;

  @override
  State<AddBusinessTripScreen> createState() => _AddBusinessTripScreenState();
}

class _AddBusinessTripScreenState extends State<AddBusinessTripScreen> {

  late StoresListItem initialFromCityItem;
  late StoresListItem initialToCityItem;
  late StoresListItem initialRegionList;

  List<StoresListItem> fromCityCommonListModel = <StoresListItem>[];
  List<StoresListItem> toCityCommonListModel = <StoresListItem>[];
  late StoresListResponseModel regionList;

  final GlobalKey<FormState> _formKey = GlobalKey();

  TextEditingController cvController = TextEditingController();
  TextEditingController commentController = TextEditingController();

  TextEditingController fromCityController = TextEditingController();
  TextEditingController toCityController = TextEditingController();

  String userName = "";
  String userId = "";
  int? geoFence;

  List<File> files = [];

  bool isLoading1 = true;
  bool isLoading2 = true;

  bool isLoading = false;
  bool isError = false;
  String errorText = "";

  late SingleValueDropDownController _valueDropDownController;
  late SingleValueDropDownController _toCityValueDropDownController;

  @override
  void initState() {
    // TODO: implement initState
    _valueDropDownController = SingleValueDropDownController();
    _toCityValueDropDownController =SingleValueDropDownController();
    getUserData();
    if(widget.isEdit) {
      setState(() {
        fromCityController.text = widget.businessTrips.fromCity.toString();
        toCityController.text = widget.businessTrips.toCity.toString();
        cvController.text = widget.businessTrips.voucher.toString();
        commentController.text = widget.businessTrips.reason.toString();
      });
    }
    super.initState();

  }

  getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      userName = sharedPreferences.getString(UserConstants().userName)!;
      userId = sharedPreferences.getString(UserConstants().userId)!;
      geoFence = sharedPreferences.getInt(UserConstants().userGeoFence)!;
    });

    if(widget.isEdit) {
      getFromCityList(
          true, "city", "query", widget.businessTrips.fromCity!.trim());

      getToCityList(true, "city", "query", widget.businessTrips.toCity!.trim());
    } else {
      getFromCityList(
          true, "city", "query", "");

      getToCityList(true, "city", "query", "");
    }
  }

  // getRegionList(bool loader) {
  //
  //   setState(() {
  //     isLoading1 = loader;
  //     isLoading2 = loader;
  //   });
  //
  //   HTTPManager().regionsList(JourneyPlanRequestModel(elId: userId)).then((value) {
  //     setState(() {
  //
  //       regionList = value;
  //
  //       initialRegionList = regionList.data![0];
  //
  //       if(widget.isEdit) {
  //         getFromCityList(
  //             true, "city", "query", widget.businessTrips.fromCity!.trim());
  //
  //         getToCityList(true, "city", "query", widget.businessTrips.toCity!.trim());
  //       } else {
  //         getFromCityList(
  //             true, "city", "query", "");
  //
  //         getToCityList(true, "city", "query", "");
  //       }
  //       isError = false;
  //     });
  //
  //   }).catchError((e) {
  //     setState(() {
  //       isError = true;
  //       errorText = e.toString();
  //       isLoading1 = false;
  //       isLoading2 = false;
  //     });
  //   });
  // }


  getFromCityList(bool loader,String searchBy,String termType,String termTerm) {

    setState(() {
      isLoading2 = loader;
    });

    HTTPManager().citiesList(CityListRequestModel(elId: userId,regionId: "")).then((value) {
      setState(() {
        fromCityCommonListModel = value.data!;
        initialFromCityItem = fromCityCommonListModel[0];
        if(widget.isEdit) {
          for(int i = 0; i < fromCityCommonListModel.length; i++ ) {
            if(widget.businessTrips.fromCity!.trim() == fromCityCommonListModel[i].name!.trim()) {
              initialFromCityItem = fromCityCommonListModel[i];
            }
          }
        }
        _valueDropDownController.dropDownValue = DropDownValueModel(name: initialFromCityItem.name!, value: initialFromCityItem);
        print(initialFromCityItem.id);
        isLoading2 = false;
        isError = false;
      });

    }).catchError((e) {
      // showToastMessage(false, e.toString());
      setState(() {
        isError = true;
        errorText = e.toString();
        isLoading2 = false;
      });
    });
  }

  getToCityList(bool loader,String searchBy,String termType,String termTerm) {

    setState(() {
      isLoading1 = loader;
    });

    HTTPManager().citiesList(CityListRequestModel(elId: userId,regionId: "")).then((value) {
      setState(() {
        toCityCommonListModel = value.data!;
        initialToCityItem = toCityCommonListModel[0];
        if(widget.isEdit) {
          for(int i = 0; i < toCityCommonListModel.length; i++ ) {
            if(widget.businessTrips.toCity!.trim() == toCityCommonListModel[i].name!.trim()) {
              initialToCityItem = toCityCommonListModel[i];
            }
          }
        }
        _toCityValueDropDownController.dropDownValue = DropDownValueModel(name: initialToCityItem.name!, value: initialToCityItem);
        print(initialToCityItem.id);
        isLoading1 = false;
        isError = false;
      });

    }).catchError((e) {
      print(e.toString());
      // showToastMessage(false, e.toString());
      setState(() {
        isError = true;
        errorText = e.toString();
        isLoading1 = false;
      });
    });
  }

@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _valueDropDownController.dispose();
    _toCityValueDropDownController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HeaderBackgroundNew(
        childWidgets: [
           HeaderWidgetsNew(
            pageTitle: widget.isEdit ? "Update Business Trip" : "Business Trip",
            isBackButton: true,
            isDrawerButton: true,
          ),
          Expanded(
              child: isLoading2 || isLoading1 ? const Center(
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
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // const Text("  Select Region",style: TextStyle(color: AppColors.primaryColor),),
                              // Container(
                              //   width: MediaQuery.of(context).size.width,
                              //   padding: const EdgeInsets.symmetric(horizontal: 5),
                              //   margin:const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                              //   decoration: BoxDecoration(
                              //       border: Border.all(color: AppColors.primaryColor)
                              //   ),
                              //   child: DropdownButtonHideUnderline(
                              //       child: DropdownButton<StoresListItem>(
                              //           value: initialRegionList,
                              //           isExpanded: true,
                              //           items: regionList.data!.map((StoresListItem items) {
                              //             return DropdownMenuItem(
                              //               value: items,
                              //               child: Text(items.name!,overflow: TextOverflow.ellipsis,),
                              //             );
                              //           }).toList(),
                              //           onChanged: (value) {
                              //             setState((){
                              //               initialRegionList = value!;
                              //             });
                              //             getFromCityList(
                              //                 true, "city", "query", "");
                              //
                              //             getToCityList(true, "city", "query", "");
                              //           })),
                              // ),
                              const Text("  From City",style: TextStyle(color: AppColors.primaryColor),),
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
                                      dropDownList: fromCityCommonListModel.map<DropDownValueModel>((StoresListItem value) {
                                        return DropDownValueModel(
                                            value: value.id,
                                            name: value.name!
                                        );
                                      }).toList(),
                                      onChanged: (val) {
                                        //print("Value Selected");
                                        setState(() {
                                          initialFromCityItem = StoresListItem(id: _valueDropDownController.dropDownValue!.value,name: _valueDropDownController.dropDownValue!.name);
                                        });
                                      },
                                    )



                                    // DropdownButton<StoresListItem>(
                                    //     value: initialFromCityItem,
                                    //     isExpanded: true,
                                    //     hint: const Text("Select City"),
                                    //     items: fromCityCommonListModel.map((StoresListItem items) {
                                    //       return DropdownMenuItem(
                                    //         value: items,
                                    //         child: Text(items.name!,overflow: TextOverflow.ellipsis,),
                                    //       );
                                    //     }).toList(),
                                    //     onChanged: (value) {
                                    //       setState((){
                                    //         initialFromCityItem = value!;
                                    //       });
                                    //     })
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
                              //       child: DropdownButton<CommonListItem>(
                              //           value: initialFromCityItem,
                              //           isExpanded: true,
                              //           items: fromCityCommonListModel.map((CommonListItem items) {
                              //             return DropdownMenuItem(
                              //               value: items,
                              //               child: Text(items.text!,overflow: TextOverflow.ellipsis,),
                              //             );
                              //           }).toList(),
                              //           onChanged: (value) {
                              //             setState((){
                              //               initialFromCityItem = value!;
                              //             });
                              //           })),
                              // ),
                              const SizedBox(height: 5,),
                              const Text("  To City",style: TextStyle(color: AppColors.primaryColor),),
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
                                      controller: _toCityValueDropDownController,
                                      dropDownList: toCityCommonListModel.map<DropDownValueModel>((StoresListItem value) {
                                        return DropDownValueModel(
                                            value: value.id,
                                            name: value.name!
                                        );
                                      }).toList(),
                                      onChanged: (val) {
                                        //print("Value Selected");
                                        setState(() {
                                          initialToCityItem = StoresListItem(id: _toCityValueDropDownController.dropDownValue!.value,name: _toCityValueDropDownController.dropDownValue!.name);
                                        });
                                      },
                                    )




                                    // DropdownButton<StoresListItem>(
                                    //     value: initialToCityItem,
                                    //     isExpanded: true,
                                    //     hint: const Text("Select City"),
                                    //     items: toCityCommonListModel.map((StoresListItem items) {
                                    //       return DropdownMenuItem(
                                    //         value: items,
                                    //         child: Text(items.name!,overflow: TextOverflow.ellipsis,),
                                    //       );
                                    //     }).toList(),
                                    //     onChanged: (value) {
                                    //       setState((){
                                    //         initialToCityItem = value!;
                                    //       });
                                    //     })

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
                              //       child: DropdownButton<CommonListItem>(
                              //           value: initialToCityItem,
                              //           isExpanded: true,
                              //           items: toCityCommonListModel.map((CommonListItem items) {
                              //             return DropdownMenuItem(
                              //               value: items,
                              //               child: Text(items.text!,overflow: TextOverflow.ellipsis,),
                              //             );
                              //           }).toList(),
                              //           onChanged: (value) {
                              //             setState((){
                              //               initialToCityItem = value!;
                              //             });
                              //           })),
                              // ),
                              const SizedBox(height: 5,),
                              const Text("  Add Trip Files ",style: TextStyle(color: AppColors.primaryColor),),
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 5),
                                child: TextFormField(
                                  onTap: () async {
                                    FilePickerResult? result = await FilePicker.platform.pickFiles(
                                      type: FileType.custom,
                                      allowMultiple: true,
                                      allowedExtensions: ['jpeg','png','jpg','pdf','doc'],
                                    );

                                    if (result != null) {
                                      // PlatformFile file = result.files.first;
                                      files = result.paths.map((path) => File(path!)).toList();

                                      // String basename = p.basename(files[0].path);

                                      List<String> fileNames = result.paths.map((path) =>  p.basename(File(path!).path)).toList();


                                      setState(() {
                                        cvController.text = fileNames.toString().replaceAll("[", "").replaceAll("]", "");
                                      });
                                    } else {
                                      // User canceled the picker
                                    }
                                  },
                                  readOnly: true,
                                  controller: cvController,
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
                                    hintText: 'Trip files ',
                                    hintStyle: TextStyle(color: AppColors.greyColor),
                                    contentPadding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),),
                                  keyboardType: TextInputType.text,
                                  style: const TextStyle(color: AppColors.primaryColor),
                                ),
                              ),
                              const SizedBox(height: 5,),
                              const Text("  Add Reason",style: TextStyle(color: AppColors.primaryColor),),
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 5),
                                child: TextFormField(
                                  controller: commentController,
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
                                    hintText: 'Reason',
                                    hintStyle: TextStyle(color: AppColors.greyColor),
                                    contentPadding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),),
                                  keyboardType: TextInputType.text,
                                  style: const TextStyle(color: AppColors.primaryColor),
                                ),
                              ),
                              const SizedBox(height: 15,),
                              InkWell(
                                onTap: () {
                                  if(widget.isEdit) {
                                    updateBusinessTrip();
                                  } else {
                                    addBusinessTrip();
                                  }
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
                      const Center(child: CircularProgressIndicator(color: AppColors.primaryColor,)),
                  ],
                ),
              ))
        ],
      ),
    );
  }
  addBusinessTrip() {
    if(_formKey.currentState!.validate()) {
      if(fromCityCommonListModel.isEmpty || toCityCommonListModel.isEmpty) {
        showToastMessageBottom(false, "City Field can't be empty");
        return;
      }
      if(files.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        HTTPManager()
            .addBusinessTrips(
                AddBusinessTripsRequestModel(
                    elId: userId,
                    fromCity: initialFromCityItem.id.toString(),
                    toCity: initialToCityItem.id.toString(),
                    reason: commentController.text),
                files)
            .then((value) {
          print(value);

          showToastMessageBottom(true, "Business trip added successfully");
          Navigator.of(context).pop();
          setState(() {
            isLoading = false;
          });
        }).catchError((e) {
          print(e.toString());
          showToastMessageBottom(false, e.toString());
          setState(() {
            isLoading = false;
          });
        });
      } else {
        showToastMessageBottom(false, "Please select any file");
      }
    }
  }

  updateBusinessTrip() {
    print(initialToCityItem.id);
    print(initialFromCityItem.id);

    setState(() {
      isLoading = true;
    });
    if(fromCityCommonListModel.isEmpty || toCityCommonListModel.isEmpty) {
      showToastMessageBottom(false, "City Field can't be empty");
      return;
    }
    if(files.isEmpty) {
      HTTPManager().updateBusinessTripsWithOutFiles(
          UpdateBusinessTripsRequestModel(
              elId: userId,
              id: widget.businessTrips.id.toString(),
              fromCity: initialFromCityItem.id.toString(),
              toCity: initialToCityItem.id.toString(),
              reason: commentController.text
          )).then((value) {
        print(value);

        showToastMessageBottom(true, "Business trip updated successfully");
        Navigator.of(context).pop();
        setState(() {
          isLoading = false;
        });
      }).catchError((e) {
        print(e.toString());
        showToastMessageBottom(false, e.toString());
        setState(() {
          isLoading = false;
        });
      });
    } else {
      HTTPManager().updateBusinessTripsWithFiles(
          UpdateBusinessTripsRequestModel(
              elId: userId,
              id: widget.businessTrips.id.toString(),
              fromCity: initialFromCityItem.id.toString(),
              toCity: initialToCityItem.id.toString(),
              reason: commentController.text
          ), files).then((value) {
        print(value);

        showToastMessageBottom(true, "Business trip updated successfully");
        Navigator.of(context).pop();
        setState(() {
          isLoading = false;
        });
      }).catchError((e) {
        print(e.toString());
        showToastMessageBottom(false, e.toString());
        setState(() {
          isLoading = false;
        });
      });
    }
  }
}
