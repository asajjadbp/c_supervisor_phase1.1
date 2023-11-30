import 'package:flutter/material.dart';

class MyJourneyPlanModuleCardItem extends StatelessWidget {
  const MyJourneyPlanModuleCardItem({Key? key,required this.onTap,required this.cardName,required this.cardImage}) : super(key: key);

  final String cardName;
  final String cardImage;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return  InkWell(
      onTap: (){
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              cardImage,
            ),
             Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Text(
                cardName,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
