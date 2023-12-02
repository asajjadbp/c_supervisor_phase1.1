import 'package:flutter/material.dart';

import '../utills/app_colors_new.dart';

class ErrorTextAndButton extends StatelessWidget {
  const ErrorTextAndButton({Key? key,required this.errorText,required this.onTap}) : super(key: key);

  final String errorText;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(errorText,style:const TextStyle(color: AppColors.redColor),),
        const SizedBox(height: 20,),
        InkWell(
          onTap: (){
            onTap();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.redColor)
            ),
            child: const Text("Reload",style: TextStyle(color: AppColors.redColor),),
          ),
        )
      ],
    );
  }
}
