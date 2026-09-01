import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;

  const CustomAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
    this.leading,
    this.centerTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading,
      centerTitle: centerTitle,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          if (subtitle != null && subtitle!.isNotEmpty)
            Text(
              subtitle!,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                fontWeight: FontWeight.normal,
              ),
            ),
        ],
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
