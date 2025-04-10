

import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final int currentStep; // Which step is active (1 to 4)
  final int totalSteps;

  const ProgressBar({
    Key? key,
    required this.currentStep,
    this.totalSteps = 4,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        // index goes from 0 to totalSteps-1
        final isActive = (index + 1) <= currentStep;
        return Expanded(
          child: Container(
            height: 4,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: isActive ? Colors.white : Colors.grey.shade800,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }
}
