import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validator;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      textField: true,
      label: "Campo de $labelText",
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
          Future.delayed(const Duration(milliseconds: 100), () {
            FocusScope.of(context).requestFocus(FocusNode());
          });
        },
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.green[800]!, width: 2.0),
            ),
          ),
          keyboardType: keyboardType,
          validator: validator,
        ),
      ),
    );
  }
}