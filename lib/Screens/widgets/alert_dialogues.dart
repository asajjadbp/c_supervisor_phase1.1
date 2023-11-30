import 'package:c_supervisor/Screens/authentication/login_screen.dart';
import 'package:flutter/material.dart';

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
