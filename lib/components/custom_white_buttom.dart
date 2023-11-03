import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomWhiteButton extends StatelessWidget {
  final String label;
  final VoidCallback onpressed;

  const CustomWhiteButton({
    super.key,
    required this.label,
    required this.onpressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        side: const BorderSide(
          width: 1,
          color: Colors.black,
        ),
      ),
      onPressed: onpressed,
      child: Text(
        label,
        style: const TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }
}
