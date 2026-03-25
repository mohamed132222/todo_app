import 'package:flutter/material.dart';

import '../my_theme.dart';

class CustomTextFormField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final Icon prefixIcon;

  const CustomTextFormField({
    super.key,
    required this.hintText,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.validator,
    required this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: validator,

        decoration: _buildDecoration(context),
      ),
    );
  }

  // 🔹 فصلنا الـ UI logic
  InputDecoration _buildDecoration(BuildContext context) {
    final border = _buildBorder();

    return InputDecoration(
      hintText: hintText,
      hintStyle: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(color: MyTheme.greyColor),

      contentPadding: const EdgeInsets.all(2),
      prefixIcon: prefixIcon,
      border: border,
      enabledBorder: border,
      disabledBorder: border,
      errorBorder: border,
      focusedBorder: border.copyWith(borderSide: const BorderSide(width: 3)),
    );
  }

  // 🔹 reusable border (performance + clean)
  OutlineInputBorder _buildBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(color: MyTheme.primaryColor, width: 3),
    );
  }
}
