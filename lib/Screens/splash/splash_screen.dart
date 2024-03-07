// ignore_for_file: avoid_print

import 'dart:async';

import 'package:c_supervisor/Screens/dashboard/main_dashboard_new.dart';
import 'package:c_supervisor/Screens/utills/app_colors_new.dart';
import 'package:c_supervisor/Screens/utills/user_constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../authentication/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool userLoggedIn = false;

  @override
  void initState() {
    // TODO: implement initState
    getUserData();

    Timer(
        const Duration(seconds: 5),
        () => userLoggedIn
            ? Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const MainDashboardNew()))
            : Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const LoginScreen())));

    super.initState();
  }

  getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      userLoggedIn = sharedPreferences.getBool(UserConstants().userLoggedIn)!;
    });

    print("UserLoggedIn");
    print(userLoggedIn);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(color: AppColors.primaryColor
            // image: DecorationImage(
            //   image: AssetImage('assets/backgrounds/splash_bg.png'),
            //   fit: BoxFit.cover,
            // ),
            ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                // 'assets/icons/supervisor_logo.png',
                'assets/myicons/supervisor.png',
                height: 165,
                width: 250,
              ),
              const Text(
                "Welcome To CSupervisor",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }
}
