
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

showToastMessageBottom(bool isSuccess, String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: isSuccess ? Colors.green : Colors.red,
      textColor: Colors.white,
      fontSize: 16.0
  );
}
  showToastMessageTop(bool isSuccess, String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor:isSuccess? Colors.green : Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
}