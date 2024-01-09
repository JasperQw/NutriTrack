import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nutritrack/utils/colors.dart';

class DateTimePickerWidget extends StatefulWidget {
  final TextEditingController dateTextEditingController;
  final String label;
  const DateTimePickerWidget(
      {super.key,
      required this.dateTextEditingController,
      required this.label});

  @override
  State<DateTimePickerWidget> createState() => _DateTimePickerWidgetState();
}

class _DateTimePickerWidgetState extends State<DateTimePickerWidget> {
  @override
  Widget build(BuildContext context) {
    DateTime initDate = widget.label == "To"
        ? DateTime.now().add(const Duration(days: 1))
        : DateTime.now();
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          margin: const EdgeInsets.only(
            right: 30,
          ),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(
                100,
              ),
            ),
            color: black,
            boxShadow: [
              BoxShadow(
                color: Colors.black54,
                spreadRadius: 1,
                blurRadius: 10,
              ),
            ],
          ),
          child: Icon(
            widget.label == "From" ? Icons.play_arrow : Icons.pause,
            color: white,
            size: 25,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: initDate,
                    firstDate: initDate,
                    lastDate: DateTime(2100),
                  );

                  if (pickedDate != null) {
                    setState(() {
                      widget.dateTextEditingController.text =
                          DateFormat("dd-MM-yyyy").format(pickedDate);
                    });
                  }
                },
                controller: widget.dateTextEditingController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: widget.label,
                ),
                readOnly: true,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
