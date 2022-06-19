import 'package:babysittercalculator/main.dart';
import 'package:babysittercalculator/services/notification_service.dart';
import 'package:workmanager/workmanager.dart';

class BackgroundService {

  // todo, pass Workmanager to make it testable
  static Future<BackgroundService> instance() {
    return Future.value(BackgroundService());
  }

  static Future<void> initialize() {
    return Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: true,
    );
  }

  void processBackgroundTask() {
    Workmanager().executeTask((task, inputData) async {
      print("inputData ${inputData.toString()}");
      if(inputData == null) return true;

      final taskType = inputData["type"];

      if (taskType == "notification") {
        final title = inputData["title"] ?? "Unknown title";
        final message = inputData["message"] ?? "Unknown message";

        NotificationService.instance().then((instance) =>
            instance.notification(null, title, message+" " + DateTime.now().toIso8601String()));

      }
      return true;
    });
  }

  Future<void> runDailyNotification(DateTime runTime, String name, Map<String, dynamic> inputData) async {
    //todo, calculate initialDelay to start task at runTime
    await Workmanager().cancelByUniqueName(name);
    return Workmanager().registerPeriodicTask(
        name,
        name,
        frequency: const Duration(hours: 1),
        initialDelay: const Duration(seconds: 5),
        inputData: inputData);
  }
}


