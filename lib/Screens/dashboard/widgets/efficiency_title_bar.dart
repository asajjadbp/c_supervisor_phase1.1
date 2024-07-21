import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../utills/app_colors_new.dart';

class FullEfficiencyBar extends StatelessWidget {
  const FullEfficiencyBar({super.key,required this.percentValue});

  final int percentValue;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 10,left: 5,right: 5),
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Efficiency",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400,color: AppColors.black),),
                  Text("$percentValue%",style:const TextStyle(fontSize: 13,fontWeight: FontWeight.w400,color: AppColors.black),),
                ],
              ),
            ),
            LinearPercentIndicator(
              lineHeight: 18.0,
              percent:percentValue > 100 ? 1.0 : percentValue/100,
              animation: true,
              animationDuration: 2500,
              backgroundColor: AppColors.graphInActiveColor,
              progressColor: AppColors.graphPurple,
            ),
          ],
        ),
      ),
    );
  }
}

class HalfScreenEfficiency extends StatelessWidget {
  const HalfScreenEfficiency({super.key,required this.percentValue});

  final int percentValue;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 35.5),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 10,left: 5,right: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Efficiency",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400,color: AppColors.black),),
                  Text("$percentValue%",style:const TextStyle(fontSize: 13,fontWeight: FontWeight.w400,color: AppColors.black),),
                ],
              ),
            ),
            LinearPercentIndicator(
              lineHeight: 8.0,
              percent: percentValue > 100 ? 1.0 : percentValue/100,
              animation: true,
              animationDuration: 1200,
              backgroundColor: AppColors.graphInActiveColor,
              progressColor: AppColors.graphPurple,
            ),
          ],
        ),
      ),
    );
  }
}

