import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../setting_screen/setting_screen_new.dart';

class HeaderWidgetsNew extends StatelessWidget {
  const HeaderWidgetsNew(
      {Key? key,
      required this.pageTitle,
      required this.isBackButton,
      required this.isDrawerButton})
      : super(key: key);

  final String pageTitle;
  final bool isBackButton;
  final bool isDrawerButton;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height / 19,
              left: 10,
              right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (isBackButton)
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: SvgPicture.asset(
                        'assets/icons/back_ic.svg',
                      ),
                    ),
                  const SizedBox(
                    width: 5,
                  ),
                  if (isDrawerButton)
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const SettingScreenNew()));
                      },
                      child: SvgPicture.asset(
                        'assets/icons/menu_ic.svg',
                      ),
                    )
                ],
              ),
              // const CircleAvatar(
              //   child: ClipOval(
              //       child: CustomCachedNetworkImage(
              //           width: 40,
              //           height: 40,
              //           imgUrl: "${ApplicationURLs.BASE_URL_FOR_IMAGE}images/SupervisionSLA/MyJourneyplan.png" ??'', placeholderPath: '',),),
              // )
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
          child: Text(
            pageTitle,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                color: Colors.white, fontSize: 26, fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }
}
