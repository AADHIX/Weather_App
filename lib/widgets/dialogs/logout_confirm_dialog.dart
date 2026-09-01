import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class LogoutConfirmDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const LogoutConfirmDialog({super.key, required this.onConfirm});

  static Future<bool?> show(BuildContext context, {required VoidCallback onConfirm}) {
    return showDialog<bool>(
      context: context,
      builder: (context) => LogoutConfirmDialog(onConfirm: onConfirm),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      title: const Row(
        children: [
          Icon(Icons.logout_rounded, color: AppColors.error),
          SizedBox(width: 12),
          Text(
            'Confirm Logout',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ],
      ),
      content: const Text(
        'Are you sure you want to log out of your WeatherWise account?',
        style: TextStyle(fontSize: 14),
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(true);
            onConfirm();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.error,
            foregroundColor: Colors.white,
            minimumSize: const Size(100, 42),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Logout'),
        ),
      ],
    );
  }
}
