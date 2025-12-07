import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final notifications = [
      "New article published: Flutter 3.9",
      "Your subscription expires in 3 days",
      "Reminder: Update your profile info",
    ];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, 

      appBar: AppBar(
        backgroundColor: const Color(0xFFB42652),
        title: const Text(
          "Thông báo",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0.6,
      ),

      body: notifications.isEmpty
          ? Center(
              child: Text(
                "No notifications",
                style: theme.textTheme.bodyMedium,
              ),
            )
          : ListView.separated(
              itemCount: notifications.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: const Color(0xFFB42652).withOpacity(0.2), 
              ),
              itemBuilder: (context, index) {
                final textColor = theme.colorScheme.onSurface;

                return ListTile(
                  leading: const Icon(
                    Icons.notifications,
                    color: Color(0xFFB42652),
                  ),
                  title: Text(
                    notifications[index],
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: textColor,
                    ),
                  ),
                  onTap: () {},
                  tileColor: theme.cardColor,
                );
              },
            ),
    );
  }
}
