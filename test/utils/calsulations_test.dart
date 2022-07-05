import 'package:babysittercalculator/utils/calculations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("check method calculateBabysitterPayment", () {
    test('success calculate if everything is zero', () {
      final r = calculateBabysitterPayment(
          priceOneKidHour: 0,
          priceTwoKidsHour: 0,
          hoursTotal: 0,
          minutesTotal: 0,
          hoursWithTwoKids: 0,
          minutesWithTwoKids: 0,
          bonusUah: 0);

      expect(r, """
0.0 грн за одного за 00:00
0.0 грн за двох за 00:00
0.0 грн бонус

Всього:  0.0 грн
""");
    });

    test('success calculate if prices are zeros', () {
      final r = calculateBabysitterPayment(
          priceOneKidHour: 0,
          priceTwoKidsHour: 0,
          hoursTotal: 2,
          minutesTotal: 10,
          hoursWithTwoKids: 1,
          minutesWithTwoKids: 10,
          bonusUah: 5);

      expect(r, """
0.0 грн за одного за 01:00
0.0 грн за двох за 01:10
5.0 грн бонус

Всього:  5.0 грн
""");
    });

    test('success calculate mixed time', () {
      final r = calculateBabysitterPayment(
          priceOneKidHour: 70,
          priceTwoKidsHour: 90,
          hoursTotal: 3,
          minutesTotal: 20,
          hoursWithTwoKids: 1,
          minutesWithTwoKids: 10,
          bonusUah: 18);

      expect(r, """
151.7 грн за одного за 02:10
105.0 грн за двох за 01:10
18.0 грн бонус

Всього:  274.7 грн
""");
    });

    test('success calculate when only minutes presented', () {
      final r = calculateBabysitterPayment(
          priceOneKidHour: 70,
          priceTwoKidsHour: 90,
          hoursTotal: 0,
          minutesTotal: 300,
          hoursWithTwoKids: 0,
          minutesWithTwoKids: 90,
          bonusUah: 0);

      expect(r, """
245.0 грн за одного за 03:30
135.0 грн за двох за 01:30
0.0 грн бонус

Всього:  380.0 грн
""");
    });

    test('failed calculation, total spent time less then time with two', () {
      final r = calculateBabysitterPayment(
          priceOneKidHour: 0,
          priceTwoKidsHour: 0,
          hoursTotal: 1,
          minutesTotal: 10,
          hoursWithTwoKids: 2,
          minutesWithTwoKids: 0,
          bonusUah: 18);

      expect(r, """Помилка!
Загальний час 01:10, це менший ніж час з двома 02:00""");
    });
  });

  group("check method calculateDelayToStartInSeconds",(){
    test("success calculate start delay for 18:00 at 21:30", () {
      final r = calculateDelayToStartInMinutes(
        DateTime(0,0,0,21,30),
        DateTime(0,0,0,18,0)
      );
      expect(60 * 20 + 30, r); // 20:30
    });

    test("success calculate start delay for 18:00 at 17:45", () {
      final r = calculateDelayToStartInMinutes(
          DateTime(0,0,0,17,45),
          DateTime(0,0,0,18,5)
      );

      expect(20, r ); // 00:15
    });



  });
}
