import 'package:flutter/material.dart';

import '../../widgets/toast_message_show.dart';

class SmallButtonIconWidget extends StatelessWidget {
  const SmallButtonIconWidget({super.key,required this.isCheckedIn,required this.onTap,required this.imagePath,required this.buttonTitle});

  final bool isCheckedIn;
  final Function onTap;
  final String imagePath;
  final String buttonTitle;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (isCheckedIn) {
          showToastMessageBottom(false,
              "Please check out first and try again");
        } else {
          onTap();
        }
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(imagePath,width: 23,height: 23,),
              const SizedBox(width:15),
              Text(buttonTitle,style: const TextStyle(fontSize: 13,fontWeight: FontWeight.w400),)
            ],
          ),
        ),
      ),
    );
  }
}
