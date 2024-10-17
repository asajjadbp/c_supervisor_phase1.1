import 'dart:developer';
import 'dart:io';

import 'package:c_supervisor/Network/http_manager.dart';
import 'package:c_supervisor/Screens/utills/app_colors_new.dart';
import 'package:c_supervisor/Screens/utills/user_session.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:c_supervisor/Screens/utills/location_permission_handle.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import '../../Model/request_model/device_info_request.dart';
import '../../Model/request_model/login_request.dart';
import '../../Model/response_model/login_responses/login_response_model.dart';
import '../dashboard/main_dashboard_graphs.dart';
import '../widgets/toast_message_show.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool isPasswordVisible = true;
  bool isLoadingLocation = false;
  Position? _currentPosition;
  String currentPosition = "";

  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  // String _mobileNumber = '';
  // List<SimCard> _simCard = <SimCard>[];

  @override
  void initState() {
    // TODO: implement initState

    initPlatformState();

    // MobileNumber.listenPhonePermission((isPermissionGranted) {
    //   if (isPermissionGranted) {
    //     initMobileNumberState();
    //   } else {}
    // });
    //
    // initMobileNumberState();

    // setState(() {
    //   // 102114
    //   // BP102114
    //   emailController.text = "102515";
    //   // "101010";
    //   passwordController.text = "Admin786";
    // });

    super.initState();
  }

  // Future<void> initMobileNumberState() async {
  //   if (!await MobileNumber.hasPhonePermission) {
  //     await MobileNumber.requestPhonePermission;
  //     return;
  //   }
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   try {
  //     _mobileNumber = (await MobileNumber.mobileNumber)!;
  //     _simCard = (await MobileNumber.getSimCards)!;
  //
  //
  //     print("+++++++MOBILE NUMBER INFO++++++");
  //
  //   } on PlatformException catch (e) {
  //     debugPrint("Failed to get mobile number because of '${e.message}'");
  //   }
  //
  //   // If the widget was removed from the tree while the asynchronous platform
  //   // message was in flight, we want to discard the reply rather than calling
  //   // setState to update our non-existent appearance.
  //   if (!mounted) return;
  //
  //   setState(() {});
  // }
  //
  // Widget fillCards() {
  //   List<Widget> widgets = _simCard
  //       .map((SimCard sim) => Text(
  //       'numberSim Card Number: (${sim.countryPhonePrefix}) - ${sim.number}\nCarrier Name: ${sim.carrierName}\nCountry Iso: ${sim.countryIso}\nDisplay Name: ${sim.displayName}\nSim Slot Index: ${sim.slotIndex}\n\n'))
  //       .toList();
  //   return Column(children: widgets);
  // }

  Future<void> initPlatformState() async {
    var deviceData = <String, dynamic>{};

    try {
      if (Platform.isAndroid) {
        deviceData =
            _readAndroidBuildData((await deviceInfoPlugin.androidInfo));
      } else {
        deviceData = _readIosDeviceInfo((await deviceInfoPlugin.iosInfo));
      }

      // print("Android Info");
      // print(deviceData);
      //
      // print("+++++++DEVICE INFO++++++");
      // log(deviceData['version.release'].toString());
      // log(deviceData['id'].toString());
      // log(deviceData['serialNumber'].toString());
      // log(deviceData['manufacturer'].toString());
      // log(deviceData['model'].toString());
      // log(deviceData['brand'].toString());
      // log(deviceData['version.sdkInt'].toString());
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    if (!mounted) return;

    setState(() {
      _deviceData = deviceData;
    });
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'systemFeatures': build.systemFeatures,
      'displaySizeInches':
          ((build.displayMetrics.sizeInches * 10).roundToDouble() / 10),
      'displayWidthPixels': build.displayMetrics.widthPx,
      'displayWidthInches': build.displayMetrics.widthInches,
      'displayHeightPixels': build.displayMetrics.heightPx,
      'displayHeightInches': build.displayMetrics.heightInches,
      'displayXDpi': build.displayMetrics.xDpi,
      'displayYDpi': build.displayMetrics.yDpi,
      'serialNumber': build.serialNumber,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.primaryColor,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            margin: const EdgeInsets.only(right: 10, left: 10, top: 80),
            alignment: Alignment.center,
            child: Image.asset(
              'assets/backgrounds/login_logo.png',
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
                height: MediaQuery.of(context).size.height / 1.42,
                decoration: const BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(25),
                        topLeft: Radius.circular(25))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Welcome",
                      style: TextStyle(
                          color: AppColors.black,
                          fontSize: 32,
                          fontWeight: FontWeight.w700),
                    ),
                    const Text(
                      "Please Login to your account ",
                      style: TextStyle(
                          color: AppColors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(height: 16.0),
                    Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: emailController,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: AppColors.primaryColor,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(
                                      color: AppColors.primaryColor,
                                    )),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(
                                        color: AppColors.primaryColor,
                                        width: 1.0)),
                                labelText: 'Username',
                                labelStyle:
                                    TextStyle(color: AppColors.primaryColor),
                                hintText: 'Username',
                                hintStyle:
                                    TextStyle(color: AppColors.primaryColor),
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 18),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              style: const TextStyle(
                                  color: AppColors.primaryColor),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Username required";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            const SizedBox(height: 10.0),
                            TextFormField(
                              controller: passwordController,
                              decoration: InputDecoration(
                                enabledBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(
                                      color: AppColors.primaryColor,
                                    )),
                                border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(
                                        color: AppColors.primaryColor,
                                        width: 1.0)),
                                labelText: 'Password',
                                labelStyle: const TextStyle(
                                    color: AppColors.primaryColor),
                                prefixIcon: const Icon(
                                  Icons.lock_open,
                                  color: AppColors.primaryColor,
                                ),
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isPasswordVisible = !isPasswordVisible;
                                      });
                                    },
                                    icon: Icon(
                                      isPasswordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: AppColors.primaryColor,
                                    )),
                                hintText: 'Password',
                                hintStyle: const TextStyle(
                                    color: AppColors.primaryColor),
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 15),
                              ),
                              keyboardType: TextInputType.text,
                              obscureText: isPasswordVisible,
                              style: const TextStyle(
                                  color: AppColors.primaryColor),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Password required";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            // const SizedBox(height: 2.0),
                            // Align(
                            //   alignment: AlignmentDirectional.centerEnd,
                            //   child: TextButton(
                            //     onPressed: () {
                            //
                            //     },
                            //     child: const Text('Forget Password ?',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: AppColors.white),),
                            //   ),
                            // ),
                            const SizedBox(height: 16.0),
                            InkWell(
                              onTap: () {
                                _validateLoginForm();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF0F408D),
                                        Color(0xFF6A82A9),
                                      ],
                                    )),
                                height: 50,
                                width: MediaQuery.of(context).size.width,
                                child: Center(
                                  child: isLoading
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            color: AppColors.white,
                                          ))
                                      : const Text(
                                          "Login",
                                          style: TextStyle(
                                              color: AppColors.white),
                                        ),
                                ),
                              ),
                            )
                          ],
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    const Align(
                        alignment: Alignment.center,
                        child: Text(
    "Version 1.0.27",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w400),
                        )),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _validateLoginForm() async {
    final hasPermission = await handleLocationPermission();
    if (!hasPermission) return;
    setState(() {
      isLoading = true;
    });
    await Geolocator.getCurrentPosition().then((Position position) async {
      setState(() => _currentPosition = position);

      print("Current Position");
      print(_currentPosition);

      currentPosition =
          "${_currentPosition!.latitude},${_currentPosition!.longitude}";

      setState(() {
        isLoading = false;
      });
    }).catchError((e) {
      setState(() {
        isLoading = false;
      });
      debugPrint(e);
    });
    if (currentPosition != "") {
      if (_formKey.currentState?.validate() ?? false) {
        setState(() {
          isLoading = true;
        });
        HTTPManager()
            .loginUser(LoginRequestModel(
          userName: emailController.text,
          password: passwordController.text,
        ))
            .then((value) async {
          LogInResponseModel logInResponseModel = value;

          final currentTime = DateTime.now().toIso8601String().substring(0, 10);
          print(currentTime);
          print("+++++++++++++");
          print(logInResponseModel.data![0].id);
          print(logInResponseModel.data![0].name);

          UserSessionState().setUserSession(
              true,
              logInResponseModel.data![0].geoFence,//chnage into service
              logInResponseModel.data![0].id!.toString(),
              logInResponseModel.data![0].fullName!,
              logInResponseModel.data![0].email!,
              currentTime,
              logInResponseModel.data![0].name.toString());
          if (Platform.isAndroid) {
            _saveDeviceInfo(logInResponseModel.data![0].id!.toString());
          } else {
            _saveIosDeviceInfo(logInResponseModel.data![0].id!.toString());
          }
        }).catchError((e) {
          showToastMessageTop(false, e.toString());
          setState(() {
            isLoading = false;
          });
        });
      }
    } else {
      showToastMessageTop(false, "Please allow this to access you location");
    }
  }

  _saveDeviceInfo(String elId) {
    print("${_currentPosition!.latitude},${_currentPosition!.longitude}");
    setState(() {
      isLoading = true;
    });

    HTTPManager()
        .saveDeviceInfo(DeviceInfoRequestModel(
      elId: elId,
      serialNumber: "${_deviceData['serialNumber'] ?? ""}",
      deviceId: "${_deviceData['id'] ?? ""}",
      model: "${_deviceData['model'] ?? ""}",
      manufacture: "${_deviceData['manufacturer'] ?? ""}",
      brand: "${_deviceData['brand'] ?? " "}",
      sdk: "${_deviceData['version.sdkInt'] ?? ""}",
      osVersion: "${_deviceData['version.release'] ?? ""}",
      simNumber: "",
      mobileDataUsage: "",
      wifiDataUsage: "",
      latLong: "${_currentPosition!.latitude},${_currentPosition!.longitude}",
    ))
        .then((value) {
      setState(() {
        isLoading = false;
      });

      showToastMessageBottom(true, "Logged in successfully");
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const DashboardGraphScreen()),
          (route) => false);
    }).catchError((e) {
      showToastMessageBottom(false, e.toString());
      setState(() {
        isLoading = false;
      });
      print(e.toString());
    });
  }

  _saveIosDeviceInfo(String elId) {
    print("${_currentPosition!.latitude},${_currentPosition!.longitude}");
    setState(() {
      isLoading = true;
    });

    HTTPManager()
        .saveDeviceInfo(DeviceInfoRequestModel(
      elId: elId,
      serialNumber: "",
      deviceId: "${_deviceData['identifierForVendor'] ?? ""}",
      model: "${_deviceData['model'] ?? ""}",
      manufacture: "${_deviceData['systemName'] ?? ""}",
      brand: "${_deviceData['name'] ?? ""}",
      sdk: "${_deviceData['utsname.version'] ?? ""}",
      osVersion: "${_deviceData['utsname.release'] ?? ""}",
      simNumber: "",
      mobileDataUsage: "",
      wifiDataUsage: "",
      latLong: "${_currentPosition!.latitude},${_currentPosition!.longitude}",
    ))
        .then((value) {
      setState(() {
        isLoading = false;
      });

      showToastMessageBottom(true, "Logged in successfully");
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const DashboardGraphScreen()),
          (route) => false);
    }).catchError((e) {
      showToastMessageBottom(false, e.toString());
      setState(() {
        isLoading = false;
      });
      print(e.toString());
    });
  }
}
