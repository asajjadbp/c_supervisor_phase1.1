import 'package:c_supervisor/Screens/utills/app_colors_new.dart';
import 'package:flutter/material.dart';

import '../../../Model/request_model/common_api_call_request.dart';
import '../../../Model/response_model/common_list/comon_list_response_model.dart';
import '../../../Model/response_model/my_team_responses/add_special_visit/store_list_model_response.dart';
import '../../../Network/http_manager.dart';

// commonSuggestBottomSheet(BuildContext context,String searchBy,String termType,String termTerm,Function(CommonListItem value) selectedOption,String elId, String companyId) {
//
//   bool isLoading2 = false;
//   TextEditingController _searchController = TextEditingController();
//
//   List<CommonListItem> cityCommonListModel = <CommonListItem>[];
//
//   showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => Padding(
//         padding: MediaQuery.of(context).viewInsets,
//         child: StatefulBuilder(
//             builder: (BuildContext context, StateSetter menuState){
//               return Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 10),
//                   height: MediaQuery.of(context).size.height * 0.35,
//                   decoration: const BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(25.0),
//                       topRight: Radius.circular(25.0),
//                     ),
//                   ),
//                   child: Column(
//                     children: [
//                       const SizedBox(height: 11,),
//                       TextFormField(
//                         controller: _searchController,
//                         decoration: const InputDecoration(
//                           enabledBorder: OutlineInputBorder(
//                             borderSide: BorderSide(
//                               color: AppColors.primaryColor,
//                             ),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                 color: AppColors.primaryColor,
//                               )),
//                           border: OutlineInputBorder(
//
//                               borderSide: BorderSide(
//                                   color: AppColors.primaryColor, width: 1.0)),
//                           labelStyle: TextStyle(color: AppColors.black),
//                           hintText: "Add at least 3 alphabets",
//                           hintStyle: TextStyle(color: AppColors.greyColor),
//                           contentPadding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
//                         ),
//                         onChanged: (value) {
//                           if(value.length>2) {
//                             menuState(() {
//                               isLoading2 = true;
//                             });
//
//                             print(searchBy);
//                             print(termTerm);
//                             print(termType);
//                             print(elId);
//                             print(companyId);
//
//                             HTTPManager().commonApiCallForList(CommonApiCallRequestModel(
//                               searchBy: searchBy,
//                               termTerm: value,
//                               termType: termType,
//                               elId: elId,
//                               companyId: companyId,
//                             ))
//                                 .then((value) {
//                               menuState(() {
//                                 cityCommonListModel = value.results!;
//                                 isLoading2 = false;
//                               });
//
//                             }).catchError((e) {
//                               menuState(() {
//                                 isLoading2 = false;
//                               });
//                             });
//                           }
//                         },
//                       ),
//                       const SizedBox(height: 5,),
//                       Expanded(
//                           child:_searchController.text.isEmpty ? const Center(child: Text("Nothing Searched yet"),) : isLoading2 ? const Center(child: CircularProgressIndicator(color: AppColors.primaryColor,),) :
//                           cityCommonListModel.isEmpty ?  const Center(child: Text("Search list is empty"),) : ListView.builder(
//                             itemCount: cityCommonListModel.length,
//                               shrinkWrap: true,
//                               itemBuilder: (context,index) {
//                                 return InkWell(
//                                   onTap: () {
//                                     selectedOption(cityCommonListModel[index]);
//                                     Navigator.of(context).pop();
//                                   },
//                                   child: Column(
//                                     children: [
//                                       Container(
//                                           margin:const EdgeInsets.symmetric(vertical: 5),
//                                           child: Text(cityCommonListModel[index].text!)),
//                                       const Divider(color: AppColors.primaryColor,),
//                                     ],
//                                   ),
//                                 );
//                               })
//                       ),
//                       const SizedBox(height: 5,),
//                     ],
//                   )
//               );
//             }),
//       )
//   );
// }


storeListBottomSheet(BuildContext context,List<StoresListItem> storeList,Function(StoresListItem value) selectedOption) {

  TextEditingController _searchController = TextEditingController();
  List<StoresListItem> searchList = <StoresListItem>[];

  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: StatefulBuilder(
            builder: (BuildContext context, StateSetter menuState){
              return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  height: MediaQuery.of(context).size.height * 0.35,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25.0),
                      topRight: Radius.circular(25.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 11,),
                      TextFormField(
                        controller: _searchController,
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
                          hintText: "Search with name",
                          hintStyle: TextStyle(color: AppColors.greyColor),
                          contentPadding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                        ),
                        onChanged: (value) {
                          print(value);

                          menuState(() {
                            if(value.isEmpty) {
                              return;
                            } else {
                              searchList.clear();
                              for (StoresListItem storeListItem in storeList) {
                                if (storeListItem.name!.toString().toLowerCase().contains(value.toLowerCase())) {
                                  searchList.add(storeListItem);
                                }
                              }
                            }
                          });
                          menuState(() {});
                        },
                      ),
                      const SizedBox(height: 5,),
                      Expanded(
                          child:_searchController.text.isEmpty ? ListView.builder(
                              itemCount: storeList.length,
                              shrinkWrap: true,
                              itemBuilder: (context,index) {
                                return InkWell(
                                  onTap: () {
                                    selectedOption(storeList[index]);
                                    Navigator.of(context).pop();
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                          margin:const EdgeInsets.symmetric(vertical: 5),
                                          child: Text(storeList[index].name!)),
                                      const Divider(color: AppColors.primaryColor,),
                                    ],
                                  ),
                                );
                              }) : searchList.isEmpty ?  const Center(child: Text("Search list is empty"),) : ListView.builder(
                              itemCount: searchList.length,
                              shrinkWrap: true,
                              itemBuilder: (context,index) {
                                return InkWell(
                                  onTap: () {
                                    selectedOption(searchList[index]);
                                    Navigator.of(context).pop();
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                          margin:const EdgeInsets.symmetric(vertical: 5),
                                          child: Text(searchList[index].name!)),
                                      const Divider(color: AppColors.primaryColor,),
                                    ],
                                  ),
                                );
                              })
                      ),
                      const SizedBox(height: 5,),
                    ],
                  )
              );
            }),
      )
  );
}
