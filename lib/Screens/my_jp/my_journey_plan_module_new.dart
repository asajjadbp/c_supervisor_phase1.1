import 'package:c_supervisor/Screens/my_jp/widgets/my_journey_plan_module_card_item.dart';
import 'package:c_supervisor/Screens/widgets/toast_message_show.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Model/request_model/end_visit_request.dart';
import '../../Model/request_model/get_check_list_request.dart';
import '../../Model/response_model/checklist_responses/check_list_response_list_model.dart';
import '../../Model/response_model/journey_responses_plan/journey_plan_response_list.dart';
import '../../Network/http_manager.dart';
import '../utills/app_colors_new.dart';
import '../utills/user_constants.dart';
import '../widgets/error_text_and_button.dart';
import '../widgets/header_background_new.dart';
import '../widgets/header_widgets_new.dart';
import '../widgets/large_button_in_footer.dart';
import 'my_journey_plan_check_list.dart';

class MyJourneyModuleNew extends StatefulWidget {
  const MyJourneyModuleNew({Key? key,required this.journeyResponseListItem}) : super(key: key);
 final JourneyResponseListItem journeyResponseListItem;
  @override
  State<MyJourneyModuleNew> createState() => _MyJourneyModuleNewState();
}

class _MyJourneyModuleNewState extends State<MyJourneyModuleNew> {

  String userName = "";
  String userId = "";
  bool isLoading = true;
  bool isError = false;
  bool isEndLoading = false;
  String errorText = "";
  late CheckListResponseModel checkListResponseModel;
  Position? _currentPosition;
  int checkListPendingCount = 0;

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

    getCheckList(true);
  }

  getCheckList(bool loader) {
    setState(() {
      isLoading = loader;
    });

    HTTPManager().getCheckList(GetCheckListRequest(elId: userId,workingId:widget.journeyResponseListItem.workingId.toString() ,storeId: widget.journeyResponseListItem.storeId.toString(),tmrId:widget.journeyResponseListItem.tmrId.toString() )).then((value) {
      setState(() {
        checkListPendingCount = 0;
        checkListResponseModel = value;
        isLoading = false;
        isError = false;
      });
      for(int i = 0; i< checkListResponseModel.data!.length; i++) {
        if(checkListResponseModel.data![i].score == 0 || checkListResponseModel.data![i].score == 0.0 ) {
          setState(() {
            checkListPendingCount = checkListPendingCount + 1;
          });
        }
      }

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
          const HeaderWidgetsNew(pageTitle: "Journey Plan Module",isBackButton: true,isDrawerButton: true,),
          Expanded(
            child: isLoading ? const Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor,),
            ) : isError ? ErrorTextAndButton(onTap: (){
              getCheckList(true);
            },errorText: errorText) : GridView(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: (163.5 / 135),
                crossAxisCount: 2,
              ),
              children:  [
                // MyJourneyPlanModuleCardItem(
                //   onTap: () {},
                //   cardName: 'Photos',
                //   cardImage: 'assets/icons/images.png',
                // ),

                MyJourneyPlanModuleCardItem(
                  onTap: () {
                    if(checkListResponseModel.data!.isNotEmpty) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              MyJourneyPlanCheckList(
                                checkListResponseModel: checkListResponseModel,))).then((value) {
                        getCheckList(false);
                      });
                    } else {
                      showToastMessage(false, "Check list is empty");
                    }
                  },
                  pendingCheckListCount: checkListPendingCount,
                  cardName: "Check List",
                  cardImage:  "assets/icons/check_list.png",
                ),

              ],
            ),
          ),
          LargeButtonInFooter(buttonTitle: "Finish Visit", onTap: (){_getCurrentPosition();},)
        ],
      ),
    );
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition()
        .then((Position position) {
      setState(() => _currentPosition = position);

      print("Current Position");
      print(_currentPosition);
      String currentPosition = "${_currentPosition!.latitude},${_currentPosition!.longitude}";

      endVisit(currentPosition);

    }).catchError((e) {
      debugPrint(e);
    });
  }

  endVisit(String currentPosition) {
    setState(() {
      isLoading = true;
    });

    HTTPManager().endVisit(EndVisitRequestModel(elId: widget.journeyResponseListItem.userId.toString(),workingId: widget.journeyResponseListItem.workingId!.toString(),checkInGps: currentPosition )).then((value) {

      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pop();
      showToastMessage(true, "Visit Ended successfully");

    }).catchError((e) {
      setState(() {
        isLoading = false;
      });
      print(e);
      showToastMessage(false, e.toString());
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
