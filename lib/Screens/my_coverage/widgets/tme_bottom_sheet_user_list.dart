
import 'package:c_supervisor/Model/response_model/tme_responses/tmr_list_response.dart';
import 'package:flutter/material.dart';

import '../../utills/app_colors_new.dart';

tmrBottomSheetUserList (BuildContext context, TmrUserList tmrUserList, int selectedTmrUser, bool isLoadingLocation,Function(TmrUserItem value) selectedTmr, Function onTap) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
          builder: (BuildContext context, StateSetter menuState){
            return Container(
                height: MediaQuery.of(context).size.height * 0.65,
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
                    Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: tmrUserList.data!.length,
                            itemBuilder: (context, int index) {
                              return InkWell(
                                onTap: () {
                                  menuState(() {
                                    selectedTmrUser = index;
                                    selectedTmr(tmrUserList.data![index]);
                                  });
                                },
                                child: Card(
                                  child: Row(
                                    children: [
                                      Expanded(child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Text(tmrUserList.data![index].fullName!))),
                                      Radio(
                                          fillColor: MaterialStateProperty.resolveWith<Color>(
                                                  (Set<MaterialState> states) {
                                                return AppColors.primaryColor;
                                              }),

                                          value: index,
                                          groupValue: selectedTmrUser,
                                          onChanged: (int? value) {

                                          })
                                    ],
                                  ),
                                ),
                              );
                            })),
                    IgnorePointer(
                      ignoring: isLoadingLocation,
                      child: ElevatedButton(
                        onPressed: () {
                          onTap();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isLoadingLocation
                              ? AppColors.lightgreytn
                              : AppColors.primaryColor,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                        ),
                        child: const Text("Continue"),
                      ),
                    ),
                    const SizedBox(height: 5,),
                  ],
                )
            );
          })
  );
}