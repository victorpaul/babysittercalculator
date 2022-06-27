import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:synchronized/synchronized.dart';

class NotificationService {
  static final snackBarMessageKey = GlobalKey<ScaffoldMessengerState>();
  static bool _isInitialized = false;
  static final Lock _lock = Lock();

  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future<NotificationService> instance() async {
    return _lock.synchronized(() async {
      if (!_isInitialized) {

        final InitializationSettings initializationSettings = InitializationSettings(
          android: AndroidInitializationSettings('mipmap/launcher_icon'),
        );
        await flutterLocalNotificationsPlugin.initialize(initializationSettings);
        _isInitialized = true;
        // _isInitialized = await AwesomeNotifications().initialize(
        //     null,
        //     [
        //       NotificationChannel(
        //           channelGroupKey: 'basic_channel_group',
        //           channelKey: 'basic_channel',
        //           channelName: 'Basic notifications',
        //           channelDescription: 'Notification channel for basic tests',
        //           defaultColor: Color(0xFF9D50DD),
        //           ledColor: Colors.white)
        //     ],
        //     // Channel groups are only visual and are not required
        //     channelGroups: [NotificationChannelGroup(channelGroupkey: 'basic_channel_group', channelGroupName: 'Basic group')],
        //     debug: true);
      }
      if (!_isInitialized) {
        return Future.error("NotificationService can not be initialized");
      }

      return Future.value(NotificationService());
    });
  }

  // todo, move to snackbar service
  static void showSnackBar(String message) {
    var snackBar = SnackBar(
      content: Text(message),
    );

    snackBarMessageKey.currentState?.clearSnackBars();
    snackBarMessageKey.currentState?.showSnackBar(snackBar);
  }

  Future<void> notification(int id, String title, String message) {
    // AwesomeNotifications().createNotification(
    //   content: NotificationContent(
    //       id: id,
    //       channelKey: 'basic_channel',
    //       title: title,
    //       body: message), // todo, these notifications are capable to be schedulet, but, for education purposes, I'd like to show them using scheduled background tasks
    // );

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails('your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    return flutterLocalNotificationsPlugin.show(
        0, 'plain title', null, platformChannelSpecifics,
        payload: 'item x');

  }
}
