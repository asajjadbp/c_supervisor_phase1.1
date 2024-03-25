import 'dart:developer';
import 'dart:io';

import 'package:c_supervisor/Model/request_model/save_user_location_request.dart';
import 'package:c_supervisor/Network/http_manager.dart';
import 'package:c_supervisor/Screens/utills/app_colors_new.dart';
import 'package:c_supervisor/Screens/utills/user_session.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../Model/request_model/device_info_request.dart';
import '../../Model/request_model/login_request.dart';
import '../../Model/response_model/login_responses/login_response_model.dart';
import '../dashboard/main_dashboard_new.dart';
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

      if(Platform.isAndroid) {
        deviceData =
            _readAndroidBuildData((await deviceInfoPlugin.androidInfo));
      } else {
        deviceData =
            _readIosDeviceInfo((await deviceInfoPlugin.iosInfo));
      }

      print("Android Info");
      print(deviceData);

      print("+++++++DEVICE INFO++++++");
      log(deviceData['version.release'].toString());
      log(deviceData['id'].toString());
      log(deviceData['serialNumber'].toString());
      log(deviceData['manufacturer'].toString());
      log(deviceData['model'].toString());
      log(deviceData['brand'].toString());
      log(deviceData['version.sdkInt'].toString());

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
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          SizedBox(
            width: size.width,
            height: size.height,
            child: Image.asset(
              'assets/backgrounds/splash_bg.png',
              fit: BoxFit.fill,
              height: MediaQuery.of(context).size.height,
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 5,
                right: 10,
                left: 10),
            child: Column(
              children: [
                // Text(_mobileNumber),
                // fillCards(),
                // const Text(
                //   "Welcome Back!",
                //   style: TextStyle(
                //       color: Colors.white,
                //       fontSize: 26,
                //       fontWeight: FontWeight.bold),
                // ),
                const Text(
                  "Please Login to your account ",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
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
                              color: Colors.white,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16.0)),
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16.0)),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                )),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16.0)),
                                borderSide: BorderSide(
                                    color: Colors.white, width: 1.0)),
                            labelText: 'Username',
                            labelStyle: TextStyle(color: Colors.white),
                            hintText: 'Username',
                            hintStyle: TextStyle(color: Colors.white),
                            contentPadding: EdgeInsets.symmetric(vertical: 23),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(color: Colors.white),
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
                            filled: true,
                            enabledBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16.0)),
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            focusedBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16.0)),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                )),
                            border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16.0)),
                                borderSide: BorderSide(
                                    color: Colors.white, width: 1.0)),
                            labelText: 'Password',
                            labelStyle: const TextStyle(color: Colors.white),
                            prefixIcon: const Icon(
                              Icons.lock_open,
                              color: Colors.white,
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
                                  color: Colors.white,
                                )),
                            hintText: 'Password',
                            hintStyle: const TextStyle(color: Colors.white),
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 23),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          obscureText: isPasswordVisible,
                          style: const TextStyle(color: Colors.white),
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
                        const SizedBox(height: 12.0),
                        InkWell(
                          onTap: () {
                            _validateLoginForm();
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            color: Colors.white,
                            child: Container(
                              decoration:  BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF0F408D),
                                    Color(0xFF6A82A9),
                                  ],
                                )
                              ),
                              height: 40,
                              width: MediaQuery.of(context).size.width,
                              child: Center(
                                child: isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: AppColors.white,
                                        ))
                                    : const Text("Login",style: TextStyle(color: AppColors.white),),
                              ),
                            ),
                          ),
                        )
                      ],
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }

  void _validateLoginForm() {
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

        print(logInResponseModel.data![0].geoFence);
        UserSessionState().setUserSession(
            true,
            logInResponseModel.data![0].geoFence,
            logInResponseModel.data![0].id!.toString(),
            logInResponseModel.data![0].fullName!,
            logInResponseModel.data![0].email!);
        if(Platform.isAndroid) {
          _saveDeviceInfo(logInResponseModel.data![0].id!.toString());
        } else {
          _saveIosDeviceInfo(logInResponseModel.data![0].id!.toString());
        }
      }).catchError((e) {
        showToastMessage(false, e.toString());
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  _saveDeviceInfo(String elId) {

    setState(() {
      isLoading = true;
    });

    HTTPManager().saveDeviceInfo(DeviceInfoRequestModel(
      elId: elId,
      serialNumber: "${_deviceData['serialNumber'] ?? ""}",
      deviceId: "${_deviceData['id'] ?? ""}" ,
      model: "${_deviceData['model'] ?? ""}",
      manufacture: "${_deviceData['manufacturer'] ?? ""}",
      brand: "${_deviceData['brand'] ?? " "}",
      sdk: "${_deviceData['version.sdkInt'] ?? ""}",
      osVersion: "${_deviceData['version.release'] ?? ""}",
      simNumber: "",
      mobileDataUsage: "",
      wifiDataUsage: "",)).then((value) {

      setState(() {
        isLoading = false;
      });

      showToastMessage(true, "Logged in successfully");
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const MainDashboardNew()),
              (route) => false);

    }).catchError((e) {
      showToastMessage(false, e.toString());
      setState(() {
        isLoading = false;
      });
      print(e.toString());
    });
  }

  _saveIosDeviceInfo(String elId) {

    setState(() {
      isLoading = true;
    });

    HTTPManager().saveDeviceInfo(DeviceInfoRequestModel(
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
      wifiDataUsage: "",)).then((value) {

      setState(() {
        isLoading = false;
      });

      showToastMessage(true, "Logged in successfully");
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const MainDashboardNew()),
              (route) => false);

    }).catchError((e) {
      showToastMessage(false, e.toString());
      setState(() {
        isLoading = false;
      });
      print(e.toString());
    });
  }
}
