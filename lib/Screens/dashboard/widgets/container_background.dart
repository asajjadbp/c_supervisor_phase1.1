import 'package:flutter/cupertino.dart';

import '../../utills/app_colors_new.dart';

class ContainerBackground extends StatelessWidget {
  const ContainerBackground({super.key,required this.childWidget});

  final Widget childWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding:const EdgeInsets.all(5),
      decoration: const BoxDecoration(
          color: AppColors.whiteBackground,
          borderRadius: BorderRadius.all(Radius.circular(5))
      ),
      child: childWidget,
    );
  }
}
