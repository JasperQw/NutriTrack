import 'package:flutter/material.dart';
import 'package:nutritrack/utils/colors.dart';

class GoalTextFieldWidget extends StatefulWidget {
  final TextEditingController textEditingController;
  final String hintText;
  final String unit;
  final bool? margin;
  const GoalTextFieldWidget(
      {super.key,
      required this.textEditingController,
      required this.hintText,
      required this.unit,
      this.margin});

  @override
  State<GoalTextFieldWidget> createState() => _GoalTextFieldWidgetState();
}

class _GoalTextFieldWidgetState extends State<GoalTextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin != null
          ? const EdgeInsets.only(top: 0)
          : const EdgeInsets.only(top: 32),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ]),
      child: TextField(
        controller: widget.textEditingController,
        keyboardType: TextInputType.number,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        onTapOutside: (event) {
          FocusScope.of(context).unfocus();
        },
        cursorColor: white,
        decoration: InputDecoration(
          errorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
            borderSide: BorderSide.none,
          ),
          suffix: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Text(
              widget.unit,
            ),
          ),
          suffixStyle: const TextStyle(
            fontSize: 16,
            color: white,
            fontWeight: FontWeight.w600,
          ),
          filled: true,
          fillColor: black,
          labelStyle: const TextStyle(color: Colors.white70),
          contentPadding: const EdgeInsets.only(
            left: 20,
            top: 20,
            bottom: 20,
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(40),
            ),
            borderSide: BorderSide.none,
          ),
          label: Text(
            widget.hintText,
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ),
    );
  }
}
