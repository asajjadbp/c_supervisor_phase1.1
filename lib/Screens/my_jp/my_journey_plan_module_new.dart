import 'package:c_supervisor/Screens/my_jp/widgets/my_journey_plan_module_card_item.dart';
import 'package:flutter/material.dart';

import '../widgets/header_background_new.dart';
import '../widgets/header_widgets_new.dart';
import '../widgets/large_button_in_footer.dart';
import 'my_journey_plan_check_list.dart';

class MyJourneyModuleNew extends StatefulWidget {
  const MyJourneyModuleNew({Key? key}) : super(key: key);

  @override
  State<MyJourneyModuleNew> createState() => _MyJourneyModuleNewState();
}

class _MyJourneyModuleNewState extends State<MyJourneyModuleNew> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HeaderBackgroundNew(
        childWidgets: [
          const HeaderWidgetsNew(pageTitle: "Journey Plan Module",isBackButton: true,isDrawerButton: true,),
          Expanded(
            child: GridView(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: (163.5 / 135),
                crossAxisCount: 2,
              ),
              children:  [
                // MyJourneyPlanModuleCardItem(
                //   onTap: () {},
                //   cardName: 'Photos',
                //   cardImage: 'assets/icons/images.png',
                // ),

                MyJourneyPlanModuleCardItem(
                  onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const MyJourneyPlanCheckList()));
                  },
                  cardName: "Check List",
                  cardImage:  "assets/icons/check_list.png",
                ),

              ],
            ),
          ),
          LargeButtonInFooter(buttonTitle: "Finish Visit", onTap: (){},),
        ],
      ),
    );
  }
}
