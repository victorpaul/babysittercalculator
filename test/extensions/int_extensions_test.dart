import 'package:babysittercalculator/extensions/int_extensions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('success convert minutes to friendly time',  (){
    expect(0.minutesToFriendlyTime(), "00:00");
    expect(5.minutesToFriendlyTime(), "00:05");
    expect(60.minutesToFriendlyTime(), "01:00");
    expect(90.minutesToFriendlyTime(), "01:30");
  });

  test('success convert minutes to Duration',  (){

    expect((60 * 2 + 15).minutesToDuration().toString(), "2:15:00.000000");
    expect((60 * 24 * 2 + 5).minutesToDuration().inDays, 2);

  });
}
