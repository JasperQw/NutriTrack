import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:nutritrack/utils/colors.dart';

class LineChartDrawing extends StatefulWidget {
  final List<Map<String, double>> points;
  const LineChartDrawing({super.key, required this.points});

  @override
  State<LineChartDrawing> createState() => _LineChartDrawingState();
}

class _LineChartDrawingState extends State<LineChartDrawing> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots:
                  widget.points.map((e) => FlSpot(e['x']!, e['y']!)).toList(),
              isCurved: false,
            ),
          ],
          lineTouchData: LineTouchData(
              enabled: true,
              touchCallback:
                  (FlTouchEvent event, LineTouchResponse? touchResponse) {},
              touchTooltipData: LineTouchTooltipData(
                tooltipBgColor: Colors.blue,
                tooltipRoundedRadius: 20.0,
                showOnTopOfTheChartBoxArea: true,
                fitInsideHorizontally: true,
                tooltipMargin: 0,
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map(
                    (LineBarSpot touchedSpot) {
                      const textStyle = TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      );
                      return LineTooltipItem(
                          "Day 1, ${widget.points[touchedSpot.spotIndex]['y']!.toStringAsFixed(2)}",
                          textStyle,
                          textAlign: TextAlign.start);
                    },
                  ).toList();
                },
              ),
              getTouchedSpotIndicator:
                  (LineChartBarData barData, List<int> indicators) {
                return indicators.map(
                  (int index) {
                    const line = FlLine(
                        color: Colors.grey, strokeWidth: 1, dashArray: [2, 4]);

                    return const TouchedSpotIndicatorData(
                      line,
                      FlDotData(show: false),
                    );
                  },
                ).toList();
              },
              getTouchLineEnd: (_, __) => double.infinity),
          borderData: FlBorderData(
            border: const Border(
              bottom: BorderSide(),
              left: BorderSide(),
            ),
          ),
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
        ),
      ),
    );
  }
}
