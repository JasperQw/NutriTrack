import 'package:flutter/material.dart';
import 'package:nutritrack/utils/colors.dart';
import 'package:nutritrack/widgets/nutrient_detail_bottom_sheet.dart';

class NutrientCard extends StatefulWidget {
  final String imagePath;
  final String foodName;
  final String measure;
  const NutrientCard(
      {super.key,
      required this.imagePath,
      required this.foodName,
      required this.measure});

  @override
  State<NutrientCard> createState() => _NutrientCardState();
}

class _NutrientCardState extends State<NutrientCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            isScrollControlled: true,
            useSafeArea: true,
            context: context,
            builder: (context) {
              return NutrientDetailBottomSheet(
                  context: context,
                  foodName: widget.foodName,
                  imagePath: widget.imagePath,
                  measure: widget.measure);
            });
      },
      child: Container(
        margin: const EdgeInsets.only(
          bottom: 32,
        ),
        height: 100,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: white),
          borderRadius: const BorderRadius.all(
            Radius.circular(
              20,
            ),
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 120,
              height: 100,
              child: Image(
                fit: BoxFit.cover,
                image: NetworkImage(widget.imagePath),
              ),
            ),
            const SizedBox(
              width: 32,
            ),
            Expanded(
              child: Text(
                widget.foodName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Icon(
              Icons.navigate_next_outlined,
              size: 32,
            ),
            const SizedBox(
              width: 12,
            ),
          ],
        ),
      ),
    );
  }
}
