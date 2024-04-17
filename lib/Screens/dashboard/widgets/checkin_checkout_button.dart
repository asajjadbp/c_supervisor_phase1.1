import 'package:flutter/material.dart';

import '../../utills/app_colors_new.dart';
import '../../widgets/toast_message_show.dart';

class CheckInButton extends StatelessWidget {
  const CheckInButton({super.key,required this.isCheckedIn,required this.isLoading2,required this.onTap});

  final bool isCheckedIn;
  final bool isLoading2;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (!isCheckedIn) {
         onTap();
        } else {
          showToastMessage(
              false, "You need to Check out first");
        }
      },
      child: Card(
        color: !isCheckedIn
            ? AppColors.graphButtonColor
            : isLoading2 ? AppColors.greyColor : AppColors.white,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              !isCheckedIn ? Image.asset("assets/myicons/check_in_white_icon.png",width: 23,height: 23,) : Image.asset("assets/myicons/check_in_blue_icon.png",width: 23,height: 23,),
              const SizedBox(width:15),
              Text("Check In",style: TextStyle(color: !isCheckedIn
                  ? AppColors.white
                  : AppColors.black,fontSize: 13,fontWeight: FontWeight.w400),)
            ],
          ),
        ),
      ),
    );
  }
}

class CheckOutButton extends StatelessWidget {
  const CheckOutButton({super.key,required this.isCheckedIn,required this.isLoading2,required this.onTap});

  final bool isCheckedIn;
  final bool isLoading2;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (isCheckedIn) {
        onTap();
        } else {
          showToastMessage(
              false, "You need to Check In first");
        }
      },
      child: Card(
        color: isCheckedIn
            ? AppColors.graphButtonColor
            : isLoading2 ? AppColors.greyColor : AppColors.white,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              isCheckedIn ? Image.asset("assets/myicons/check_out_white_icon.png",width: 23,height: 23,) : Image.asset("assets/myicons/check_out_blue_icon.png",width: 23,height: 23,),
              const SizedBox(width:15),
              Text("Check Out",style: TextStyle(color: isCheckedIn
                  ? AppColors.white
                  : AppColors.black,fontSize: 13,fontWeight: FontWeight.w400),)
            ],
          ),
        ),
      ),
    );
  }
}

