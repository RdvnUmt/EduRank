import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class TimeSelector extends StatelessWidget {
  const TimeSelector(
      {super.key,
      required this.label,
      required this.value,
      required this.onChanged,
      required this.minValue,
      required this.maxValue});
  final String label;
  final int value;
  final Function(int) onChanged;
  final int minValue;
  final int maxValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
          ),
          const SizedBox(height: 8),
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: NumberPicker(
              value: value,
              minValue: minValue,
              maxValue: maxValue,
              step: 1,
              itemHeight: 40,
              axis: Axis.vertical,
              onChanged: onChanged,
              textStyle: const TextStyle(fontSize: 16),
              selectedTextStyle: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 0, 0, 0),
              ),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey.shade400),
                  bottom: BorderSide(color: Colors.grey.shade400),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
