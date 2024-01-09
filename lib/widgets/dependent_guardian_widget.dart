import 'package:flutter/material.dart';
import 'package:nutritrack/screens/dependent_view.dart';
import 'package:nutritrack/utils/colors.dart';

class DependentOrGuardianWidget extends StatefulWidget {
  final String name;
  final String plan;
  final String imagePath;
  final String type;
  final String userUID;
  const DependentOrGuardianWidget(
      {super.key,
      required this.name,
      required this.plan,
      required this.imagePath,
      required this.type,
      required this.userUID});

  @override
  State<DependentOrGuardianWidget> createState() =>
      _DependentOrGuardianWidgetState();
}

class _DependentOrGuardianWidgetState extends State<DependentOrGuardianWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.type == "Dependent") {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              return DependentView(uid: widget.userUID, name: widget.name);
            }),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 32),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        decoration: const BoxDecoration(
            color: black,
            borderRadius: BorderRadius.all(
              Radius.circular(
                10,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.white24,
                spreadRadius: 2,
                blurRadius: 10,
              )
            ]),
        child: Row(
          children: [
            SizedBox(
              child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 30,
                  backgroundImage: NetworkImage(widget.imagePath)),
            ),
            const SizedBox(
              width: 32,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  widget.type == "Dependent"
                      ? Text(
                          "Plan: ${widget.plan}",
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[400]),
                        )
                      : Container()
                ],
              ),
            ),
            widget.type == "Dependent"
                ? const Icon(
                    Icons.navigate_next,
                    size: 36,
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
