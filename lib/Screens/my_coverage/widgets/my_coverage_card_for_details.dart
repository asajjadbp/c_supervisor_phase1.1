import 'package:flutter/material.dart';

import '../../utills/app_colors_new.dart';

class MyCoverageCardForDetail extends StatelessWidget {
  const MyCoverageCardForDetail(
      {Key? key,
      required this.storeName,
      required this.isLoadingButton,
      required this.visitStatus,
      required this.workingDate,
      required this.chainName,
      required this.buttonName,
      required this.onTap,
      required this.onMapTap})
      : super(key: key);

  final String storeName;
  final String visitStatus;
  final String chainName;
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
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                    child: Text(
                  storeName,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.primaryColor),
                )),
                const SizedBox(
                  width: 5,
                ),
                const Text(
                  "|",
                  style: TextStyle(color: AppColors.greyColor),
                ),
                const SizedBox(
                  width: 5,
                ),
                if (visitStatus == "2")
                  const Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: AppColors.green,
                        size: 20,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Finished",
                        style: TextStyle(color: AppColors.green),
                      )
                    ],
                  ),
                if (visitStatus == "1")
                  const Row(
                    children: [
                      Icon(
                        Icons.pending,
                        color: AppColors.primaryColor,
                        size: 20,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "In Progress",
                        style: TextStyle(color: AppColors.primaryColor),
                      )
                    ],
                  )
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            // Row(
            //   children: [
            //     Expanded(
            //         child: Text("TMR Name: $tmrName",maxLines:1,overflow: TextOverflow.ellipsis,style: const TextStyle(color: AppColors.blue),)),
            //   ],
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Text(
                  "Chain Name: $chainName",
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.blue),
                )),
                Visibility(
                  visible: visitStatus != "2",
                  child: IgnorePointer(
                    ignoring: isLoadingButton,
                    child: ElevatedButton(
                      onPressed: () {
                        onTap();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isLoadingButton
                            ? AppColors.lightgreytn
                            : AppColors.primaryColor,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                      ),
                      child: Text(buttonName),
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
