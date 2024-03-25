import 'package:c_supervisor/Model/request_model/business_trips.dart';
import 'package:c_supervisor/Model/request_model/recruit_suggest.dart';
import 'package:c_supervisor/Model/response_model/business_trips_response/business_trips_list_model.dart';
import 'package:c_supervisor/Model/response_model/recruit_suggest_responses/recruit_suggest_list_model.dart';
import 'package:c_supervisor/Screens/widgets/toast_message_show.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Model/request_model/journey_plan_request.dart';
import '../../Network/http_manager.dart';
import '../../provider/license_provider.dart';
import '../utills/app_colors_new.dart';
import '../utills/user_constants.dart';
import '../widgets/error_text_and_button.dart';
import '../widgets/header_background_new.dart';
import '../widgets/header_widgets_new.dart';
import 'add_recruit_suggest_screen.dart';

class RecruitSuggestScreen extends StatefulWidget {
  const RecruitSuggestScreen({Key? key}) : super(key: key);

  @override
  State<RecruitSuggestScreen> createState() => _RecruitSuggestScreenState();
}

class _RecruitSuggestScreenState extends State<RecruitSuggestScreen> {

  String userName = "";
  String userId = "";
  int? geoFence;

  bool isLoading = true;
  bool isLoadingLocation = false;
  bool isError = false;
  String errorText = "";

  List<RecruitSuggest> recruitSuggestList = [];

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      userName = sharedPreferences.getString(UserConstants().userName)!;
      userId = sharedPreferences.getString(UserConstants().userId)!;
      geoFence = sharedPreferences.getInt(UserConstants().userGeoFence)!;
    });

    getRecruitSuggestList(true);

  }

  getRecruitSuggestList(bool loader) {

    setState(() {
      isLoading = loader;
    });

    HTTPManager()
        .getRecruitSuggest(JourneyPlanRequestModel(
      elId: userId,))
        .then((value) {
      setState(() {

        recruitSuggestList = value.data!;
        isLoading = false;
        isError = false;
      });

    }).catchError((e) {
      setState(() {
        isError = true;
        errorText = e.toString();
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton:  Visibility(
          visible: !isLoading,
          child: FloatingActionButton(
            backgroundColor: AppColors.primaryColor,
            onPressed: () {

              Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
               AddRecruitSuggestScreen(recruitSuggest: RecruitSuggest(),isEdit: false,))).then((value) {
                getRecruitSuggestList(false);
              });

            },
            child:const Icon(Icons.add,size: 30,color: AppColors.white,),
          ),
        ),
        body: HeaderBackgroundNew(
          childWidgets: [
            const HeaderWidgetsNew(
              pageTitle: "Suggested Recruits",
              isBackButton: true,
              isDrawerButton: true,
            ),
            Expanded(
                child: Stack(
                  children: [
                    isLoading
                        ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    )
                        : Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: isError
                          ? ErrorTextAndButton(
                          onTap: () {
                            getRecruitSuggestList(true);
                          },
                          errorText: errorText)
                          : recruitSuggestList.isEmpty
                          ? const Center(
                        child: Text("No Recruits found"),
                      )
                          : ListView.builder(
                          padding: const EdgeInsets.only(bottom: 100),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: recruitSuggestList.length,
                          itemBuilder: (context, index) {
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
                                        Expanded(child: Row(
                                          children: [
                                            const Icon(Icons.person_2_outlined,size: 18,color: AppColors.primaryColor,),
                                            const SizedBox(width: 5,),
                                            Text("${recruitSuggestList[index].name}",overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.primaryColor,fontSize: 17),),
                                          ],
                                        )),
                                        InkWell(
                                          onTap: () {
                                            Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                                                AddRecruitSuggestScreen(recruitSuggest: recruitSuggestList[index],isEdit: true,))).then((value) {
                                              getRecruitSuggestList(false);
                                            });
                                          },
                                          child: Container(
                                            padding:
                                            const EdgeInsets
                                                .all(5),
                                            decoration: BoxDecoration(
                                                color: AppColors
                                                    .white,
                                                borderRadius:
                                                BorderRadius
                                                    .circular(
                                                    50)),
                                            child: const Icon(
                                              Icons.edit,
                                              color: AppColors
                                                  .primaryColor,
                                              size: 25,
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            await showDialog<
                                                bool>(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      'Are you sure you want to delete this recruit?'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed:
                                                          () {
                                                        Navigator.pop(
                                                            context,
                                                            false);
                                                      },
                                                      child:
                                                      const Text(
                                                        'No',
                                                        style: TextStyle(
                                                            color:
                                                            AppColors.primaryColor),
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed:
                                                          () {
                                                        deleteRecruitSuggest(
                                                            index,
                                                            recruitSuggestList[
                                                            index]);
                                                      },
                                                      child:
                                                      const Text(
                                                        'Yes',
                                                        style: TextStyle(
                                                            color:
                                                            AppColors.primaryColor),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: Container(
                                            padding:
                                            const EdgeInsets
                                                .all(5),
                                            decoration: BoxDecoration(
                                                color: AppColors
                                                    .white,
                                                borderRadius:
                                                BorderRadius
                                                    .circular(
                                                    50)),
                                            child: const Icon(
                                              Icons.delete,
                                              color: AppColors
                                                  .redColor,
                                              size: 25,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset("assets/myicons/city_icon.png",width: 18,height: 18,),
                                            const SizedBox(width: 5,),
                                            Text(recruitSuggestList[index].cityName!,overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.primaryColor),),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Icon(Icons.phone,size: 18,color: AppColors.primaryColor,),
                                            const SizedBox(width: 5,),
                                            Text(recruitSuggestList[index].phone!,overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.primaryColor),),
                                          ],
                                        ),
                                      ],
                                    ),

                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset("assets/myicons/experience_icon.png",width: 18,height: 18,),
                                            const SizedBox(width: 5,),
                                            Text("${recruitSuggestList[index].yearsOfExp!} years",maxLines: 1,overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.primaryColor),),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Image.asset("assets/myicons/hired_icon.png",width: 18,height: 18,),
                                            const SizedBox(width: 5,),
                                            Text(recruitSuggestList[index].hired! == "N" ? "No" : "Yes",maxLines: 1,overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.primaryColor),),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Image.asset("assets/myicons/reason.png",width: 18,height: 18,),
                                        const SizedBox(width: 5,),
                                        Expanded(child: Text(recruitSuggestList[index].comment!,maxLines: 1,overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.primaryColor),)),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),

                                    Row(
                                      children: [
                                        const Icon(Icons.link,size: 18,color: AppColors.primaryColor,),
                                        const SizedBox(width: 5,),
                                        Expanded(child: InkWell(
                                            onTap: (){
                                              String url = "${LicenseProvider.imageBasePath}uploads/${recruitSuggestList[index].cv}";
                                              print(url);

                                              _launchUrl(url);

                                            },
                                            child: Text(recruitSuggestList[index].cv!,style:const TextStyle(color: AppColors.blue),)))
                                      ],
                                    )

                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                    if (isLoadingLocation)
                      const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
                      )
                  ],
                ))
          ],
        ));
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  deleteRecruitSuggest(int index,RecruitSuggest recruitSuggest) {
    setState(() {
      isLoadingLocation = true;
    });

    HTTPManager().deleteRecruitSuggest(DeleteRecruitSuggestRequestModel(elId: userId,id: recruitSuggestList[index].id.toString())).then((value) {
      recruitSuggestList.removeAt(index);
      setState(() {
        isLoadingLocation = false;
      });
      Navigator.of(context).pop();
      showToastMessage(true, "Recruit deleted Successfully");
    }).catchError((e) {
      showToastMessage(false, e.toString());
      setState(() {
        isLoadingLocation = false;
      });
    });
  }
}
