import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Model/request_model/journey_plan_request.dart';
import '../../Model/response_model/my_team_responses/add_special_visit/client_list_model_response.dart';
import '../../Network/http_manager.dart';
import '../utills/app_colors_new.dart';
import '../utills/user_constants.dart';
import '../widgets/error_text_and_button.dart';
import '../widgets/header_background_new.dart';
import '../widgets/header_widgets_new.dart';

class ClientScreen extends StatefulWidget {
  const ClientScreen({super.key});

  @override
  State<ClientScreen> createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {

  String userName = "";
  String userId = "";
  int? geoFence;

  bool isLoading = true;
  bool isLoadingLocation = false;
  bool isError = false;
  String errorText = "";

  List<ClientListItem> clientLists = <ClientListItem>[];

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

    getClientsList(true);

  }

  getClientsList(bool loader) {

    setState(() {
      isLoading = loader;
    });

    HTTPManager()
        .clientList(JourneyPlanRequestModel(
      elId: userId,))
        .then((value) {
      setState(() {

        clientLists = value.data!;

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
      body: HeaderBackgroundNew(
        childWidgets: [
          const HeaderWidgetsNew(
            pageTitle: "Clients",
            isBackButton: true,
            isDrawerButton: true,
          ),
          Expanded(child: isLoading
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
                    getClientsList(true);
                  },
                  errorText: errorText)
                  : clientLists.isEmpty
                  ? const Center(
                child: Text("No Business Trips found"),
              )
                  : ListView.builder(
                  itemCount: clientLists.length,
                  itemBuilder: (context,index) {
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Image.asset("assets/myicons/company_icon.png",width: 18,height: 18,),
                                    const Text(" Company:", style: TextStyle(color: AppColors.blue),),
                                    const SizedBox(width: 5,),
                                    Text(clientLists[index].companyName!,overflow: TextOverflow.ellipsis,maxLines: 1, style: const TextStyle(color: AppColors.blue),),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Image.asset("assets/myicons/store_icon.png",width: 18,height: 18,),
                                    const Text(" Stores:", style: TextStyle(color: AppColors.blue),),
                                    const SizedBox(width: 5,),
                                    Text(clientLists[index].uniqueStores!.toString(),overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.blue),),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 5,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Image.asset("assets/myicons/model_icon.png",width: 18,height: 18,),
                                    const Text(" Business Model:", style: TextStyle(color: AppColors.blue),),
                                    const SizedBox(width: 5,),
                                    Text(clientLists[index].businessModel!.toString(),overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.blue),),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Image.asset("assets/myicons/brand_icon.png",width: 18,height: 18,),
                                    const Text(" Brands:", style: TextStyle(color: AppColors.blue),),
                                    const SizedBox(width: 5,),
                                    Text(clientLists[index].brandCount!.toString(),overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.blue),),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 5,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Image.asset("assets/myicons/products_icon.png",width: 18,height: 18,),
                                    const Text(" Products:", style: TextStyle(color: AppColors.blue),),
                                    const SizedBox(width: 5,),
                                    Text(clientLists[index].productCount!.toString(),overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.blue),),
                                  ],
                                ),
                                Row(
                                  children: [
                                   const Icon(Icons.category_outlined,size: 18,color: AppColors.primaryColor,),
                                    const Text(" Categories:", style: TextStyle(color: AppColors.blue),),
                                    const SizedBox(width: 5,),
                                    Text(clientLists[index].categroyCount!.toString(),overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.blue),),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 5,),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //
                            //     Text("Products: ${clientLists[index].uniqueStores!}",overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.blue),),
                            //     Text("Brands: ${clientLists[index].uniqueStores!}",overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.blue),),
                            //   ],
                            // )
                          ],
                        ),
                      ),
                    );
                  })
          )
          )
        ],
      ),
    );
  }
}
