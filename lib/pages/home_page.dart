import 'dart:math';

import 'package:babysittercalculator/constants.dart';
import 'package:babysittercalculator/extensions/widget_put_right.dart';
import 'package:babysittercalculator/services/background_service.dart';
import 'package:babysittercalculator/services/notification_service.dart';
import 'package:babysittercalculator/utils/calculations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  int priceOneKidHour = 0;
  int priceTwoKidsHour = 0;
  int hoursTotal = 0;
  int hoursWithTwoKids = 0;
  int minutesTotal = 0;
  int minutesWithTwoKids = 0;
  int bonusUah = 0;
  String results = "";

  bool dataReady = false;

  @override
  void initState() {
    super.initState();

    _prefs.then((prefs) {
      priceOneKidHour = prefs.getInt("priceOneKidHour") ?? 70;
      priceTwoKidsHour = prefs.getInt("priceTwoKidsHour") ?? 90;
      bonusUah = prefs.getInt("bonusUah") ?? 0;
      setState(() => dataReady = true);
      calculateBabySitterPayment();
    });
  }

  void _onPriceForOneChanged(String value) {
    priceOneKidHour = value.isEmpty ? 0 : int.parse(value);
    calculateBabySitterPayment();

    _prefs.then((prefs) {
      prefs.setInt("priceOneKidHour", priceOneKidHour);
    });
  }

  void _onPriceForTwoChanged(String value) {
    priceTwoKidsHour = value.isEmpty ? 0 : int.parse(value);
    calculateBabySitterPayment();

    _prefs.then((prefs) => prefs.setInt("priceTwoKidsHour", priceTwoKidsHour));
  }

  void _onHoursTotalChanged(String value) {
    hoursTotal = value.isEmpty ? 0 : int.parse(value);
    calculateBabySitterPayment();
  }

  void _onMinutesTotalChanged(String value) {
    minutesTotal = value.isEmpty ? 0 : int.parse(value);
    calculateBabySitterPayment();
  }

  void _onHoursWithTwoKidsChanged(String value) {
    hoursWithTwoKids = value.isEmpty ? 0 : int.parse(value);
    calculateBabySitterPayment();
  }

  void _onMinutesWithTwoKidsChanged(String value) {
    minutesWithTwoKids = value.isEmpty ? 0 : int.parse(value);
    calculateBabySitterPayment();
  }

  void _onBonus(String value) {
    bonusUah = value.isEmpty ? 0 : int.parse(value);
    calculateBabySitterPayment();

    _prefs.then((prefs) => prefs.setInt("bonusUah", bonusUah));
  }

  void calculateBabySitterPayment() {
    setState(() => results = calculateBabysitterPayment(
          priceOneKidHour: priceOneKidHour,
          priceTwoKidsHour: priceTwoKidsHour,
          hoursTotal: hoursTotal,
          hoursWithTwoKids: hoursWithTwoKids,
          minutesTotal: minutesTotal,
          minutesWithTwoKids: minutesWithTwoKids,
          bonusUah: bonusUah,
        ));
  }

  void onPressedBar() {
    final randIndex = Random().nextInt(positivePhrases.length - 1);
    final randomPhrase = positivePhrases[randIndex];

    BackgroundService.instance().then((inst) async {
      final r = [
        await inst.runDailyTask(DateTime(0, 0, 0, 9, 59), "com.task.daily.0", {"type": "notification", "title": "n1", "message": randomPhrase}),
        await inst.runDailyTask(DateTime(0, 0, 0, 8, 1), "com.task.daily.1", {"type": "notification", "title": "n2", "message": randomPhrase}),
        await inst.runDailyTask(DateTime(0, 0, 0, 7, 1), "com.task.daily.2", {"type": "notification", "title": "n3", "message": randomPhrase}),
      ];

      NotificationService.showSnackBar(r.toString());
      NotificationService.instance().then((value) => value.notification(-1, "local", "$randomPhrase, $r"));
    });
  }

  @override
  Widget build(BuildContext context) {
    final content = dataReady ? drawBody() : const Center(child: Text("Loading"));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
              icon: const Icon(
                Icons.beach_access,
                color: Colors.deepPurpleAccent,
              ),
              onPressed: onPressedBar),
          IconButton(
              icon: const Icon(
                Icons.audiotrack,
                color: Colors.green,
              ),
              onPressed: onPressedBar),
          IconButton(
              icon: const Icon(
                Icons.favorite,
                color: Colors.pink,
              ),
              onPressed: onPressedBar),
          IconButton(
              icon: const Icon(
                Icons.child_friendly_outlined,
                color: Colors.amber,
              ),
              onPressed: onPressedBar),
        ],
      ),
      body: content,
    );
  }

  Widget drawDigitField({int? initialValue, required IconData icon, required String labelText, required ValueChanged<String> onChanged}) {
    final field = TextFormField(
      initialValue: initialValue?.toString(),
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: labelText,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.amber, width: 1.0),
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      textInputAction: TextInputAction.next,
      onChanged: onChanged,
    );

    return Padding(padding: const EdgeInsets.all(5), child: field);
  }

  Widget drawBody() {
    final body = Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
            child: Center(
          child: Text(
            results,
            style: const TextStyle(fontSize: 18),
          ),
        )),
        drawDigitField(
          icon: Icons.attach_money,
          initialValue: priceOneKidHour,
          labelText: "Вартість години з одним",
          onChanged: _onPriceForOneChanged,
        ).wrapRow([
          drawDigitField(
            icon: Icons.attach_money,
            initialValue: priceTwoKidsHour,
            labelText: "Вартість години з двома",
            onChanged: _onPriceForTwoChanged,
          )
        ]),
        drawDigitField(
          icon: Icons.access_time_filled_outlined,
          labelText: "Годин всього",
          onChanged: _onHoursTotalChanged,
        ).wrapRow([
          drawDigitField(
            icon: Icons.access_time_filled_outlined,
            labelText: "Хвилин всього",
            onChanged: _onMinutesTotalChanged,
          )
        ]),
        drawDigitField(
          icon: Icons.access_time_filled_outlined,
          labelText: "З них годин з двома",
          onChanged: _onHoursWithTwoKidsChanged,
        ).wrapRow([
          drawDigitField(
            icon: Icons.access_time_filled_outlined,
            labelText: "Хвилин з двома",
            onChanged: _onMinutesWithTwoKidsChanged,
          )
        ]),
        drawDigitField(
          icon: Icons.attach_money,
          initialValue: bonusUah,
          labelText: "Бонус",
          onChanged: _onBonus,
        )
      ],
    );
    return Padding(padding: const EdgeInsets.fromLTRB(10, 10, 10, 40), child: body);
  }
}
