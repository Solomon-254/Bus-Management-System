import 'package:bus_management_system/constants/style.dart';
import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double size;
  final Color color;
  final FontWeight weight;
  final FontStyle fontStyle;
  final Function function;

  const CustomText(
      {Key key, this.text, this.size, this.color, this.weight, this.function, this.fontStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontSize: size ?? 16,
          color: color ?? Colors.black,
          letterSpacing: 2,
          fontStyle: fontStyle,
          fontWeight: weight ?? FontWeight.normal),
    );
  }
}
