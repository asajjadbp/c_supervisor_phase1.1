import 'package:c_supervisor/Model/request_model/knowledge_share_request.dart';
import 'package:c_supervisor/Model/response_model/knowledge_share/knowledge_share_model.dart';
import 'package:c_supervisor/Network/http_manager.dart';
import 'package:c_supervisor/Screens/utills/app_colors_new.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dashboard/widgets/main_dashboard_card_item.dart';
import '../my_jp/my_journey_plan_screen.dart';
import '../utills/user_constants.dart';
import '../widgets/header_background_new.dart';
import '../widgets/header_widgets_new.dart';
import 'knowledge_card.dart';

class KnowledgeShare extends StatefulWidget {
  const KnowledgeShare({super.key});

  @override
  State<KnowledgeShare> createState() => _KnowledgeShareState();
}

class _KnowledgeShareState extends State<KnowledgeShare> {
  bool isLoading = false;
  bool isError = true;
  var errorText = "";
  var userId = "";

  List<KnowledgeList> knowledgeShareLst = <KnowledgeList>[];

  @override
  void initState() {
    // TODO: implement initState
    getUserData();
    super.initState();
  }

  getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      userId = sharedPreferences.getString(UserConstants().userId)!;
    });
    getKnowledgeData(userId);
  }

  Future<void> getKnowledgeData(String elID) async {
    setState(() {
      isLoading = true;
    });
    HTTPManager()
        .getKnowledgeShare(KnowledgeShareRequestModel(elId: elID, chainId: ""))
        .then((value) {
      setState(() {
        isLoading = false;
      });
      knowledgeShareLst = value.data;
    }).catchError((onError) {
      setState(() {
        isError = true;
        errorText = onError.toString();
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: IgnorePointer(
      ignoring: false,
      child: HeaderBackgroundNew(
        childWidgets: [
          const HeaderWidgetsNew(
              pageTitle: "Knowledge Share",
              isBackButton: true,
              isDrawerButton: true),
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  )
                : knowledgeShareLst.isEmpty ? const Center(
              child: Text("Nothing shared yet"),
            ) : GridView.builder(
                    itemCount: knowledgeShareLst.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: (163.5 / 135),
                            crossAxisCount: 2,
                            mainAxisSpacing: 20.0),
                    itemBuilder: (context, i) {
                      if (knowledgeShareLst[i].fileName != null) {
                        return KnowledgeCard(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      const MyJourneyPlanScreenNew()));
                            },
                            description: knowledgeShareLst[i].description,
                            fileName: knowledgeShareLst[i].fileName.toString(),
                            imageUrl:
                                // "assets/dashboard/my_journey_plan.png",
                                knowledgeShareLst[i].type == "IMAGE"
                                    ? "assets/myicons/image_icon.png"
                                    : knowledgeShareLst[i]
                                                .type
                                                ?.toUpperCase() ==
                                            "PDF"
                                        ? "assets/myicons/pdf_icon.png"
                                        : "assets/myicons/video_icon.png",
                            cardName: knowledgeShareLst[i].companyName);
                      }
                      return null;
                      // var fileType = knowledgeShareLst[i].fileName.split(".") ?? "" ;
                    },
                  ),
          ),
        ],
      ),
    ));
  }
}
