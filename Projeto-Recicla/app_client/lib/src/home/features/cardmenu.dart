import 'package:flutter/material.dart';

Widget cardmenu({
  required String title,
  required String icon,
  VoidCallback? ontap,
  Color color = Colors.white,
  Color fontcolor = Colors.grey,
}) {
  return GestureDetector(
      onTap: ontap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 36),
        width: 156,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: color,
        ),
        child: Column(children: [
          Image.asset(icon),
          const SizedBox(
            height: 1,
          ),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, color: fontcolor),
          ),
        ]),
      ));
}
