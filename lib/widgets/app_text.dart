import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  final double size;
  final String text;
  final Color color;
  final FontWeight fontWeight; // νέο πεδίο

  const AppText({
    super.key,
    required this.text,
    this.size = 16,
    this.color = Colors.white70,
    this.fontWeight = FontWeight.w400, // προεπιλογή
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: fontWeight,
        letterSpacing: 1.1,
        fontFamily: 'Roboto',
      ),
    );
  }
}
