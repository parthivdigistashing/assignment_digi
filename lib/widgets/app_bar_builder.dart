import 'package:flutter/material.dart';

/// Task 2: Reusable AppBar Builder Widget
/// Configurable title, actions, and styling
class AppBarBuilder extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final VoidCallback? onBackPressed;
  final Color? backgroundColor;
  final bool showBackButton;

  const AppBarBuilder({
    Key? key,
    required this.title,
    this.actions,
    this.onBackPressed,
    this.backgroundColor,
    this.showBackButton = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      backgroundColor: backgroundColor ?? Colors.blue,
      centerTitle: true,
      leading: showBackButton
        ? IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: onBackPressed ?? () => Navigator.pop(context),
          )
        : null,
      actions: actions,
      elevation: 0,
    );
  }

  /// PreferredSizeWidget requirement - sets AppBar height
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}