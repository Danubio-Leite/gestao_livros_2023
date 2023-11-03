import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomAsyncButton extends StatelessWidget {
  final String label;
  final AsyncCallback onpressed;
  const CustomAsyncButton({
    super.key,
    required this.label,
    required this.onpressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
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
