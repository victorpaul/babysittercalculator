import 'package:babysittercalculator/main.dart';
import 'package:babysittercalculator/services/notification_service.dart';
import 'package:babysittercalculator/utils/calculations.dart';
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

  Future<void> runDailyTask(DateTime start, String name, Map<String, dynamic> inputData) async {
    final delayToStartInMinutes = calculateDelayToStartInMinutes(DateTime.now(),start);

    await Workmanager().cancelByUniqueName(name);
    return Workmanager().registerPeriodicTask(
        name,
        name,
        frequency: const Duration(days: 1),
        initialDelay: Duration(minutes: delayToStartInMinutes),
        inputData: inputData);
  }
}


