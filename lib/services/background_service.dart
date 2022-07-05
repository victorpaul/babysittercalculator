import 'package:babysittercalculator/extensions/int_extensions.dart';
import 'package:babysittercalculator/main.dart';
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

  Future<String> runDailyTask(DateTime start, String name, Map<String, dynamic> inputData) async {
    final delayToStartInMinutes = calculateDelayToStartInMinutes(DateTime.now(), start);

    await Workmanager().cancelByUniqueName(name);
    await Workmanager().registerPeriodicTask(name, name, frequency: const Duration(minutes: 30), initialDelay: delayToStartInMinutes.minutesToDuration(), inputData: inputData);
    return Future.value("$name runs in ${delayToStartInMinutes.toString()}");
  }
}
