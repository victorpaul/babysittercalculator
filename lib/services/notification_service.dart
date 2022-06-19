import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final snackBarMessageKey = GlobalKey<ScaffoldMessengerState>();
  static NotificationService? _instance;

  static Future<NotificationService> instance() async {
    _instance ??= NotificationService();

    return Future.value(_instance);
  }

  static Future<void> initialize() {
    return AwesomeNotifications()
        .initialize(
        null,
        [
          NotificationChannel(
              channelGroupKey: 'basic_channel_group',
              channelKey: 'basic_channel',
              channelName: 'Basic notifications',
              channelDescription: 'Notification channel for basic tests',
              defaultColor: Color(0xFF9D50DD),
              ledColor: Colors.white)
        ],
        // Channel groups are only visual and are not required
        channelGroups: [NotificationChannelGroup(channelGroupkey: 'basic_channel_group', channelGroupName: 'Basic group')],
        debug: true);
  }

  static void showSnackBar(String message) {
    var snackBar = SnackBar(
      content: Text(message),
    );

    snackBarMessageKey.currentState?.clearSnackBars();
    snackBarMessageKey.currentState?.showSnackBar(snackBar);
  }

  Future<bool> notification(int? id, String title, String message) {
    return AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: id ?? -1,
            channelKey: 'basic_channel',
            title: title,
            body: message), // todo, these notifications are capable to be schedulet, but, for education purposes, I'd like to show them using scheduled background tasks
    );
  }
}
