import 'package:flutter/material.dart';

import '../utills/app_colors_new.dart';

class LargeButtonInFooter extends StatelessWidget {
  const LargeButtonInFooter({Key? key,required this.buttonTitle,required this.onTap}) : super(key: key);

  final String buttonTitle;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return  InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 15),
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF0F408D),
                Color(0xFF6A82A9),
              ],
            ),
            borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10))
        ),
        child:  Text(buttonTitle,style: const TextStyle(fontSize:20,color: AppColors.white),),
      ),
    );
  }
}
