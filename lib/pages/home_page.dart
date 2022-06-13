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

  @override
  Widget build(BuildContext context) {
    final content = dataReady ? drawBody() : const Center(child: Text("Loading"));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: content,
    );
  }

  Widget drawDigitField({int? initialValue, required String labelText, required ValueChanged<String> onChanged}) {
    final field = TextFormField(
      initialValue: initialValue?.toString(),
      decoration: InputDecoration(
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
        Row(
          children: [
            Expanded(
                child: drawDigitField(
              initialValue: priceOneKidHour,
              labelText: "Вартість години з одним",
              onChanged: _onPriceForOneChanged,
            )),
            Expanded(
                child: drawDigitField(
              initialValue: priceTwoKidsHour,
              labelText: "Вартість години з двома",
              onChanged: _onPriceForTwoChanged,
            ))
          ],
        ),
        Row(
          children: [
            Expanded(
                child: drawDigitField(
              labelText: "Годин всього",
              onChanged: _onHoursTotalChanged,
            )),
            Expanded(
              child: drawDigitField(
                labelText: "Хвилин всього",
                onChanged: _onMinutesTotalChanged,
              ),
            )
          ],
        ),
        Row(
          children: [
            Expanded(
                child: drawDigitField(
              labelText: "З них годин з двома",
              onChanged: _onHoursWithTwoKidsChanged,
            )),
            Expanded(
              child: drawDigitField(
                labelText: "Хвилин з двома",
                onChanged: _onMinutesWithTwoKidsChanged,
              ),
            )
          ],
        ),
        drawDigitField(
          initialValue: bonusUah,
          labelText: "Бонус",
          onChanged: _onBonus,
        )
      ],
    );
    return Padding(padding: const EdgeInsets.all(10), child: body);
  }
}