import 'package:c_supervisor/Screens/utills/user_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSessionState {

  late SharedPreferences _sharedPreferences;

  setUserSession(bool isLoggedIn,int geoFence,String userId,String userName,String userEmail) async {
    _sharedPreferences = await SharedPreferences.getInstance();

    _sharedPreferences.setBool(UserConstants().userLoggedIn,isLoggedIn);
    _sharedPreferences.setInt(UserConstants().userGeoFence,geoFence);
    _sharedPreferences.setString(UserConstants().userId,userId);
    _sharedPreferences.setString(UserConstants().userName,userName);
    _sharedPreferences.setString(UserConstants().userEmail,userEmail);
    // _sharedPreferences.setString(UserConstants().userCompanyName,userCompanyName);

  }

  clearUserSession() async {
    _sharedPreferences = await SharedPreferences.getInstance();

    _sharedPreferences.setBool(UserConstants().userLoggedIn,false);
    _sharedPreferences.remove(UserConstants().userId);
    _sharedPreferences.remove(UserConstants().userName);
    _sharedPreferences.remove(UserConstants().userEmail);
    _sharedPreferences.remove(UserConstants().userCompanyName);

  }
}