import 'package:flutter/material.dart';

import '../../core/theme.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key, this.message});
  final String? message;

  @override
  Widget build(BuildContext context) => Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const CircularProgressIndicator(),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(message!, style: const TextStyle(color: AppTheme.muted)),
          ],
        ]),
      );
}

class MessageView extends StatelessWidget {
  const MessageView({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.onRetry,
  });

  final IconData icon;
  final String title;
  final String? message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: const BoxDecoration(
                color: Color(0xFFEEF0FF), shape: BoxShape.circle),
            child: Icon(icon, size: 38, color: AppTheme.primary),
          ),
          const SizedBox(height: 18),
          Text(title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.ink)),
          if (message != null) ...[
            const SizedBox(height: 8),
            Text(message!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppTheme.muted)),
          ],
          if (onRetry != null) ...[
            const SizedBox(height: 22),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                  minimumSize: const Size(140, 46)),
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
            ),
          ],
        ]),
      ),
    );
  }
}
