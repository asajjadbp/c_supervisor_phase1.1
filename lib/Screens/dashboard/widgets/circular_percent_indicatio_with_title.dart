
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../utills/app_colors_new.dart';

class CircularPercentIndicatorWidget extends StatelessWidget {
  const CircularPercentIndicatorWidget({super.key, required this.title,required this.imageStringIcon,required this.percentColor,required this.percentText,});
  
  final String title;
  final String imageStringIcon;
  final Color percentColor;
  final double percentText;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              margin: const EdgeInsets.only(left: 5,top: 5),
              child: Row(
                mainAxisAlignment: imageStringIcon!="" ? MainAxisAlignment.spaceAround : MainAxisAlignment.start,
                children: [
                  Text(title,style:const TextStyle(fontSize: 10,fontWeight: FontWeight.w500,color: AppColors.black),),
                  if(imageStringIcon!="")
                  Image.asset(imageStringIcon),
                ],
              )),
          const SizedBox(height: 10,),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.all(5),
            child: CircularPercentIndicator(
              radius: MediaQuery.of(context).size.width/12,
              lineWidth: 8.0,
              animation: true,
              backgroundColor: AppColors.graphInActiveColor,
              animationDuration: 2500,
              percent:percentText,
              center: Text("${(percentText*100).toStringAsFixed(0)}%",style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: AppColors.graphPurple),),
              circularStrokeCap: CircularStrokeCap.round,
              progressColor: percentColor,
            ),
          ),
          const SizedBox(height: 10,),
        ],
      ),
    );
  }
}

class CircularProdectivityIndicatorWidget extends StatelessWidget {
  const CircularProdectivityIndicatorWidget({super.key, required this.title,required this.imageStringIcon,required this.percentColor,required this.percentText, required this.centerText,});

  final String title;
  final String imageStringIcon;
  final Color percentColor;
  final double percentText;
  final int centerText;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              margin: const EdgeInsets.only(left: 5,top: 5),
              child: Row(
                mainAxisAlignment: imageStringIcon!="" ? MainAxisAlignment.spaceAround : MainAxisAlignment.start,
                children: [
                  Text(title,style:const TextStyle(fontSize: 10,fontWeight: FontWeight.w500,color: AppColors.black),),
                  if(imageStringIcon!="")
                    Image.asset(imageStringIcon),
                ],
              )),
          const SizedBox(height: 10,),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.all(5),
            child: CircularPercentIndicator(
              radius: MediaQuery.of(context).size.width/12,
              lineWidth: 8.0,
              animation: true,
              backgroundColor: AppColors.graphInActiveColor,
              animationDuration: 2500,
              percent:percentText,
              center: Text("${(centerText).toStringAsFixed(0)}%",style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: AppColors.graphPurple),),
              circularStrokeCap: CircularStrokeCap.round,
              progressColor: percentColor,
            ),
          ),
          const SizedBox(height: 10,),
        ],
      ),
    );
  }
}
