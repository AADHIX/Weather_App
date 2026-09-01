import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class ApiKeyDialog extends StatefulWidget {
  final String currentApiKey;
  final ValueChanged<String> onSave;

  const ApiKeyDialog({
    super.key,
    required this.currentApiKey,
    required this.onSave,
  });

  static Future<void> show(
    BuildContext context, {
    required String currentApiKey,
    required ValueChanged<String> onSave,
  }) {
    return showDialog(
      context: context,
      builder: (context) => ApiKeyDialog(
        currentApiKey: currentApiKey,
        onSave: onSave,
      ),
    );
  }

  @override
  State<ApiKeyDialog> createState() => _ApiKeyDialogState();
}

class _ApiKeyDialogState extends State<ApiKeyDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentApiKey);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      title: const Row(
        children: [
          Icon(Icons.key_rounded, color: AppColors.primary),
          SizedBox(width: 12),
          Text(
            'API Configuration',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Enter your OpenWeatherMap API Key. Leave empty to use the default configured key.',
            style: TextStyle(fontSize: 13),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: 'API Key',
              hintText: 'e.g. 3a7b9c1d...',
              prefixIcon: const Icon(Icons.vpn_key_outlined),
              suffixIcon: _controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded),
                      onPressed: () {
                        setState(() {
                          _controller.clear();
                        });
                      },
                    )
                  : null,
            ),
          ),
        ],
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onSave(_controller.text.trim());
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            minimumSize: const Size(100, 42),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Save Key'),
        ),
      ],
    );
  }
}
