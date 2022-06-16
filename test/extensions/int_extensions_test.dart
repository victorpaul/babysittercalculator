import 'package:babysittercalculator/extensions/int_extensions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('success convert minutes to time',  (){
    expect(0.minutesToFriendlyTime(), "00:00");
    expect(5.minutesToFriendlyTime(), "00:05");
    expect(60.minutesToFriendlyTime(), "01:00");
    expect(90.minutesToFriendlyTime(), "01:30");
  });
}
