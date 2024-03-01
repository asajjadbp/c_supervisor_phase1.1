import 'package:c_supervisor/Screens/authentication/login_screen.dart';
import 'package:c_supervisor/Screens/utills/app_colors_new.dart';
import 'package:c_supervisor/Screens/widgets/toast_message_show.dart';
import 'package:c_supervisor/provider/license_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/header_background_new.dart';
import '../widgets/header_widgets_new.dart';

class MyLicense extends StatefulWidget {
  const MyLicense({super.key});

  @override
  State<MyLicense> createState() => _MyLicenseState();
}

class _MyLicenseState extends State<MyLicense> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String licenseInput = "";
  bool isLoading = false;

  void submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      isLoading = true;
    });

    await Provider.of<LicenseProvider>(context, listen: false)
        .getAppLicence(licenseInput)
        .then((value) {
      setState(() {
        isLoading = false;
      });
      if (value["status"]) {
        showToastMessage(true, "License get successfully");
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false);
      } else {
        showToastMessage(false, "License did not get");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IgnorePointer(
        ignoring: false,
        child: HeaderBackgroundNew(childWidgets: [
          HeaderWidgetsNew(
              pageTitle: "License", isBackButton: false, isDrawerButton: false),
          SizedBox(
            height: 130,
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: TextFormField(
                    // controller: emailController,
                    initialValue: "",
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.person,
                        color: AppColors.lightgreytn,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        borderSide: BorderSide(
                          color: AppColors.lightgreytn,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                          borderSide: BorderSide(
                            color: AppColors.lightgreytn,
                          )),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.0)),
                      labelText: 'License Key',
                      labelStyle: TextStyle(color: Colors.black),
                      hintText: 'License Key',
                      hintStyle: TextStyle(color: Colors.black),
                      contentPadding: EdgeInsets.symmetric(vertical: 23),
                      filled: true,
                      fillColor: Color.fromARGB(255, 226, 226, 226),
                    ),
                    keyboardType: TextInputType.text,

                    // style: const TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "License key is required";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      licenseInput = value.toString();
                    },
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                InkWell(
                  onTap: () {
                    submitForm();
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: AppColors.primaryColor,
                    child: SizedBox(
                      height: 40,
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ))
                            : const Text(
                                "Submit",
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
