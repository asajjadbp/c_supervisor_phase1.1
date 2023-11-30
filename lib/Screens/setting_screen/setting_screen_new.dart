import 'package:c_supervisor/Screens/utills/user_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/alert_dialogues.dart';
import '../widgets/header_background_new.dart';
import '../widgets/header_widgets_new.dart';

class SettingScreenNew extends StatefulWidget {
  const SettingScreenNew({Key? key}) : super(key: key);

  @override
  State<SettingScreenNew> createState() => _SettingScreenNewState();
}

class _SettingScreenNewState extends State<SettingScreenNew> {

  late String userName;

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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HeaderBackgroundNew(
        childWidgets: [
          HeaderWidgetsNew(pageTitle: userName,isBackButton: true,isDrawerButton: false),
          Expanded(
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    showPopUponBackButton(context);
                  },
                  child: Card(
                      color: Colors.white70.withAlpha(240),
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      shadowColor: Colors.black12,
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Container(
                        height: 60,
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/logout_ic.svg',
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              "Logout",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                  fontSize: 18),
                            )
                          ],
                        ),
                      )),
                ),
              ],
            )
          )
        ],
      ),
    );
  }
}
