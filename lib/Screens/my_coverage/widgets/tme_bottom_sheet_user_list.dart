
import 'package:flutter/material.dart';

import '../../../Model/response_model/tmr_responses/tmr_list_response.dart';
import '../../utills/app_colors_new.dart';

selfieOptionForJpBottomSheet(BuildContext context,bool isLoadingLocation,String isSelfieWithTmr,String isSelfieWithTmrWorking,String isSelfieWithTmrCompleted,Function(String value) selectedOption) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
          builder: (BuildContext context, StateSetter menuState){
            return Container(
                height: MediaQuery.of(context).size.height * 0.25,
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
                        child: ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            children: [
                              InkWell(
                                onTap: () {
                                  if(isSelfieWithTmr != "1") {
                                    menuState(() {
                                      selectedOption("1");
                                    });
                                  }
                                },
                                child:  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                                    child: Row(
                                      children: [
                                        const Expanded(child: Text("Take Selfie with TMR",style: TextStyle(fontSize: 15),)),
                                        if(isSelfieWithTmr == "1")
                                          const Icon(Icons.lock,color: AppColors.primaryColor,),
                                      ],
                                    )),
                              ),
                              const Divider(color: AppColors.primaryColor,),
                              InkWell(
                                onTap: () {
                                  if(isSelfieWithTmrWorking != "2") {
                                    menuState(() {
                                      selectedOption("2");
                                    });
                                  }
                                },
                                child:  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                                    child: Row(
                                      children: [
                                        const Expanded(child: Text("Take Picture of TMR during work",style: TextStyle(fontSize: 15),)),
                                        if(isSelfieWithTmrWorking == "2")
                                        const Icon(Icons.lock,color: AppColors.primaryColor,)
                                      ],
                                    )),
                              ),
                              const Divider(color: AppColors.primaryColor,),
                              InkWell(
                                onTap: () {
                                  if(isSelfieWithTmrCompleted != "3") {
                                    menuState(() {
                                      selectedOption("3");
                                    });
                                  }
                                },
                                child:  Padding(
                                    padding:const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                                    child: Row(
                                      children: [
                                        const Expanded(child: Text("Take Picture when TMR completed his work(optional)",style: TextStyle(fontSize: 15),)),
                                        if(isSelfieWithTmrCompleted == "3")
                                          const Icon(Icons.lock,color: AppColors.primaryColor,)
                                      ],
                                    )),
                              ),
                              const Divider(color: AppColors.primaryColor,),
                            ],
                        )),
                    // IgnorePointer(
                    //   ignoring: isLoadingLocation,
                    //   child: ElevatedButton(
                    //     onPressed: () {
                    //       onTap();
                    //     },
                    //     style: ElevatedButton.styleFrom(
                    //       backgroundColor: isLoadingLocation
                    //           ? AppColors.lightgreytn
                    //           : AppColors.primaryColor,
                    //       padding: const EdgeInsets.symmetric(
                    //           horizontal: 20, vertical: 10),
                    //     ),
                    //     child: const Text(" Next "),
                    //   ),
                    // ),
                    const SizedBox(height: 5,),
                  ],
                )
            );
          })
  );
}

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