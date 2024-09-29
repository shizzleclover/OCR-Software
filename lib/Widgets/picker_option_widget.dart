import 'package:flutter/material.dart';

class PickerOptionWidget extends StatelessWidget {
  final Color color;
  final String label;
  final IconData icon;
  final void Function()? onTap;

  const PickerOptionWidget({
    super.key,
    required this.color,
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
   Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: color.withOpacity(0.3),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 38.0,
                color: color,
              ),
              const SizedBox(height: 10.0),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 20.0
                ),
              )
            ],
          ),
        ),
      )
      );
   }
}