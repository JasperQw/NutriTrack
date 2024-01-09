import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class GoalPlaceholder extends StatelessWidget {
  const GoalPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          "assets/Goal.svg",
          width: 200,
          height: 200,
        ),
        const SizedBox(
          height: 32,
        ),
        const Text(
          "Set your first goal!",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}
