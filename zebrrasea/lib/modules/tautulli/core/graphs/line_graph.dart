import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:zebrrasea/core.dart';
import 'package:zebrrasea/extensions/duration/timestamp.dart';
import 'package:zebrrasea/modules/tautulli.dart';

class TautulliLineGraphHelper {
  TautulliLineGraphHelper._();

  static FlTitlesData titlesData(TautulliGraphData data) {
    String _getTitle(double value) {
      DateTime? _dt = DateTime.tryParse(data.categories![value.truncate()]!);
      return _dt != null ? DateFormat('dd').format(_dt).toString() : '??';
    }

    return FlTitlesData(
      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize:
              ZebrraUI.FONT_SIZE_GRAPH_LEGEND + ZebrraUI.DEFAULT_MARGIN_SIZE,
          getTitlesWidget: (value, meta) => Padding(
            padding: const EdgeInsets.only(top: ZebrraUI.DEFAULT_MARGIN_SIZE),
            child: Text(
              _getTitle(value),
              style: const TextStyle(
                color: ZebrraColours.grey,
                fontSize: ZebrraUI.FONT_SIZE_GRAPH_LEGEND,
              ),
            ),
          ),
        ),
      ),
    );
  }

  static List<LineChartBarData> lineBarsData(TautulliGraphData data) {
    return List<LineChartBarData>.generate(
      data.series!.length,
      (sIndex) => LineChartBarData(
        isCurved: true,
        isStrokeCapRound: true,
        barWidth: 3.0,
        color: ZebrraColours().byGraphLayer(sIndex),
        spots: List<FlSpot>.generate(
          data.series![sIndex].data!.length,
          (dIndex) => FlSpot(dIndex.toDouble(),
              data.series![sIndex].data![dIndex]!.toDouble()),
        ),
        belowBarData: BarAreaData(
          show: true,
          color: ZebrraColours()
              .byGraphLayer(sIndex)
              .withOpacity(ZebrraUI.OPACITY_SPLASH),
        ),
        dotData: FlDotData(
          show: true,
          getDotPainter: (FlSpot spot, double xPercentage, LineChartBarData bar,
                  int index) =>
              FlDotCirclePainter(
            radius: 2.50,
            strokeColor: bar.color!,
            color: bar.color!,
          ),
        ),
      ),
    );
  }

  static LineTouchData lineTouchData(
    BuildContext context,
    TautulliGraphData data,
  ) {
    return LineTouchData(
      enabled: true,
      touchTooltipData: LineTouchTooltipData(
        getTooltipColor: (_) =>
            ZebrraTheme.isAMOLEDTheme ? Colors.black : ZebrraColours.primary,
        tooltipRoundedRadius: ZebrraUI.BORDER_RADIUS,
        tooltipPadding: const EdgeInsets.all(8.0),
        maxContentWidth: MediaQuery.of(context).size.width / 1.25,
        fitInsideVertically: true,
        fitInsideHorizontally: true,
        getTooltipItems: (List<LineBarSpot> spots) {
          return List<LineTooltipItem>.generate(
            spots.length,
            (index) {
              String? name = data.series![index].name;
              int? value = data.series![index].data![spots[index].spotIndex];
              return LineTooltipItem(
                [
                  '$name: ',
                  context.read<TautulliState>().graphYAxis ==
                          TautulliGraphYAxis.PLAYS
                      ? '${value ?? 0}'
                      : Duration(seconds: value ?? 0).asWordsTimestamp(),
                ].join().trim(),
                const TextStyle(
                  color: ZebrraColours.grey,
                  fontSize: ZebrraUI.FONT_SIZE_SUBHEADER,
                ),
              );
            },
          );
        },
      ),
      getTouchedSpotIndicator: (bar, data) =>
          List<TouchedSpotIndicatorData>.generate(
        data.length,
        (index) => TouchedSpotIndicatorData(
          FlLine(
            strokeWidth: 3.0,
            color: bar.color!.withOpacity(ZebrraUI.OPACITY_DISABLED),
          ),
          FlDotData(
            show: true,
            getDotPainter: (FlSpot spot, double xPercentage,
                    LineChartBarData bar, int index) =>
                FlDotCirclePainter(
              radius: 5.0,
              strokeColor: bar.color!,
              color: bar.color!,
            ),
          ),
        ),
      ),
    );
  }
}
