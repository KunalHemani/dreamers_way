import 'package:flutter/material.dart';

class AppButtons extends StatelessWidget {
  final Color color;
  final Color backgroundColor;
  double size;
  final Color borderColor;
  String? text;

  AppButtons({super.key,
    required this.color,
    required this.backgroundColor,
    required this.size,
    required this.borderColor,
    this.text});

  int selectedIndex = -1;
  int? index ;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
          border: Border.all(
            color: borderColor,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(15),
          color: backgroundColor
      ),
      child: Center(child: Text(text!, style: TextStyle(color: Colors.black, fontSize: 22),)),
    );
  }
}
