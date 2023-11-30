import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utills/app_colors_new.dart';
import '../utills/user_constants.dart';
import '../widgets/header_background_new.dart';
import '../widgets/header_widgets_new.dart';
import 'my_journey_plan_module_new.dart';

class MyJourneyPlanScreenNew extends StatefulWidget {
  const MyJourneyPlanScreenNew({Key? key}) : super(key: key);

  @override
  State<MyJourneyPlanScreenNew> createState() => _MyJourneyPlanScreenNewState();
}

class _MyJourneyPlanScreenNewState extends State<MyJourneyPlanScreenNew> {

  String userName = "";
  String userId = "";

  @override
  void initState() {
    // TODO: implement initState
    getUserData();
    super.initState();
  }

  getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      userName = sharedPreferences.getString(UserConstants().userName)!;
      userId = sharedPreferences.getString(UserConstants().userId)!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HeaderBackgroundNew(
        childWidgets: [
          const HeaderWidgetsNew(pageTitle: "My JP",isBackButton: true,isDrawerButton: true,),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: 40,
                  itemBuilder: (context,index) {
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      shadowColor: Colors.black12,
                      elevation: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Row(
                              children: [
                                Expanded(child: Text("Panda 200010 Malaika Panda 200010 Malaika Panda 200010 Malaika",overflow: TextOverflow.ellipsis,style: TextStyle(color: AppColors.primaryColor),)),
                                SizedBox(width: 5,),
                                Text("|",style: TextStyle(color: AppColors.greyColor),),
                                SizedBox(width: 5,),
                                Row(
                                  children: [
                                    Icon(Icons.close,color: AppColors.redColor,),
                                    Text("Pending",style: TextStyle(color: AppColors.redColor),)
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Text("TMR: Panda 200010 Malaika Panda 200010 Malaika Panda 200010 Malaika",overflow: TextOverflow.ellipsis,style: TextStyle(color: AppColors.blue),),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Row(children: [
                                  Icon(Icons.calendar_month,color: AppColors.primaryColor,),
                                  Text("2023-11-30")
                                ],),
                                ElevatedButton(
                                  onPressed: (){
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const MyJourneyModuleNew()));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.purple,
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                  ),
                                  child: const Text("Start visit"),
                                ),
                              ],
                            )
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   crossAxisAlignment: CrossAxisAlignment.center,
                            //   mainAxisSize: MainAxisSize.min,
                            //   children: [
                            //     ElevatedButton(
                            //         onPressed: (){
                            //
                            //         },
                            //       style: ElevatedButton.styleFrom(
                            //           primary: Colors.yellow,
                            //           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            //       ),
                            //         child: const Text("Pending",style: TextStyle(color: AppColors.black),),
                            //     ),
                            //     const SizedBox(width: 10,),
                            //     ElevatedButton(
                            //         onPressed: (){
                            //         Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const MyJourneyModuleNew()));
                            //         },
                            //       style: ElevatedButton.styleFrom(
                            //           primary: Colors.purple,
                            //           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            //       ),
                            //         child: const Text("Start visit"),
                            //     ),
                            //   ],
                            // )
                          ],
                        ),
                      ),
                    );
                  }
                  ),
            )
          )
        ],
      )
    );
  }
}
