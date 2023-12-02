import 'package:c_supervisor/Model/request_model/journey_plan_request.dart';
import 'package:c_supervisor/Network/http_manager.dart';
import 'package:c_supervisor/Screens/my_jp/widgets/my_jp_card_for_details.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Model/request_model/start_journey_plan_request.dart';
import '../../Model/response_model/journey_responses_plan/journey_plan_response_list.dart';
import '../utills/app_colors_new.dart';
import '../utills/user_constants.dart';
import '../widgets/alert_dialogues.dart';
import '../widgets/error_text_and_button.dart';
import '../widgets/header_background_new.dart';
import '../widgets/header_widgets_new.dart';
import '../widgets/toast_message_show.dart';
import 'my_journey_plan_module_new.dart';
import 'package:image_picker/image_picker.dart';

class MyJourneyPlanScreenNew extends StatefulWidget {
  const MyJourneyPlanScreenNew({Key? key}) : super(key: key);

  @override
  State<MyJourneyPlanScreenNew> createState() => _MyJourneyPlanScreenNewState();
}

class _MyJourneyPlanScreenNewState extends State<MyJourneyPlanScreenNew> {

  String userName = "";
  String userId = "";
  bool isLoading = true;
  List<JourneyResponseListItem> journeyList = <JourneyResponseListItem>[];
  bool isError = false;
  String errorText = "";

  ImagePicker picker = ImagePicker();
  XFile? image;
  Position? _currentPosition;

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

    getJourneyPlanList(true);
  }

  getJourneyPlanList(bool isLoader) {
    setState(() {
      isLoading = isLoader;
    });

    HTTPManager().userJourneyPlanList(JourneyPlanRequestModel(elId: userId)).then((value) {
      setState(() {
        journeyList = value.data!;
        isLoading = false;
        isError = false;
      });

    }).catchError((e){
      setState(() {
        isError = true;
        errorText = e.toString();
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HeaderBackgroundNew(
        childWidgets: [
          const HeaderWidgetsNew(pageTitle: "My JP",isBackButton: true,isDrawerButton: true,),
          Expanded(
            child: isLoading ? const Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor,),
            ) : Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: isError ? ErrorTextAndButton(onTap: (){
                getJourneyPlanList(true);
              },errorText: errorText) : journeyList.isEmpty ? const Center(child: Text("No plans found"),) : ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: journeyList.length,
                  itemBuilder: (context,index) {
                    return MyJpCardForDetail(
                      storeName: journeyList[index].storeName!,
                      visitStatus: journeyList[index].visitStatus!,
                      tmrName: journeyList[index].tmrId.toString(),
                      workingDate: journeyList[index].workingDate!,
                      onTap: (){
                        _getCurrentPosition(journeyList[index],index);
                        // if(journeyList[index].visitStatus! == "PENDING" ) {
                        //   _getCurrentPosition(journeyList[index],index);
                        // } else {
                        //   Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MyJourneyModuleNew(journeyResponseListItem: journeyList[index],))).then((value) {
                        //     getJourneyPlanList(false);
                        //   });
                        // }
                      },
                    );

                    //   Card(
                    //   shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(15.0),
                    //   ),
                    //   semanticContainer: true,
                    //   clipBehavior: Clip.antiAliasWithSaveLayer,
                    //   shadowColor: Colors.black12,
                    //   elevation: 10,
                    //   child: Container(
                    //     padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
                    //     child: Column(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       mainAxisSize: MainAxisSize.min,
                    //       children: [
                    //          Row(
                    //           children: [
                    //             Expanded(child: Text(journeyList[index].storeName!,overflow: TextOverflow.ellipsis,style: const TextStyle(color: AppColors.primaryColor),)),
                    //             const SizedBox(width: 5,),
                    //             const Text("|",style: TextStyle(color: AppColors.greyColor),),
                    //             const SizedBox(width: 5,),
                    //             journeyList[index].visitStatus! == "PENDING" ? Row(
                    //               children: [
                    //                   const Icon(Icons.close,color: AppColors.redColor,size: 20,),
                    //                const SizedBox(width: 5,),
                    //                 Text(journeyList[index].visitStatus!,style: const TextStyle(color: AppColors.redColor),)
                    //               ],
                    //             ) : journeyList[index].visitStatus! == "FINISHED" ? Row(
                    //               children: [
                    //                 const Icon(Icons.check_circle,color: AppColors.green,size: 20,),
                    //                 const SizedBox(width: 5,),
                    //                 Text(journeyList[index].visitStatus!,style: const TextStyle(color: AppColors.green),)
                    //               ],
                    //             ) : Row(
                    //               children: [
                    //                 const Icon(Icons.pending,color: AppColors.primaryColor,size: 20,),
                    //                 const SizedBox(width: 5,),
                    //                 Text(journeyList[index].visitStatus!,style: const TextStyle(color: AppColors.primaryColor),)
                    //               ],
                    //             )
                    //           ],
                    //         ),
                    //         const SizedBox(
                    //           height: 5,
                    //         ),
                    //         Text("TMR: ${journeyList[index].tmrId.toString()}",overflow: TextOverflow.ellipsis,style: TextStyle(color: AppColors.blue),),
                    //         Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //           children: [
                    //              Row(children: [
                    //                const  Icon(Icons.calendar_month,color: AppColors.primaryColor,size: 20,),
                    //               const SizedBox(width: 5,),
                    //               Text(journeyList[index].workingDate!)
                    //             ],),
                    //             Visibility(
                    //               visible: journeyList[index].visitStatus! != "FINISHED",
                    //               child: ElevatedButton(
                    //                 onPressed: (){
                    //                   if(journeyList[index].visitStatus! == "PENDING" ) {
                    //                     _getCurrentPosition(journeyList[index],index);
                    //                   } else {
                    //                     Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MyJourneyModuleNew(journeyResponseListItem: journeyList[index],)));
                    //                   }
                    //                 },
                    //                 style: ElevatedButton.styleFrom(
                    //                   primary: Colors.purple,
                    //                   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    //                 ),
                    //                 child: const Text("Start visit"),
                    //               ),
                    //             ),
                    //           ],
                    //         )
                    //       ],
                    //     ),
                    //   ),
                    // );
                  }
                  ),
            )
          )
        ],
      )
    );
  }

  Future<void> _getCurrentPosition(JourneyResponseListItem journeyResponseListItem,int index) async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition()
        .then((Position position) {
      setState(() => _currentPosition = position);
      
      print("Current Position");
      print(_currentPosition);

      pickedImage(journeyResponseListItem,_currentPosition,index);

        }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> pickedImage(JourneyResponseListItem journeyResponseListItem,Position? currentLocation,int index)  async {
    image = await picker.pickImage(source: ImageSource.camera);
    if(image == null) {

    } else {
      showUploadOption(journeyResponseListItem, currentLocation,index);
    }
  }

  showUploadOption(JourneyResponseListItem journeyResponseListItem,Position? currentLocation,int index) {
    showPopUpForImageUpload(context, image!, (){
      String currentPosition = "${currentLocation!.latitude},${currentLocation.longitude}";
      print(currentPosition);
      if(image !=null && currentLocation.longitude != null) {
        startVisitCall(journeyResponseListItem, currentLocation,index);
      }
    }, journeyResponseListItem,currentLocation);
  }

  startVisitCall(JourneyResponseListItem journeyResponseListItem,Position? currentLocation,int index) {
    String currentPosition = "${currentLocation!.latitude},${currentLocation.longitude}";
    print(currentPosition);
    HTTPManager().startJourneyPlan(StartJourneyPlanRequestModel(elId: journeyResponseListItem.userId!.toString(),workingId: journeyResponseListItem.workingId.toString(),storeId: journeyResponseListItem.storeId.toString(),tmrId: journeyResponseListItem.tmrId.toString(),checkInGps: currentPosition,),image!).then((value) {

      showToastMessage(true, "Visit started successfully");

      // setState(() {
      //   journeyList[index].visitStatus = "IN PROGRESS";
      // });
      Navigator.of(context).pop();
      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MyJourneyModuleNew(journeyResponseListItem: journeyResponseListItem,))).then((value) {
        getJourneyPlanList(false);
      });
      setState((){
        isLoading = false;
      });
    }).catchError((e){
      showToastMessage(false, e.toString());
      setState((){
        isLoading = false;
      });
    });
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showToastMessage(false,'Location services are disabled. Please enable the services');
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //     content: Text('Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showToastMessage(false,'Location permissions are denied');
        // ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      showToastMessage(false,'Location permissions are permanently denied, we cannot request permissions.');
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //     content: Text('Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

}
