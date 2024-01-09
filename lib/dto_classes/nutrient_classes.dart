import 'package:flutter/material.dart';
import 'package:nutritrack/utils/colors.dart';

class Nutrient {
  String label;
  double curVal;
  double targetVal;
  String unit;

  Nutrient(this.label, this.curVal, this.targetVal, this.unit);

  String getLabel() {
    return label;
  }

  double getCurVal() {
    return curVal;
  }

  double getTargetVal() {
    return targetVal;
  }

  String getUnit() {
    return unit;
  }

  void setLabel(String label) {
    this.label = label;
  }

  void setCurVal(double curVal) {
    this.curVal = curVal;
  }

  void setTargetVal(double targetVal) {
    this.targetVal = targetVal;
  }

  void setUnit(String unit) {
    this.unit = unit;
  }

  Color getColor() {
    return getTargetVal() < getCurVal() ? red : yellowishGreen;
  }
}
