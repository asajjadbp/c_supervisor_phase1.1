
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

showToastMessage(bool isSuccess, String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor:isSuccess? Colors.green : Colors.red,
      textColor: Colors.white,
      fontSize: 16.0
  );
}