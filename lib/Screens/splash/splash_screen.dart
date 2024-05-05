// ignore_for_file: avoid_print

import 'dart:async';

import 'package:c_supervisor/Screens/dashboard/main_dashboard_new.dart';
import 'package:c_supervisor/Screens/utills/app_colors_new.dart';
import 'package:c_supervisor/Screens/utills/user_constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../authentication/login_screen.dart';
import '../dashboard/main_dashboard_graphs.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool userLoggedIn = false;
  String userTimeStamp = "";

  @override
  void initState() {
    // TODO: implement initState
    getUserData();

    Timer(const Duration(seconds: 5), () => userLoggedIn
            ? Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const DashboardGraphScreen()))
            : Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const LoginScreen())));

    super.initState();
  }

  getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    final currentTime = DateTime.now().toIso8601String().substring(0, 10);
    print(currentTime);

    if(sharedPreferences.containsKey(UserConstants().userLoggedIn) && sharedPreferences.containsKey(UserConstants().userTimeStamp)) {
      print("Check Response is true");
      setState(() {
        userLoggedIn = sharedPreferences.getBool(UserConstants().userLoggedIn)!;
        userTimeStamp = sharedPreferences.getString(UserConstants().userTimeStamp)!;
      });
      
      if(currentTime == userTimeStamp) {
        
        print(userTimeStamp);
        print(currentTime);
        
        setState(() {
          userLoggedIn = true;
        });
      } else {
        setState(() {
          userLoggedIn = false;
        });
      }
      
    } else {
      
      print("Check Response is false");
      userLoggedIn = false;
    }
    print("UserLoggedIn");
    print(userLoggedIn);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          padding: const EdgeInsets.only(top: 15),
          height: MediaQuery.of(context).size.height/1.3,
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(topRight: Radius.circular(40),topLeft:Radius.circular(40) ),
          ),
          alignment: Alignment.topCenter,
          child: Image.asset(
            // 'assets/icons/supervisor_logo.png',
            'assets/backgrounds/splash_logo.png',
          ),
        ),
      ),
    );
  }
}
