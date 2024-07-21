
import 'package:flutter/material.dart';

import '../../utills/app_colors_new.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({Key? key,required this.controller,required this.onChangeField,required this.hintText}) : super(key: key);

  final TextEditingController controller;
  final Function(String value) onChangeField;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return  Container(
      margin: const EdgeInsets.all(5),
      decoration:  BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20)
      ),
      child: TextFormField(
        controller: controller,
        decoration:  InputDecoration(
          enabledBorder:  const OutlineInputBorder(
            borderRadius:  BorderRadius.all(Radius.circular(16.0)),
            borderSide:  BorderSide(
              color: AppColors.primaryColor,
            ),
          ),
          prefixIcon: Icon(Icons.search, color: AppColors.primaryColor,),
          focusedBorder:  const OutlineInputBorder(
              borderRadius:  BorderRadius.all(Radius.circular(16.0)),
              borderSide:  BorderSide(
                color: AppColors.primaryColor,
              )),
          border: const OutlineInputBorder(
              borderRadius:  BorderRadius.all(Radius.circular(16.0)),
              borderSide: BorderSide(

                  color: AppColors.primaryColor, width: 1.0)),
          labelStyle: const TextStyle(color: AppColors.primaryColor),
          hintText: hintText,
          hintStyle: const TextStyle(color: AppColors.primaryColor),
          contentPadding: const EdgeInsets.symmetric(vertical: 10,horizontal: 5),),
        onChanged: onChangeField,
        keyboardType: TextInputType.emailAddress,
        style: const TextStyle(color: AppColors.primaryColor),
      ),
    );
  }
}
