import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  final List<String> notifications;

  NotificationsPage({required this.notifications});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notificações'),
      ),
      body: notifications.isEmpty
          ? Center(child: Text('Nenhuma notificação.'))
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(notifications[index]),
                );
              },
            ),
    );
  }
}