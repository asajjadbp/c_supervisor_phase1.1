import 'package:c_supervisor/Screens/my_jp/widgets/check_list_comment_field.dart';
import 'package:expand_widget/expand_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../utills/app_colors_new.dart';
import '../widgets/large_button_in_footer.dart';

class MyJourneyPlanCheckList extends StatefulWidget {
  const MyJourneyPlanCheckList({Key? key}) : super(key: key);

  @override
  State<MyJourneyPlanCheckList> createState() => _MyJourneyPlanCheckListState();
}

class _MyJourneyPlanCheckListState extends State<MyJourneyPlanCheckList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Journey Plan Check List"),
      ),
      body: Column(
        children: [
          Expanded(
              child: AnimationLimiter(
                child: ListView.separated(
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                  itemCount: 30,
                shrinkWrap: true,
                itemBuilder: (context,index) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    delay: const Duration(milliseconds: 100),
                    child: SlideAnimation(
                      duration: const Duration(milliseconds: 2500),
                      curve: Curves.fastLinearToSlowEaseIn,
                      horizontalOffset: -300,
                      verticalOffset: -850,
                      child: Card(
                        elevation: 5,

                        child: Padding(
                          padding:const EdgeInsets.all(8),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 5),
                              Text(
                                "Test CheckList$index",
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  const Text("Rate: ",style: TextStyle(color: AppColors.primaryColor,fontSize: 18),),
                                  RatingBar.builder(
                                    updateOnDrag: false,
                                    ignoreGestures: false,
                                    initialRating: 0.0,
                                    itemSize: 25,
                                    direction: Axis.horizontal,
                                    //allowHalfRating: false,
                                    itemCount: 5,
                                    itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                                    itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: AppColors.primaryColor,
                                    ),
                                    onRatingUpdate: (rating) {},
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              const Align(
                                alignment: Alignment.bottomRight,
                                child: ExpandChild(
                                  indicatorIconSize: 30,
                                  indicatorAlignment: Alignment.bottomRight,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CheckListCommentTextField(),
                                      SizedBox(height: 10,),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ),
                  );
                }),
              ),

          ),
          LargeButtonInFooter(buttonTitle: "Submit All", onTap: (){},),
        ],
      ),
    );
  }
}
