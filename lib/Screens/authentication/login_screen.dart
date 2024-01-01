import 'package:c_supervisor/Network/http_manager.dart';
import 'package:c_supervisor/Screens/utills/user_session.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      emailController.text = "";
      passwordController.text = "";
    });

    super.initState();
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
                const Text(
                  "Welcome Back!",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold),
                ),
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
                            child: SizedBox(
                              height: 40,
                              width: MediaQuery.of(context).size.width,
                              child: Center(
                                child: isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.black,
                                        ))
                                    : const Text("Login"),
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
        setState(() {
          isLoading = false;
        });
        showToastMessage(true, "Logged in successfully");
        print(logInResponseModel.data![0].geoFence);
        UserSessionState().setUserSession(
            true,
            logInResponseModel.data![0].geoFence!,
            logInResponseModel.data![0].id!.toString(),
            logInResponseModel.data![0].fullName!,
            logInResponseModel.data![0].email!);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const MainDashboardNew()),
            (route) => false);
      }).catchError((e) {
        print(e);
        showToastMessage(false, e.toString());
        setState(() {
          isLoading = false;
        });
      });
    }
  }
}
