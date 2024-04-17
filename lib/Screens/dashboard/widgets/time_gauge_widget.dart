import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../utills/app_colors_new.dart';

class TimeGauge extends StatelessWidget {
  const TimeGauge({super.key,required this.timeGauge});

  final int timeGauge;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: MediaQuery.of(context).size.height/9,
        child: SfRadialGauge(
          enableLoadingAnimation: true,
          animationDuration: 2500,
          axes: <RadialAxis>[RadialAxis(
              showTicks: false,
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(widget: Padding(padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
                  child: Container(
                    alignment: Alignment.center,
                    child:  Text(timeGauge > 59 ? "${(timeGauge/60).toStringAsFixed(2)} hr" : "$timeGauge min"),
                  ),), angle: 270, positionFactor: 0.1)
              ],
              showLabels: false,
              pointers: <GaugePointer>[MarkerPointer(value: double.parse(timeGauge.toString()),color: AppColors.primaryColor,)]
          )],
        ),
      ),
    );
  }
}
