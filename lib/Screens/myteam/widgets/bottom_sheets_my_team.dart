

import 'package:c_supervisor/Model/response_model/my_team_responses/add_special_visit/client_list_model_response.dart';
import 'package:c_supervisor/Model/response_model/my_team_responses/add_special_visit/companies_list_model_response.dart';
import 'package:c_supervisor/Model/response_model/my_team_responses/add_special_visit/reason_list_model_response.dart';
import 'package:c_supervisor/Model/response_model/my_team_responses/add_special_visit/store_list_model_response.dart';
import 'package:c_supervisor/Model/response_model/my_team_responses/team_kpi_reponses/feedback_list_response_model.dart';
import 'package:c_supervisor/Model/response_model/tmr_responses/tmr_list_response.dart';
import 'package:flutter/material.dart';

import '../../utills/app_colors_new.dart';

feedbackDropdownBottomSheet (BuildContext context,FeedbackListItem initialFeedbackListItem,List<FeedbackListItem> feedBackList,Function(FeedbackListItem value) selectedFeedBackItem, Function onTap) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
          builder: (BuildContext context, StateSetter menuState){
            return Container(
                height: MediaQuery.of(context).size.height * 0.2,
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
                    Container(
                      margin:const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.primaryColor)
                      ),
                      child: DropdownButtonHideUnderline(
                          child: DropdownButton<FeedbackListItem>(
                            value: initialFeedbackListItem,
                              items: feedBackList.map((FeedbackListItem items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items.name!),
                            );
                          }).toList(),
                              onChanged: (value) {
                                menuState((){
                                  initialFeedbackListItem = value!;
                                  selectedFeedBackItem(value);
                                });
                          })),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        onTap();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width/4, vertical: 10),
                      ),
                      child: const Text("Save"),
                    ),
                    const SizedBox(height: 5,),
                  ],
                )
            );
          })
  );
}

addSpecialVisitDropdownBottomSheet (BuildContext context,
    ClientListItem initialClientListItem,
    List<ClientListItem> clientList,
    Function(ClientListItem value) selectedClientItem,
    StoresListItem initialStoreListItem,
    List<StoresListItem> storeList,
    Function(StoresListItem value) selectedStoreItem,
    TmrUserItem initialTmrListItem,
    List<TmrUserItem> tmrUserList,
    Function(TmrUserItem value) selectedTmrItem,
    ReasonListItem initialReasonListItem,
    List<ReasonListItem> reasonList,
    Function(ReasonListItem value) selectedReasonItem,
    Function onTap) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
          builder: (BuildContext context, StateSetter menuState){
            return Container(
                height: MediaQuery.of(context).size.height * 0.6,
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
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin:const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                          border: Border.all(color: AppColors.primaryColor)
                      ),
                      child: DropdownButtonHideUnderline(
                          child: DropdownButton<ClientListItem>(
                              value: initialClientListItem,
                              items: clientList.map((ClientListItem items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(items.companyName!),
                                );
                              }).toList(),
                              onChanged: (value) {
                                menuState((){
                                  initialClientListItem = value!;
                                  selectedClientItem(value);
                                });
                              })),
                    ),
                    const SizedBox(height: 5,),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin:const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                          border: Border.all(color: AppColors.primaryColor)
                      ),
                      child: DropdownButtonHideUnderline(
                          child: DropdownButton<StoresListItem>(
                              value: initialStoreListItem,
                              items: storeList.map((StoresListItem items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(items.name!),
                                );
                              }).toList(),
                              onChanged: (value) {
                                menuState((){
                                  initialStoreListItem = value!;
                                  selectedStoreItem(value);
                                });
                              })),
                    ),
                    const SizedBox(height: 5,),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin:const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                          border: Border.all(color: AppColors.primaryColor)
                      ),
                      child: DropdownButtonHideUnderline(
                          child: DropdownButton<TmrUserItem>(
                              value: initialTmrListItem,
                              items: tmrUserList.map((TmrUserItem items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(items.fullName!),
                                );
                              }).toList(),
                              onChanged: (value) {
                                menuState((){
                                  initialTmrListItem = value!;
                                  selectedTmrItem(value);
                                });
                              })),
                    ),
                    const SizedBox(height: 5,),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin:const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                          border: Border.all(color: AppColors.primaryColor)
                      ),
                      child: DropdownButtonHideUnderline(
                          child: DropdownButton<ReasonListItem>(
                              value: initialReasonListItem,
                              items: reasonList.map((ReasonListItem items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(items.reason!),
                                );
                              }).toList(),
                              onChanged: (value) {
                                menuState((){
                                  initialReasonListItem = value!;
                                  selectedReasonItem(value);
                                });
                              })),
                    ),
                    const SizedBox(height: 5,),
                    ElevatedButton(
                      onPressed: () {
                        onTap();
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
                )
            );
          })
  );
}