import 'package:c_supervisor/Network/http_manager.dart';
import 'package:c_supervisor/Screens/my_jp/widgets/check_list_comment_field.dart';
import 'package:c_supervisor/Screens/widgets/toast_message_show.dart';
import 'package:expand_widget/expand_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../Model/response_model/checklist_responses/check_list_response_list_model.dart';
import '../utills/app_colors_new.dart';
import '../widgets/large_button_in_footer.dart';

class MyJourneyPlanCheckList extends StatefulWidget {
  const MyJourneyPlanCheckList({Key? key,required this.checkListResponseModel}) : super(key: key);

  final CheckListResponseModel checkListResponseModel;

  @override
  State<MyJourneyPlanCheckList> createState() => _MyJourneyPlanCheckListState();
}

class _MyJourneyPlanCheckListState extends State<MyJourneyPlanCheckList> {
  TextEditingController commentTextEditingController = TextEditingController();
  bool isLoading = false;
  
  List<TextEditingController> controllerList = <TextEditingController>[];

  @override
  void initState() {
    // TODO: implement initStat
    
    for(int i= 0;i<widget.checkListResponseModel.data!.length;i++) {
      controllerList.add(commentTextEditingController);
    }
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    controllerList.clear();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Journey Plan Check List"),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: AnimationLimiter(
                  child: ListView.separated(
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      separatorBuilder: (context, index) => const SizedBox(height: 10),
                      itemCount: widget.checkListResponseModel.data!.length,
                      shrinkWrap: true,
                      itemBuilder: (context,index) {
                         //controllerList[0].text = "widget.checkListResponseModel.data![index].comment!";
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
                                        widget.checkListResponseModel.data![index].checkList!,
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          const Text("Rate: ",style: TextStyle(color: AppColors.primaryColor,fontSize: 18),),
                                          RatingBar.builder(
                                            updateOnDrag: false,
                                            ignoreGestures: false,
                                            initialRating: widget.checkListResponseModel.data![index].score!.toDouble(),
                                            itemSize: 25,
                                            direction: Axis.horizontal,
                                            //allowHalfRating: false,
                                            itemCount: 5,
                                            itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                                            itemBuilder: (context, _) => const Icon(
                                              Icons.star,
                                              color: AppColors.primaryColor,
                                            ),
                                            onRatingUpdate: (rating) {
                                              setState(() {
                                                widget.checkListResponseModel.data![index].score = rating.toInt();
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: ExpandChild(
                                          indicatorIconSize: 30,
                                          indicatorAlignment: Alignment.bottomRight,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: 130,
                                                margin: const EdgeInsets.symmetric(vertical: 10),
                                                child: CheckListCommentTextField(initialValue: widget.checkListResponseModel.data![index].comment!,onChangeValue: (value){
                                                  setState(() {
                                                    widget.checkListResponseModel.data![index].comment = value;
                                                  });
                                                },),
                                              ),
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
              LargeButtonInFooter(buttonTitle: "Submit All", onTap: (){
                updateCheckList();
              },),
            ],
          ),
          if(isLoading)
          const Center(
            child: CircularProgressIndicator(),
          )
        ],
      )
    );
  }
  updateCheckList() {
    setState(() {
      isLoading = true;
    });

    HTTPManager().updateCheckListWithJson(widget.checkListResponseModel).then((value) {

      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pop();
      showToastMessage(true, "Check List Updated successfully");

    }).catchError((e) {
      setState(() {
        isLoading = false;
      });
      print(e);
      showToastMessage(false, e.toString());
    });

  }

}
