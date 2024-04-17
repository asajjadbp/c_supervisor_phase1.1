import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../Model/chart_data_Model.dart';
import '../../utills/app_colors_new.dart';

class ColumnGraphWidget extends StatelessWidget {
  const ColumnGraphWidget({super.key, required this.firstColor,required this.firstChartData,required this.secondColor,required this.secondChartData});

  final Color firstColor;
  final Color secondColor;
  final List<ChartData> firstChartData;
  final List<ChartData> secondChartData;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height/7,
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(
          majorGridLines: const MajorGridLines(
            width: 0
          ),
         isVisible: false
        ),
        primaryYAxis: CategoryAxis(
          majorGridLines: const MajorGridLines(width: 0)
        ),
        series: <CartesianSeries<ChartData, String>>[
          ColumnSeries<ChartData, String>(
              dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                labelAlignment: ChartDataLabelAlignment.outer,
                alignment: ChartAlignment.center
              ),
            animationDuration: 2500,
              dataSource: firstChartData,
              color: firstColor,
              borderColor: AppColors.white,
              borderWidth: 2,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y
          ),
          ColumnSeries<ChartData, String>(
              dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  labelAlignment: ChartDataLabelAlignment.outer,
                  alignment: ChartAlignment.center
              ),
              dataSource: secondChartData,
              xValueMapper: (ChartData data, _) => data.x,
              color: secondColor,
              borderColor: AppColors.white,
              borderWidth: 2,
              yValueMapper: (ChartData data, _) => data.y
          ),
        ],
      ),
    );
  }
}
