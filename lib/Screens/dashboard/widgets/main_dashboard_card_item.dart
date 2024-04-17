// ignore_for_file: must_be_immutable

import 'package:c_supervisor/Screens/utills/app_colors_new.dart';
import 'package:flutter/material.dart';

class MainDashboardItemCard extends StatelessWidget {
    MainDashboardItemCard({Key? key,required this.onTap,required this.imageUrl,required this.cardName,}) : super(key: key);

  final String cardName;
  final String imageUrl;
  Function onTap;

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
        borderOnForeground: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child:  Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 5,),
                Image.asset(imageUrl,fit: BoxFit.contain,),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Text(cardName),
                ),
                const SizedBox(height: 5,),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

