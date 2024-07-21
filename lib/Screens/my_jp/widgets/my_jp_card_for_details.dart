import 'package:flutter/material.dart';

import '../../utills/app_colors_new.dart';

class MyJpCardForDetail extends StatelessWidget {
  const MyJpCardForDetail({Key? key,required this.storeName,required this.isLoadingButton,required this.visitStatus,required this.tmrName,required this.workingDate,required this.tmrId,required this.buttonName,required this.onTap,required this.onMapTap}) : super(key: key);

 final String storeName;
  final String visitStatus;
  final String tmrName;
  final String tmrId;
  final String workingDate;
  final String buttonName;
  final Function onTap;
  final Function onMapTap;
  final bool isLoadingButton;

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
               //  if(visitStatus == "0")
               // const Row(
               //    children: [
               //      Icon(Icons.cancel,color: AppColors.redColor,size: 20,),
               //      SizedBox(width: 5,),
               //      Text("Pending",style: TextStyle(color: AppColors.redColor),)
               //    ],
               //  ),
                if(visitStatus == "2")
                 const Row(
                  children: [
                    Icon(Icons.check_circle,color: AppColors.green,size: 20,),
                    SizedBox(width: 5,),
                    Text("Finished",style: TextStyle(color: AppColors.green),)
                  ],
                ),
                if(visitStatus == "1")
                const Row(
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
            Text("User Name: $tmrName",overflow: TextOverflow.ellipsis,style: const TextStyle(color: AppColors.blue),),
            const SizedBox(
              height: 5,
            ),
            Text("User ID: $tmrId",overflow: TextOverflow.ellipsis,style: const TextStyle(color: AppColors.blue),),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    onMapTap();
                  },
                  child: Row(children: [
                    const  Icon(Icons.calendar_month,color: AppColors.primaryColor,size: 20,),
                    const SizedBox(width: 5,),
                    Text(workingDate,overflow: TextOverflow.ellipsis)
                  ],),
                ),
                Visibility(
                  visible: visitStatus != "2",
                  child: IgnorePointer(
                    ignoring: isLoadingButton,
                    child: InkWell(
                      onTap: (){
                        onTap();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration:  BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: isLoadingButton ? const LinearGradient(
                            colors: [
                              AppColors.greyColor,
                              AppColors.greyColor,
                            ],
                          ) : const LinearGradient(
                            colors: [
                              Color(0xFF0F408D),
                              Color(0xFF6A82A9),
                            ],
                          )
                        ),
                          child: Text(buttonName,style: const TextStyle(color: AppColors.white),),),
                    ),
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
