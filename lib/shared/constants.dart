import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const double kDefaultPaddingValue = 16;
const kDefaultPadding = EdgeInsets.all(16);
const quizTime = 60 * 20;

final ButtonStyle style = ElevatedButton.styleFrom(
    textStyle: const TextStyle(fontSize: 20),
    backgroundColor: Colors.white,
    shadowColor: Colors.grey,
    alignment: Alignment.center,
    minimumSize: Size(200, 100),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)));

enum TEST_TYPE { STUDY, TEST }

enum TABS { SEARCH, MOCK_TEST, ANALYSIS, MINIMAP }

const TIME_OUT = 60;
