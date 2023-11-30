import 'package:flutter/material.dart';

import '../../utills/app_colors_new.dart';

class CheckListCommentTextField extends StatelessWidget {
  const CheckListCommentTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(
        enabledBorder:  OutlineInputBorder(
          borderRadius:  BorderRadius.all(Radius.circular(16.0)),
          borderSide:  BorderSide(
            color: AppColors.primaryColor,
          ),
        ),
        focusedBorder:  OutlineInputBorder(
            borderRadius:  BorderRadius.all(Radius.circular(16.0)),
            borderSide:  BorderSide(
              color: AppColors.primaryColor,
            )),
        border: OutlineInputBorder(
            borderRadius:  BorderRadius.all(Radius.circular(16.0)),
            borderSide: BorderSide(

                color: AppColors.primaryColor, width: 1.0)),
        labelText: 'Comment',
        alignLabelWithHint: true,
        labelStyle: TextStyle(color: AppColors.primaryColor,),
        hintText: 'Enter your comments',
        hintStyle: TextStyle(color: AppColors.greyColor,),
        contentPadding: EdgeInsets.symmetric(vertical: 15,horizontal: 8),),
      maxLines:5,
      style: const TextStyle(color: AppColors.black,),
    );
  }
}
