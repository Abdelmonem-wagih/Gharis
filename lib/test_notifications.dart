import 'package:flutter/material.dart';
import 'notification_service.dart';

class NotificationTestPage extends StatelessWidget {
  const NotificationTestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Notifications'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                await initializeNotifications();
                await requestNotificationsPermission();
                await requestIOSPermissions();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Permissions requested!')),
                );
              },
              child: const Text('Request Permissions'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await showRandomNotification();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Test notification sent!')),
                );
              },
              child: const Text('Test Random Notification'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await showNotification(5, 'أشجار');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Achievement notification sent!')),
                );
              },
              child: const Text('Test Achievement Notification'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await scheduleDailyNotificationTask();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Daily notifications scheduled!')),
                );
              },
              child: const Text('Schedule Daily Notifications'),
            ),
          ],
        ),
      ),
    );
  }
}
