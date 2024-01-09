import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nutritrack/utils/colors.dart';
import 'package:nutritrack/widgets/essential_progress_bar.dart';

class EssentialBottomSheet extends StatefulWidget {
  final String label;
  final double curVal;
  final double targetVal;
  final String unit;
  const EssentialBottomSheet(
      {super.key,
      required this.unit,
      required this.label,
      required this.curVal,
      required this.targetVal});

  @override
  State<EssentialBottomSheet> createState() => _EssentialBottomSheetState();
}

class _EssentialBottomSheetState extends State<EssentialBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(15),
            width: 120,
            child: Container(
              width: 120,
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: gray,
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SvgPicture.asset(
                  "assets/${widget.label}.svg",
                  height: 150,
                ),
                EssentialProgressBar(
                    label: widget.label,
                    currentVal: widget.curVal,
                    targetVal: widget.targetVal,
                    unit: widget.unit)
              ],
            ),
          )
        ],
      ),
    );
  }
}
