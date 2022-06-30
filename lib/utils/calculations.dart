import 'package:babysittercalculator/extensions/int_extensions.dart';

String calculateBabysitterPayment(
    {required int priceOneKidHour,
    required int priceTwoKidsHour,
    required int hoursTotal,
    required int hoursWithTwoKids,
    required int minutesTotal,
    required int minutesWithTwoKids,
    required int bonusUah}) {
  final totalTimeInMinutes = hoursTotal * 60 + minutesTotal;
  final totalWithTwoKidsInMinutes = hoursWithTwoKids * 60 + minutesWithTwoKids;
  final totalWithOneKidInMinutes = totalTimeInMinutes - totalWithTwoKidsInMinutes;

  if (totalTimeInMinutes < totalWithTwoKidsInMinutes) {
    return """Помилка!
Загальний час ${totalTimeInMinutes.minutesToFriendlyTime()}, це менший ніж час з двома ${totalWithTwoKidsInMinutes.minutesToFriendlyTime()}""";
  }

  final paymentOneKidMinutes = priceOneKidHour / 60 * totalWithOneKidInMinutes;
  final paymentTwoKidsMinutes = priceTwoKidsHour / 60 * totalWithTwoKidsInMinutes;

  final total = paymentOneKidMinutes + paymentTwoKidsMinutes + bonusUah;

  return """
${paymentOneKidMinutes.toStringAsFixed(1)} грн за одного за ${totalWithOneKidInMinutes.minutesToFriendlyTime()}
${paymentTwoKidsMinutes.toStringAsFixed(1)} грн за двох за ${totalWithTwoKidsInMinutes.minutesToFriendlyTime()}
${bonusUah.toStringAsFixed(1)} грн бонус

Всього:  ${total.toStringAsFixed(1)} грн
""";
}

int calculateDelayToStartInMinutes(DateTime now, DateTime startAt) {
  final nowMinutes = now.hour * 60 + now.minute;
  final startAtMinutes = startAt.hour * 60 + startAt.minute;
  const minutesInDay = 60 * 24;

  if (nowMinutes > startAtMinutes) {
    return minutesInDay - nowMinutes + startAtMinutes;
  }
  return startAtMinutes - nowMinutes;
}
