import 'package:flutter/material.dart';

import '../../utills/app_colors_new.dart';

class MinutesTextField extends StatelessWidget {
  const MinutesTextField({Key? key,required this.initialValue,required this.onChangeValue}) : super(key: key);
  final String initialValue;
  final Function(String value) onChangeValue;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (String value) {
        onChangeValue(value);
      },
      initialValue: initialValue,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        enabledBorder:  OutlineInputBorder(
          borderRadius:  BorderRadius.all(Radius.circular(5.0)),
          borderSide:  BorderSide(
            color: AppColors.primaryColor,
          ),
        ),
        focusedBorder:  OutlineInputBorder(
            borderRadius:  BorderRadius.all(Radius.circular(5.0)),
            borderSide:  BorderSide(
              color: AppColors.primaryColor,
            )),
        border: OutlineInputBorder(
            borderRadius:  BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(

                color: AppColors.primaryColor, width: 1.0)),
        labelText: 'Minutes',
        alignLabelWithHint: true,
        labelStyle: TextStyle(color: AppColors.primaryColor,),
        hintText: 'Enter no of minutes',
        hintStyle: TextStyle(color: AppColors.greyColor,),
        contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 8),),
      maxLines:1,
      style: const TextStyle(color: AppColors.black,),
    );
  }
}
class SKUTextField extends StatelessWidget {
  const SKUTextField({Key? key,required this.initialValue,required this.onChangeValue}) : super(key: key);
  final String initialValue;
  final Function(String value) onChangeValue;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (String value) {
        onChangeValue(value);
      },
      initialValue: initialValue,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        enabledBorder:  OutlineInputBorder(
          borderRadius:  BorderRadius.all(Radius.circular(5.0)),
          borderSide:  BorderSide(
            color: AppColors.primaryColor,
          ),
        ),
        focusedBorder:  OutlineInputBorder(
            borderRadius:  BorderRadius.all(Radius.circular(5.0)),
            borderSide:  BorderSide(
              color: AppColors.primaryColor,
            )),
        border: OutlineInputBorder(
            borderRadius:  BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(

                color: AppColors.primaryColor, width: 1.0)),
        labelText: 'SKU',
        alignLabelWithHint: true,
        labelStyle: TextStyle(color: AppColors.primaryColor,),
        hintText: 'Enter no of SKU',
        hintStyle: TextStyle(color: AppColors.greyColor,),
        contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 8),),
      maxLines:1,
      style: const TextStyle(color: AppColors.black,),
    );
  }
}
