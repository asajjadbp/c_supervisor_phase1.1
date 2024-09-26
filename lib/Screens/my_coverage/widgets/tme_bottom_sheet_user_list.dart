
import 'package:flutter/material.dart';

import '../../../Model/response_model/tmr_responses/tmr_list_response.dart';
import '../../utills/app_colors_new.dart';

selfieOptionForJpBottomSheet(BuildContext context,bool isLoadingLocation,bool isSelfieWithTmr,bool isSelfieWithTmrWorking,bool isSelfieWithTmrCompleted,Function(String value) selectedOption) {
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
                                  print("Tap");
                                  // if(isSelfieWithTmr) {
                                    menuState(() {
                                      selectedOption("1");
                                    });
                                  // }
                                },
                                child:  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                                    child: Row(
                                      children: [
                                        const Expanded(child: Text("Take Selfie with TMR",style: TextStyle(fontSize: 15),)),
                                        if(isSelfieWithTmr)
                                          const Icon(Icons.check,color: AppColors.primaryColor,),
                                      ],
                                    )),
                              ),
                              const Divider(color: AppColors.primaryColor,),
                              InkWell(
                                onTap: () {
                                  // if(isSelfieWithTmrWorking) {
                                    menuState(() {
                                      selectedOption("2");
                                    });
                                  // }
                                },
                                child:  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                                    child: Row(
                                      children: [
                                        const Expanded(child: Text("Take Picture of TMR during work",style: TextStyle(fontSize: 15),)),
                                        if(isSelfieWithTmrWorking)
                                        const Icon(Icons.check,color: AppColors.primaryColor,)
                                      ],
                                    )),
                              ),
                              const Divider(color: AppColors.primaryColor,),
                              InkWell(
                                onTap: () {
                                  // if(isSelfieWithTmrCompleted) {
                                    menuState(() {
                                      selectedOption("3");
                                    });
                                  // }
                                },
                                child:  Padding(
                                    padding:const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                                    child: Row(
                                      children: [
                                        const Expanded(child: Text("Take Picture when TMR completed his work(optional)",style: TextStyle(fontSize: 15),)),
                                        if(isSelfieWithTmrCompleted)
                                          const Icon(Icons.check,color: AppColors.primaryColor,)
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

// class selfieOptionForJpBottomSheet extends StatefulWidget {
//   const selfieOptionForJpBottomSheet({super.key});
//
//   @override
//   State<selfieOptionForJpBottomSheet> createState() => _selfieOptionForJpBottomSheetState();
// }
//
// class _selfieOptionForJpBottomSheetState extends State<selfieOptionForJpBottomSheet> {
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }

void tmrBottomSheetUserList(
    BuildContext context,
    TmrUserList tmrUserList,
    int selectedTmrUser,
    bool isLoadingLocation,
    Function(TmrUserItem value) selectedTmr,
    Function onTap
    ) {
  TextEditingController _searchController = TextEditingController();
  List<TmrUserItem> searchList = tmrUserList.data!;
  selectedTmrUser = -1;
  // pass -1 so that in inital no radio button is selected
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => StatefulBuilder(
      builder: (BuildContext context, StateSetter menuState) {
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
              const SizedBox(height: 11),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.primaryColor, // Replace with your primary color
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.primaryColor, // Replace with your primary color
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.primaryColor, width: 1.0, // Replace with your primary color
                      ),
                    ),
                    labelStyle: TextStyle(color: Colors.black), // Replace with your black color
                    hintText: "Search with name",
                    hintStyle: TextStyle(color: Colors.grey), // Replace with your grey color
                    contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  ),
                  onChanged: (value) {
                    menuState(() {
                      if (value.isEmpty) {
                        searchList = tmrUserList.data!;
                      } else {
                        searchList = tmrUserList.data!.where((user) {
                          return user.fullName!.toLowerCase().contains(value.toLowerCase());
                        }).toList();
                      }
                    });
                  },
                ),
              ),
              const SizedBox(height: 5),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: searchList.length,
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
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text(searchList[index].fullName!),
                              ),
                            ),
                            Radio(
                              fillColor: MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                                  return  AppColors.primaryColor; // Replace with your primary color
                                },
                              ),
                              value: index,
                              groupValue: selectedTmrUser,
                              onChanged: (int? value) {
                                menuState(() {
                                  selectedTmrUser = value!;
                                  selectedTmr(searchList[value]);
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              IgnorePointer(
                ignoring: isLoadingLocation,
                child: InkWell(
                  onTap: () {
                    onTap();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF0F408D),
                          Color(0xFF6A82A9),
                        ],
                      ),
                    ),
                    child: const Text(
                      "Continue",
                      style: TextStyle(color: Colors.white), // Replace with your white color
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
            ],
          ),
        );
      },
    ),
  );
}
