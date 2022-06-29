import 'package:babysittercalculator/pages/home_page.dart';
import 'package:babysittercalculator/services/background_service.dart';
import 'package:babysittercalculator/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await BackgroundService.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: NotificationService.snackBarMessageKey,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Оплата Няні'),
    );
  }
}

void callbackDispatcher() {
  // BackgroundService.instance().then((inst) => inst.processBackgroundTask());
  Workmanager().executeTask((task, inputData) async {
    if(inputData == null) return Future.value(false);

    final title = inputData["title"] ?? "Unknown title";
    final message = inputData["message"] ?? "Unknown message";

    await NotificationService().notification(-1, title, message+" " + DateTime.now().toIso8601String());

    return Future.value(true);
  });
}
