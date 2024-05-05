// ignore_for_file: avoid_print

import 'dart:io';

import 'package:c_supervisor/Model/request_model/recruit_suggest.dart';
import 'package:c_supervisor/Model/response_model/recruit_suggest_responses/recruit_suggest_list_model.dart';
import 'package:c_supervisor/Network/http_manager.dart';
import 'package:c_supervisor/Screens/recruite_suggest/widgets/recruite_suggest_bottom_sheets.dart';
import 'package:c_supervisor/Screens/widgets/toast_message_show.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Model/request_model/common_api_call_request.dart';
import '../../Model/response_model/common_list/comon_list_response_model.dart';
import '../../Model/response_model/my_team_responses/add_special_visit/store_list_model_response.dart';
import '../utills/app_colors_new.dart';
import '../utills/user_constants.dart';
import '../widgets/header_background_new.dart';
import '../widgets/header_widgets_new.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;

class AddRecruitSuggestScreen extends StatefulWidget {
  const AddRecruitSuggestScreen({Key? key,required this.recruitSuggest,required this.isEdit}) : super(key: key);

  final RecruitSuggest recruitSuggest;
  final bool isEdit;

  @override
  State<AddRecruitSuggestScreen> createState() => _AddRecruitSuggestScreenState();
}

class _AddRecruitSuggestScreenState extends State<AddRecruitSuggestScreen> {

  late StoresListItem initialCityItem;

  List<StoresListItem> cityCommonListModel = <StoresListItem>[];

  final GlobalKey<FormState> _formKey = GlobalKey();

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController iqamaController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController yearExpController = TextEditingController();
  TextEditingController cvController = TextEditingController();
  TextEditingController commentController = TextEditingController();

  String userName = "";
  String userId = "";
  int? geoFence;

  File? file;

  bool isLoading2 = true;

  bool isLoading = false;
  bool isError = false;
  String errorText = "";

  @override
  void initState() {
    // TODO: implement initState
    getUserData();
    if(widget.isEdit) {
      setState(() {
        nameController.text = widget.recruitSuggest.name!;
        phoneController.text = widget.recruitSuggest.phone!.toString();
        iqamaController.text = widget.recruitSuggest.iqama!;
        yearExpController.text = widget.recruitSuggest.yearsOfExp!.toString();
        cvController.text = widget.recruitSuggest.cv!;
        commentController.text = widget.recruitSuggest.comment!;
        cityController.text = widget.recruitSuggest.cityName!;
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
      getCityList(true, "city", "query", widget.recruitSuggest.cityName!);
    } else {
      getCityList(true, "city", "query", "");
    }
  }

  getCityList(bool loader,String searchBy,String termType,String termTerm) {

    setState(() {
      isLoading2 = loader;
    });

    HTTPManager().citiesList()
        .then((value) {
      setState(() {
        cityCommonListModel = value.data!;
        initialCityItem = cityCommonListModel[0];
        if(widget.isEdit) {
          for(int i=0;i<cityCommonListModel.length; i++) {
            if(widget.recruitSuggest.cityName!.trim() == cityCommonListModel[i].name!.trim()) {
              initialCityItem = cityCommonListModel[i];
            }
          }
        }
        print(initialCityItem.id);
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HeaderBackgroundNew(
        childWidgets: [
           HeaderWidgetsNew(
            pageTitle: widget.isEdit ? "Update Recruit Suggest" : "Recruit Suggest",
            isBackButton: true,
            isDrawerButton: true,
          ),
          Expanded(
              child: isLoading2 ? const Center(
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
                              const SizedBox(height: 50,),
                              const Text("  Add Name",style: TextStyle(color: AppColors.primaryColor),),
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 5),
                                child: TextFormField(
                                  controller: nameController,
                                  validator: (value) {
                                    if(value!.isEmpty) {
                                      return "name field required";
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
                                    hintText: 'Name',
                                    hintStyle: TextStyle(color: AppColors.greyColor),
                                    contentPadding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),),
                                  keyboardType: TextInputType.text,
                                  style: const TextStyle(color: AppColors.primaryColor),
                                ),
                              ),
                              const SizedBox(height: 5,),
                              const Text("  Select City",style: TextStyle(color: AppColors.primaryColor),),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                margin:const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                                decoration: BoxDecoration(
                                    border: Border.all(color: AppColors.primaryColor)
                                ),
                                child: DropdownButtonHideUnderline(
                                    child: DropdownButton<StoresListItem>(
                                        value: initialCityItem,
                                        isExpanded: true,
                                        items: cityCommonListModel.map((StoresListItem items) {
                                          return DropdownMenuItem(
                                            value: items,
                                            child: Text(items.name!,overflow: TextOverflow.ellipsis,),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setState((){
                                            initialCityItem = value!;
                                          });
                                        })),
                              ),
                              const SizedBox(height: 5,),
                              const Text("  Add Iqama No",style: TextStyle(color: AppColors.primaryColor),),
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 5),
                                child: TextFormField(
                                  controller: iqamaController,
                                  validator: (value) {
                                    if(value!.isEmpty) {
                                      return "Iqama field required";
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
                                    hintText: 'Iqama',
                                    hintStyle: TextStyle(color: AppColors.greyColor),
                                    contentPadding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),),
                                  keyboardType: TextInputType.text,
                                  style: const TextStyle(color: AppColors.primaryColor),
                                ),
                              ),
                              const SizedBox(height: 5,),
                              const Text("  Add Phone number",style: TextStyle(color: AppColors.primaryColor),),
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 5),
                                child: TextFormField(
                                  controller: phoneController,
                                  validator: (value) {
                                    if(value!.isEmpty) {
                                      return "Phone number field required";
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
                                    hintText: 'phone number',
                                    hintStyle: TextStyle(color: AppColors.greyColor),
                                    contentPadding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),),
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(color: AppColors.primaryColor),
                                ),
                              ),
                              const SizedBox(height: 5,),
                              const Text("  Add Year Of Experience",style: TextStyle(color: AppColors.primaryColor),),
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 5),
                                child: TextFormField(
                                  controller: yearExpController,
                                  validator: (value) {
                                    if(value!.isEmpty) {
                                      return "Experience field required";
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
                                    hintText: 'No of years',
                                    hintStyle: TextStyle(color: AppColors.greyColor),
                                    contentPadding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),),
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(color: AppColors.primaryColor),
                                ),
                              ),
                              const SizedBox(height: 5,),
                              const Text("  Add CV here",style: TextStyle(color: AppColors.primaryColor),),
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 5),
                                child: TextFormField(
                                  readOnly: true,
                                  onTap: () async {
                                    FilePickerResult? result = await FilePicker.platform.pickFiles(
                                      type: FileType.custom,
                                      allowMultiple: false,
                                      allowedExtensions: ['jpeg','png','jpg','pdf','doc'],
                                    );

                                    if (result != null) {
                                      file = File(result.files.first.path!);

                                      String basename = p.basename(file!.path);

                                      print(basename);

                                      setState(() {
                                        cvController.text = basename;
                                      });
                                    } else {
                                      // User canceled the picker
                                    }
                                  },
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
                                    hintText: 'CV',
                                    hintStyle: TextStyle(color: AppColors.greyColor),
                                    contentPadding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),),
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(color: AppColors.primaryColor),
                                ),
                              ),
                              const SizedBox(height: 5,),
                              const Text("  Add Comment",style: TextStyle(color: AppColors.primaryColor),),
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
                                    hintText: 'Comment',
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
                                    updateRecruitSuggest();
                                  } else {
                                    addRecruitSuggest();
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
                      const CircularProgressIndicator(color: AppColors.primaryColor,),
                  ],
                ),
              ))
        ],
      ),
    );
  }
  addRecruitSuggest() {
   if(_formKey.currentState!.validate()) {
     if (cvController.text.isEmpty) {
       showToastMessage(false, "Please add cv file");
     } else {
       setState(() {
         isLoading = true;
       });
       HTTPManager().addRecruitSuggest(AddRecruitSuggestRequestModel(
           elId: userId,
           cityId: initialCityItem.id.toString(),
           name: nameController.text,
           iqama: iqamaController.text,
           yearOfExperience: yearExpController.text,
           phone: phoneController.text,
           comment: commentController.text
       ), file!).then((value) {
         print(value);

         showToastMessage(true, "Recruit added successfully");
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

  updateRecruitSuggest() {
    if(_formKey.currentState!.validate()){
      if (cvController.text.isEmpty) {
        showToastMessage(false, "Please add cv file");
      } else {
        setState(() {
          isLoading = true;
        });
        if(file != null) {
          HTTPManager()
              .updateRecruitSuggestWithFile(
              UpdateRecruitSuggestRequestModel(
                  elId: userId,
                  id: widget.recruitSuggest.id.toString(),
                  cityId: initialCityItem.id.toString(),
                  name: nameController.text,
                  iqama: iqamaController.text,
                  yearOfExperience: yearExpController.text,
                  phone: phoneController.text,
                  comment: commentController.text),
              file!)
              .then((value) {
            print(value);

            showToastMessage(true, "Recruit updated successfully");
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
        } else {
          HTTPManager()
              .updateRecruitSuggestWithoutFile(
              UpdateRecruitSuggestRequestModel(
                  elId: userId,
                  id: widget.recruitSuggest.id.toString(),
                  cityId: initialCityItem.id.toString(),
                  name: nameController.text,
                  iqama: iqamaController.text,
                  yearOfExperience: yearExpController.text,
                  phone: phoneController.text,
                  comment: commentController.text),)
              .then((value) {
            print(value);

            showToastMessage(true, "Recruit updated successfully");
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
  }
}
