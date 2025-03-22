import 'package:flutter/material.dart';


class TextFieldCard extends StatelessWidget {
  const TextFieldCard({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    required this.obscureText,
    required this.keyboardType,
    required this.validator,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?) validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon),
            errorMaxLines: 2,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
