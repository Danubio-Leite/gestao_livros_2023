import 'dart:ffi';

import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    this.color,
    this.backgroundColor,
    this.elevation,
    this.side = BorderSide.none,
    this.onTap,
    super.key,
    required this.label,
  });

  final Color? color;
  final String label;
  final Color? backgroundColor;
  final double? elevation;
  final BorderSide side;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          backgroundColor: color,
          side: const BorderSide(
            width: 1,
            color: Colors.black,
          ),
        ),
        onPressed: onTap,
        child: Text(
          label,
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}
