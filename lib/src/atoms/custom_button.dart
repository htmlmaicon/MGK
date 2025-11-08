import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final EdgeInsets padding;
  final BorderRadius borderRadius;
  final double fontSize;
  final Widget? icon;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.backgroundColor = Colors.green,
    this.textColor = Colors.white,
    this.padding = const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
    this.borderRadius = const BorderRadius.all(Radius.circular(15)),
    this.fontSize = 18,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: "Botão $text",
      child: InkWell(
        onTap: onPressed,
        borderRadius: borderRadius,
        splashColor: Colors.green[100]?.withOpacity(0.5),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: borderRadius,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) icon!,
              if (icon != null) const SizedBox(width: 8),
              Text(
                text,
                style: TextStyle(color: textColor, fontSize: fontSize),
              ),
            ],
          ),
        ),
      ),
    );
  }
}