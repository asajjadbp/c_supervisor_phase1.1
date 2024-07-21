// import 'dart:convert';
// import 'dart:developer';
//
// import 'package:c_supervisor/Model/request_model/common_api_call_request.dart';
// import 'package:c_supervisor/Model/request_model/time_motion.dart';
// import 'package:c_supervisor/Model/response_model/common_list/comon_list_response_model.dart';
// import 'package:c_supervisor/Network/http_manager.dart';
// import 'package:c_supervisor/Screens/widgets/toast_message_show.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../Model/request_model/journey_plan_request.dart';
// import '../../Model/response_model/my_team_responses/add_special_visit/companies_list_model_response.dart';
// import '../../Model/response_model/time_motion_response/time_motion_list_response_model.dart';
// import '../recruite_suggest/widgets/recruite_suggest_bottom_sheets.dart';
// import '../utills/app_colors_new.dart';
// import '../utills/user_constants.dart';
// import '../widgets/header_background_new.dart';
// import '../widgets/header_widgets_new.dart';
//
// class AddTimeMotionScreen extends StatefulWidget {
//   const AddTimeMotionScreen({Key? key,required this.timeMotion,required this.isEdit}) : super(key: key);
//
//   final TimeMotion timeMotion;
//   final bool isEdit;
//
//   @override
//   State<AddTimeMotionScreen> createState() => _AddTimeMotionScreenState();
// }
//
// class _AddTimeMotionScreenState extends State<AddTimeMotionScreen> {
//
//   late CompaniesListItem initialCompanyItem;
//   late CommonListItem initialChannelItem;
//   late CommonListItem initialCityItem;
//
//   List<CommonListItem> cityCommonListModel = <CommonListItem>[];
//   List<CommonListItem> channelCommonListModel = <CommonListItem>[];
//   List<CompaniesListItem> companyCommonListModel = <CompaniesListItem>[];
//
//   TextEditingController noOfMinController = TextEditingController();
//   TextEditingController cityController = TextEditingController();
//   TextEditingController channelController = TextEditingController();
//
//   String userName = "";
//   String userId = "";
//   int? geoFence;
//
//   bool isLoading4 = true;
//   bool isLoading1 = false;
//   bool isLoading2 = false;
//
//   bool isLoading = false;
//   bool isError = false;
//   String errorText = "";
//
//   final GlobalKey<FormState> _formKey = GlobalKey();
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     getUserData();
//     if(widget.isEdit) {
//       setState(() {
//         log(jsonEncode(widget.timeMotion));
//         noOfMinController.text = widget.timeMotion.noMinutes.toString();
//         cityController.text = widget.timeMotion.cityName.toString();
//         channelController.text = widget.timeMotion.channelName.toString();
//       });
//     }
//     super.initState();
//
//   }
//
//   getUserData() async {
//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//
//     setState(() {
//       userName = sharedPreferences.getString(UserConstants().userName)!;
//       userId = sharedPreferences.getString(UserConstants().userId)!;
//       geoFence = sharedPreferences.getInt(UserConstants().userGeoFence)!;
//     });
//
//     getCompaniesList(true);
//     if(widget.isEdit) {
//       setState(() {
//          isLoading1 = true;
//          isLoading2 = true;
//       });
//       getChannelList(true,"channel","query",widget.timeMotion.channelName!);
//       getCityList(true,"city","query",widget.timeMotion.cityName!);
//     }
//   }
//
//   getCompaniesList(bool loader) {
//
//     setState(() {
//       isLoading4 = loader;
//     });
//
//     HTTPManager().companyList(JourneyPlanRequestModel(
//       elId: userId
//     ))
//         .then((value) {
//       setState(() {
//         companyCommonListModel = value.data!;
//         if(widget.isEdit) {
//           for(int i =0; i<companyCommonListModel.length; i++) {
//             if(widget.timeMotion.companyName!.trim() == companyCommonListModel[i].companyName!.trim() ) {
//               initialCompanyItem = companyCommonListModel[i];
//             }
//           }
//         } else {
//           initialCompanyItem = companyCommonListModel[0];
//         }
//         isLoading4 = false;
//         isError = false;
//       });
//
//     }).catchError((e) {
//       setState(() {
//         isError = true;
//         errorText = e.toString();
//         isLoading4 = false;
//       });
//     });
//   }
//
//   getChannelList(bool loader,String searchBy,String termType,String termTerm) {
//
//     setState(() {
//       isLoading1 = loader;
//     });
//
//     HTTPManager().commonApiCallForList(CommonApiCallRequestModel(
//       searchBy: searchBy,
//       termTerm: termTerm,
//       termType: termType,
//     ))
//         .then((value) {
//       setState(() {
//         channelCommonListModel = value.results!;
//         if(widget.isEdit) {
//           for(int i =0; i<channelCommonListModel.length; i++) {
//             if(widget.timeMotion.channelName!.trim() == channelCommonListModel[i].text!.trim() ) {
//               initialChannelItem = channelCommonListModel[i];
//             }
//           }
//         }
//         print(initialChannelItem.id);
//         isLoading1 = false;
//         isError = false;
//       });
//
//     }).catchError((e) {
//       setState(() {
//         isError = true;
//         errorText = e.toString();
//         isLoading1 = false;
//       });
//     });
//   }
//
//   getCityList(bool loader,String searchBy,String termType,String termTerm) {
//
//     setState(() {
//       isLoading2 = loader;
//     });
//
//     HTTPManager().commonApiCallForList(CommonApiCallRequestModel(
//       searchBy: searchBy,
//       termTerm: termTerm,
//       termType: termType,
//     ))
//         .then((value) {
//       setState(() {
//         cityCommonListModel = value.results!;
//
//         if(widget.isEdit) {
//           for(int i =0; i<cityCommonListModel.length; i++) {
//             if(widget.timeMotion.cityName!.trim() == cityCommonListModel[i].text!.trim() ) {
//               initialCityItem = cityCommonListModel[i];
//             }
//           }
//         }
//         print(initialCityItem.id);
//         isLoading2 = false;
//         isError = false;
//       });
//
//     }).catchError((e) {
//       setState(() {
//         isError = true;
//         errorText = e.toString();
//         isLoading2 = false;
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: HeaderBackgroundNew(
//         childWidgets: [
//            HeaderWidgetsNew(
//             pageTitle: widget.isEdit ? "Update Time motion study" : "Time Motion Study",
//             isBackButton: true,
//             isDrawerButton: true,
//           ),
//           Expanded(
//               child: isLoading4 || isLoading1 || isLoading2 ? const Center(
//                 child: CircularProgressIndicator(
//                   color: AppColors.primaryColor,
//                 ),
//               ) : IgnorePointer(
//                 ignoring: isLoading,
//                 child: Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     Form(
//                       key: _formKey,
//                       child: Container(
//                         margin: const EdgeInsets.symmetric(horizontal: 5),
//                         child: SingleChildScrollView(
//                           scrollDirection: Axis.vertical,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.stretch,
//                             children: [
//                               const SizedBox(height: 50,),
//                               const Text("  Select Company",style: TextStyle(color: AppColors.primaryColor),),
//                               Container(
//                                 width: MediaQuery.of(context).size.width,
//                                 padding: const EdgeInsets.symmetric(horizontal: 5),
//                                 margin:const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
//                                 decoration: BoxDecoration(
//                                     border: Border.all(color: AppColors.primaryColor)
//                                 ),
//                                 child: DropdownButtonHideUnderline(
//                                     child: DropdownButton<CompaniesListItem>(
//                                         value: initialCompanyItem,
//                                         isExpanded: true,
//                                         items: companyCommonListModel.map((CompaniesListItem items) {
//                                           return DropdownMenuItem(
//                                             value: items,
//                                             child: Text(items.companyName!,overflow: TextOverflow.ellipsis,),
//                                           );
//                                         }).toList(),
//                                         onChanged: (value) {
//                                           setState((){
//                                             initialCompanyItem = value!;
//                                           });
//                                         })),
//                               ),
//                               const SizedBox(height: 5,),
//                               const Text("  Select City",style: TextStyle(color: AppColors.primaryColor),),
//                               Container(
//                                 margin:const EdgeInsets.symmetric(horizontal: 5),
//                                 child: TextFormField(
//                                   readOnly: true,
//                                   onTap: () {
//                                     commonSuggestBottomSheet(context, "city","query","", (value) {
//                                       setState(() {
//                                         cityController.text = value.text!;
//                                         initialCityItem = value;
//                                       });
//                                     });
//                                   },
//                                   controller: cityController,
//                                   validator: (value) {
//                                     if(value!.isEmpty) {
//                                       return "City field required";
//                                     } else {
//                                       return null;
//                                     }
//                                   },
//                                   decoration: const InputDecoration(
//                                     enabledBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(
//                                         color: AppColors.primaryColor,
//                                       ),
//                                     ),
//                                     focusedBorder: OutlineInputBorder(
//                                         borderSide: BorderSide(
//                                           color: AppColors.primaryColor,
//                                         )),
//                                     border: OutlineInputBorder(
//
//                                         borderSide: BorderSide(
//                                             color: AppColors.primaryColor, width: 1.0)),
//                                     labelStyle: TextStyle(color: AppColors.black),
//                                     hintText: 'City',
//                                     hintStyle: TextStyle(color: AppColors.greyColor),
//                                     contentPadding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),),
//                                   keyboardType: TextInputType.text,
//                                   style: const TextStyle(color: AppColors.primaryColor),
//                                 ),
//                               ),
//                               // Container(
//                               //   width: MediaQuery.of(context).size.width,
//                               //   padding: const EdgeInsets.symmetric(horizontal: 5),
//                               //   margin:const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
//                               //   decoration: BoxDecoration(
//                               //       border: Border.all(color: AppColors.primaryColor)
//                               //   ),
//                               //   child: DropdownButtonHideUnderline(
//                               //       child: DropdownButton<CommonListItem>(
//                               //           value: initialCityItem,
//                               //           isExpanded: true,
//                               //           items: cityCommonListModel.map((CommonListItem items) {
//                               //             return DropdownMenuItem(
//                               //               value: items,
//                               //               child: Text(items.text!,overflow: TextOverflow.ellipsis,),
//                               //             );
//                               //           }).toList(),
//                               //           onChanged: (value) {
//                               //             setState((){
//                               //               initialCityItem = value!;
//                               //             });
//                               //           })),
//                               // ),
//                               const SizedBox(height: 5,),
//                               const Text("  Select Channel",style: TextStyle(color: AppColors.primaryColor),),
//                               Container(
//                                 margin:const EdgeInsets.symmetric(horizontal: 5),
//                                 child: TextFormField(
//                                   readOnly: true,
//                                   onTap: () {
//                                     commonSuggestBottomSheet(context, "channel","query","", (value) {
//                                       setState(() {
//                                         channelController.text = value.text!;
//                                         initialChannelItem = value;
//                                       });
//                                     });
//                                   },
//                                   controller: channelController,
//                                   validator: (value) {
//                                     if(value!.isEmpty) {
//                                       return "Channel field required";
//                                     } else {
//                                       return null;
//                                     }
//                                   },
//                                   decoration: const InputDecoration(
//                                     enabledBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(
//                                         color: AppColors.primaryColor,
//                                       ),
//                                     ),
//                                     focusedBorder: OutlineInputBorder(
//                                         borderSide: BorderSide(
//                                           color: AppColors.primaryColor,
//                                         )),
//                                     border: OutlineInputBorder(
//
//                                         borderSide: BorderSide(
//                                             color: AppColors.primaryColor, width: 1.0)),
//                                     labelStyle: TextStyle(color: AppColors.black),
//                                     hintText: 'Channel',
//                                     hintStyle: TextStyle(color: AppColors.greyColor),
//                                     contentPadding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),),
//                                   keyboardType: TextInputType.text,
//                                   style: const TextStyle(color: AppColors.primaryColor),
//                                 ),
//                               ),
//                               // Container(
//                               //   width: MediaQuery.of(context).size.width,
//                               //   padding: const EdgeInsets.symmetric(horizontal: 5),
//                               //   margin:const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
//                               //   decoration: BoxDecoration(
//                               //       border: Border.all(color: AppColors.primaryColor)
//                               //   ),
//                               //   child: DropdownButtonHideUnderline(
//                               //       child: DropdownButton<CommonListItem>(
//                               //           value: initialChannelItem,
//                               //           isExpanded: true,
//                               //           items: channelCommonListModel.map((CommonListItem items) {
//                               //             return DropdownMenuItem(
//                               //               value: items,
//                               //               child: Text(items.text!,overflow: TextOverflow.ellipsis,),
//                               //             );
//                               //           }).toList(),
//                               //           onChanged: (value) {
//                               //             setState((){
//                               //               initialChannelItem = value!;
//                               //             });
//                               //           })),
//                               // ),
//                               const SizedBox(height: 5,),
//                               const Text("  Add Minutes In Number",style: TextStyle(color: AppColors.primaryColor),),
//                               Container(
//                                 margin:const EdgeInsets.symmetric(horizontal: 5),
//                                 child: TextFormField(
//                                   controller: noOfMinController,
//                                   validator: (value) {
//                                     if(value!.isEmpty) {
//                                       return "Minutes field required";
//                                     } else {
//                                       return null;
//                                     }
//                                   },
//                                   decoration: const InputDecoration(
//                                     enabledBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(
//                                         color: AppColors.primaryColor,
//                                       ),
//                                     ),
//                                     focusedBorder: OutlineInputBorder(
//                                         borderSide: BorderSide(
//                                           color: AppColors.primaryColor,
//                                         )),
//                                     border: OutlineInputBorder(
//                                         borderSide: BorderSide(
//                                             color: AppColors.primaryColor, width: 1.0)),
//                                     labelStyle: TextStyle(color: AppColors.black),
//                                     hintText: 'No of minutes',
//                                     hintStyle: TextStyle(color: AppColors.greyColor),
//                                     contentPadding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),),
//                                   keyboardType: TextInputType.number,
//                                   style: const TextStyle(color: AppColors.primaryColor),
//                                 ),
//                               ),
//                               const SizedBox(height: 15,),
//                               InkWell(
//                                 onTap: () {
//                                   if(widget.isEdit) {
//                                     updateTimeMotionStudy();
//                                   } else {
//                                     addTimeMotionStudy();
//                                   }
//                                 },
//                                 child: Container(
//                                   alignment: Alignment.center,
//                                   padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
//                                   decoration:  BoxDecoration(
//                                       borderRadius: BorderRadius.circular(10),
//                                       gradient:const LinearGradient(
//                                         colors: [
//                                           Color(0xFF0F408D),
//                                           Color(0xFF6A82A9),
//                                         ],
//                                       )
//                                   ),
//                                   child: const Text("Submit",style: TextStyle(color: AppColors.white),),),
//                               ),
//
//                               const SizedBox(height: 5,),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     if(isLoading)
//                       const CircularProgressIndicator(color: AppColors.primaryColor,),
//                   ],
//                 ),
//               ))
//         ],
//       ),
//     );
//   }
//   addTimeMotionStudy() {
//     if(_formKey.currentState!.validate()) {
//
//       setState(() {
//         isLoading = true;
//       });
//       HTTPManager().addTimeMotion(AddTimeMotionRequestModel(
//         elId: userId,
//         companyId: initialCompanyItem.companyId.toString(),
//         cityId: initialCityItem.id,
//         channelId: initialChannelItem.id,
//         noMinutes: noOfMinController.text,
//       )).then((value) {
//         print(value);
//
//         showToastMessage(true, "Time motion study added successfully");
//         Navigator.of(context).pop();
//         setState(() {
//           isLoading = false;
//         });
//       }).catchError((e) {
//         print(e.toString());
//         showToastMessage(false, e.toString());
//         setState(() {
//           isLoading = false;
//         });
//       });
//     }
//
//   }
//
//   updateTimeMotionStudy() {
//     setState(() {
//       isLoading = true;
//     });
//     HTTPManager().updateTimeMotion(UpdateTimeMotionRequestModel(
//       elId: userId,
//       id: widget.timeMotion.id,
//       companyId: initialCompanyItem.companyId.toString(),
//       cityId: initialCityItem.id,
//       channelId: initialChannelItem.id,
//       noMinutes: noOfMinController.text,
//     )).then((value) {
//
//       print(value);
//
//       showToastMessage(true,"Time motion study updated successfully");
//       Navigator.of(context).pop();
//       setState(() {
//         isLoading = false;
//       });
//     }).catchError((e) {
//       print(e.toString());
//       showToastMessage(false,e.toString());
//       setState(() {
//         isLoading = false;
//       });
//     });
//
//
//   }
// }
