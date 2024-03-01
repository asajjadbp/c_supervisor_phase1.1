import 'package:c_supervisor/Screens/utills/app_colors_new.dart';
import 'package:flutter/material.dart';

class MyJourneyPlanModuleCardItem extends StatelessWidget {
  const MyJourneyPlanModuleCardItem(
      {Key? key,
      required this.onTap,
      required this.cardName,
      required this.cardImage,
      required this.questionRating,
      required this.pendingCheckListCount})
      : super(key: key);

  final String cardName;
  final String cardImage;
  final int pendingCheckListCount;
  final double questionRating;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shadowColor: Colors.black12,
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      cardImage,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            cardName,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          if (pendingCheckListCount != 0 ||
                              pendingCheckListCount != 0.0)
                            Text(
                              "($pendingCheckListCount)",
                              style: const TextStyle(
                                  fontSize: 18, color: AppColors.primaryColor),
                            )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // if (pendingCheckListCount != 0 || pendingCheckListCount != 0.0)
              //   Positioned(
              //     right: 10,
              //     top: 10,
              //     child: Text(
              //       "($pendingCheckListCount)",
              //       style: const TextStyle(
              //           fontSize: 18, color: AppColors.primaryColor),
              //     ),
              //   ),
              if (questionRating != 0 || questionRating != 0.0)
                Positioned(
                  right: 10,
                  top: 10,
                  child: Row(
                    children: [
                      // const Text(
                      //   "Avg: ",
                      //   style: TextStyle(fontWeight: FontWeight.bold),
                      // ),
                      Text(
                        // "($questionRating)"
                        questionRating.toStringAsFixed(2),

                        style: const TextStyle(
                            fontSize: 18, color: AppColors.primaryColor),
                      ),
                    ],
                  ),
                )
            ],
          )),
    );
  }
}
