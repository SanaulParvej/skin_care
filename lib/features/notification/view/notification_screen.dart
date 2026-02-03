import 'package:flutter/material.dart';
import '../../../common/utils/app_colors.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemBuilder: (context, index) => Card(
          child: ListTile(
            leading: Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: AppColors.mint,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.notifications, color: AppColors.primary),
            ),
            title: const Text('New scan completed'),
            subtitle: const Text('Tap to see ingredient details'),
          ),
        ),
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemCount: 6,
      ),
    );
  }
}
