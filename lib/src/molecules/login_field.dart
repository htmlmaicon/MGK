import 'package:flutter/material.dart';
import '../atoms/custom_input.dart';

class LoginField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool isPassword;

  const LoginField({
    super.key,
    required this.controller,
    required this.label,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomInput(
      controller: controller,
      label: label,
      obscureText: isPassword,
      keyboardType: isPassword ? TextInputType.text : TextInputType.number,
    );
  }
}
