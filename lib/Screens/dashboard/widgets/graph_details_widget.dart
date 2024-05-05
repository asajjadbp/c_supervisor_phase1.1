import 'package:flutter/material.dart';

class GraphDetailsWidget extends StatelessWidget {
  const GraphDetailsWidget({super.key, required this.firstTitle,required this.secondTitle,required this.firstColor,required this.secondColor});

  final String firstTitle;
  final String secondTitle;
  final Color firstColor;
  final Color secondColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(bottom: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                width: 15,
                height: 15,
                margin: const EdgeInsets.only(left: 10,bottom: 5),
                decoration: BoxDecoration(
                    color: firstColor,
                    borderRadius: BorderRadius.circular(100)
                ),
              ),
              const SizedBox(width: 5,),
               Text(firstTitle,style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 10),),
            ],
          ),
          const SizedBox(width: 15,),
          Row(
            children: [
              Container(
                width: 15,
                height: 15,
                margin: const EdgeInsets.only(left: 10,bottom: 5),
                decoration: BoxDecoration(
                    color: secondTitle!="" ? secondColor : null,
                    borderRadius: BorderRadius.circular(100)
                ),
              ),
              const SizedBox(width: 5,),
               Text(secondTitle,style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 10),),
            ],
          )
        ],
      ),
    );
  }
}
