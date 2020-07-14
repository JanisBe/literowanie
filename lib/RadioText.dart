import 'package:flutter/material.dart';

import 'Litery.dart';

class RadioText extends StatefulWidget {
  @override
  _RadioTextState createState() => _RadioTextState();
}

class _RadioTextState extends State<RadioText> {
  @override
  Widget build(BuildContext context) {
    var _radioValue;
    return Row(children: <Widget>[
      new Radio(
        value: Litery.MALE,
        groupValue: _radioValue,
        onChanged: _handleRadioValueChange,
      ),
      new Text(
        'Małe litery',
        style: new TextStyle(fontSize: 16.0),
      ),
    ],);
  }

  void _handleRadioValueChange(value) {
  }
}
