

import 'dart:io';

import 'package:c_supervisor/Screens/authentication/login_screen.dart';
import 'package:c_supervisor/Screens/utills/app_colors_new.dart';
import 'package:c_supervisor/Screens/widgets/toast_message_show.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import '../../Model/request_model/start_journey_plan_request.dart';
import '../../Model/response_model/journey_responses_plan/journey_plan_response_list.dart';
import '../../Network/http_manager.dart';
import '../my_jp/my_journey_plan_module_new.dart';
import '../utills/user_session.dart';

showPopUponBackButton(BuildContext context) {

  // set up the buttons
  Widget cancelButton = TextButton(
    child:const Text("No"),
    onPressed:  () {
      Navigator.of(context).pop();
      // _changeProfile(userNameController.text,emailController.text,_timezone,firebaseDeviceToken);
    },
  );
  Widget continueButton = TextButton(
    child:const Text("Yes"),
    onPressed:  () {
      UserSessionState().clearUserSession();
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> const LoginScreen()), (route) => false);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("Logout"),
    content: const Text("Are you sure you want to logout?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}


showPopUpForImageUpload(BuildContext context,XFile imageFile,Function onTap,JourneyResponseListItem journeyResponseListItem,Position? currentLocation) {
  bool isLoading = false;
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("Picked Image"),
    content: StatefulBuilder(
      builder: (BuildContext context,StateSetter setState) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.3,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Expanded(child: isLoading ? const Center(child: CircularProgressIndicator(color: AppColors.primaryColor,),) : Image.file(File(imageFile.path))),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        border: Border.all(color: AppColors.primaryColor)
                    ),
                    child: IconButton(onPressed: (){
                      setState(() {
                        // isGoalsTabActive = true;
                      });

                      Navigator.of(context).pop();
                    }, icon: const Icon(Icons.close,color: AppColors.redColor,size: 40,)),
                  ),
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primaryColor)
                    ),
                    child: IconButton(
                        onPressed: (){
                          setState((){
                            isLoading = true;
                          });
                          onTap();

                          // Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MyJourneyModuleNew(journeyResponseListItem: journeyResponseListItem,)));
                        }, icon: const Icon(Icons.check,color: AppColors.primaryColor,size: 40,)),
                  ),
                ],
              )
            ],
          ),
        );
      }
    ),
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
