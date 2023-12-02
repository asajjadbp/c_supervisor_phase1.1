import 'package:flutter/material.dart';

import '../../utills/app_colors_new.dart';

class CheckListCommentTextField extends StatelessWidget {
  const CheckListCommentTextField({Key? key,required this.initialValue,required this.onChangeValue}) : super(key: key);
 final String initialValue;
 final Function(String value) onChangeValue;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (String value) {
        onChangeValue(value);
      },
      initialValue: initialValue,
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
