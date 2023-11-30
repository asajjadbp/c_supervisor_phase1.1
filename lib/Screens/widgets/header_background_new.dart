import 'package:flutter/material.dart';

class HeaderBackgroundNew extends StatefulWidget {
  const HeaderBackgroundNew({Key? key,required this.childWidgets}) : super(key: key);

  final List<Widget> childWidgets;

  @override
  State<HeaderBackgroundNew> createState() => _HeaderBackgroundNewState();
}

class _HeaderBackgroundNewState extends State<HeaderBackgroundNew> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset("assets/backgrounds/header_bg.png"),
        Column(
          children: widget.childWidgets,
        )
      ],
    );
  }
}
