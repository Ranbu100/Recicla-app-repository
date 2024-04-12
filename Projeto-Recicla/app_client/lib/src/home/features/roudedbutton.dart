import 'package:flutter/material.dart';

Widget roundedButton({
  required String title,
  bool isActive = false,
}) {
  return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
      decoration: BoxDecoration(
          color: isActive ? Colors.green : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.green)),
      child: Text(
        title,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.black,
        ),
      ));
}
