import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color backgroundColor;
  final Color textColor;
  final bool centerTitle;
  final List<Widget>? actions;
  final IconThemeData? iconTheme;

  const CustomAppBar({
    super.key,
    required this.title,
    this.backgroundColor = Colors.green,
    this.textColor = Colors.white,
    this.centerTitle = true,
    this.actions,
    this.iconTheme,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(color: textColor),
      ),
      backgroundColor: backgroundColor,
      centerTitle: centerTitle,
      actions: actions,
      iconTheme: iconTheme ?? const IconThemeData(color: Colors.white),
    );
  }
}