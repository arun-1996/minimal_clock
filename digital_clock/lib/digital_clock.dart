// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum _Element {
  background,
  text,
  shadow,
}

final _lightTheme = {
  _Element.background: Colors.white,
  _Element.text: Colors.black,
  _Element.shadow: Colors.black,
};

final _darkTheme = {
  _Element.background: Colors.black,
  _Element.text: Colors.white,
  _Element.shadow: Color(0xFF174EA6),
};

class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);

  final ClockModel model;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {});
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      _timer = Timer(
        Duration(minutes: 1) -
            Duration(seconds: _dateTime.second) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.light
        ? _lightTheme
        : _darkTheme;
    final hour =
        DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    final minute = DateFormat('mm').format(_dateTime);
    final fontSize = MediaQuery.of(context).size.width / 5;
    final defaultStyle = TextStyle(
        color: colors[_Element.text],
        fontSize: fontSize,
        fontFamily: 'Montserrat');

    final showMid = !widget.model.is24HourFormat;
    final mid = showMid ? DateFormat("aaa").format(_dateTime) : "";
    final midStyle = TextStyle(
        color: colors[_Element.text],
        fontSize: fontSize / 3,
        height: 3.5,
        fontFamily: 'Montserrat');
    final downStyle = TextStyle(
        color: colors[_Element.text],
        fontSize: fontSize / 6,
        fontFamily: 'Montserrat');

    final day = DateFormat('EEE').format(_dateTime);
    final date = DateFormat.yMMMMd("en_US").format(_dateTime);

    return Container(
        color: colors[_Element.background],
        child: Center(
            child: DefaultTextStyle(
          style: defaultStyle,
          child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(hour),
                      Text(":"),
                      Text(minute),
                      Text(
                        mid,
                        style: midStyle,
                      ),
                    ],
                  ),
                  DefaultTextStyle(
                      style: downStyle,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(day),
                          SizedBox(width: 20),
                          Text(date),
                        ],
                      ))
                ]),
          ),
        )));
  }
}
