import 'package:flutter/material.dart';

import '../../utills/app_colors_new.dart';

class MyJpCardForDetail extends StatelessWidget {
  const MyJpCardForDetail({Key? key,required this.storeName,required this.visitStatus,required this.tmrName,required this.workingDate,required this.tmrId,required this.onTap,}) : super(key: key);

 final String storeName;
  final String visitStatus;
  final String tmrName;
  final String tmrId;
  final String workingDate;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shadowColor: Colors.black12,
      elevation: 10,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(child: Text(storeName,overflow: TextOverflow.ellipsis,style: const TextStyle(color: AppColors.primaryColor),)),
                const SizedBox(width: 5,),
                const Text("|",style: TextStyle(color: AppColors.greyColor),),
                const SizedBox(width: 5,),
                visitStatus == "0" ? const Row(
                  children: [
                    Icon(Icons.cancel,color: AppColors.redColor,size: 20,),
                    SizedBox(width: 5,),
                    Text("Pending",style: TextStyle(color: AppColors.redColor),)
                  ],
                ) : visitStatus == "2" ? const Row(
                  children: [
                    Icon(Icons.check_circle,color: AppColors.green,size: 20,),
                    SizedBox(width: 5,),
                    Text("Finished",style: TextStyle(color: AppColors.green),)
                  ],
                ) : const Row(
                  children: [
                    Icon(Icons.pending,color: AppColors.primaryColor,size: 20,),
                    SizedBox(width: 5,),
                    Text("In Progress",style: TextStyle(color: AppColors.primaryColor),)
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Text("TMR Name: $tmrName",overflow: TextOverflow.ellipsis,style: const TextStyle(color: AppColors.blue),),
            const SizedBox(
              height: 5,
            ),
            Text("TMR ID: $tmrId",overflow: TextOverflow.ellipsis,style: const TextStyle(color: AppColors.blue),),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  const  Icon(Icons.calendar_month,color: AppColors.primaryColor,size: 20,),
                  const SizedBox(width: 5,),
                  Text(workingDate)
                ],),
                Visibility(
                  visible: visitStatus != "2",
                  child: ElevatedButton(
                    onPressed: (){
                      onTap();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: AppColors.primaryColor,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    child: const Text("Start visit"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
