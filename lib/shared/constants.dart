// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

const kPrimaryButtonColor = Color.fromARGB(255, 51, 102, 255);
const kDangerButtonColor = Color.fromARGB(255, 239, 68, 68);
const kSuccessButtonColor = Color.fromARGB(255, 34, 197, 94);
const kWarningButtonColor = Color.fromARGB(255, 245, 159, 11);
const kDisabledButtonColor = Color.fromARGB(255, 108, 117, 125);
const kPrimaryTextColor = Color.fromARGB(255, 51, 51, 51);
const kDisabledTextColor = Color.fromARGB(255, 102, 102, 102);

const kPrimaryBackgroundColor = Color.fromARGB(255, 255, 255, 255);

const double kDefaultPaddingValue = 16;
const kDefaultPadding = EdgeInsets.all(16);
const quizTime = 60;

final ButtonStyle kDefaultButtonStyle = ElevatedButton.styleFrom(
    textStyle: const TextStyle(fontSize: FONTSIZES.textPrimary),
    backgroundColor: Colors.white,
    shadowColor: Colors.grey,
    alignment: Alignment.center,
    minimumSize: const Size(200, 100),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)));

final ButtonStyle kModeChoosingButtonStyle = ElevatedButton.styleFrom(
    textStyle: const TextStyle(fontSize: FONTSIZES.textLarge),
    backgroundColor: Colors.blueAccent.shade200,
    shadowColor: Colors.grey,
    alignment: Alignment.center,
    minimumSize: const Size(200, 10),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)));

// Theme.of(context)
//                                     .textTheme
//                                     .headline4
//                                     ?.copyWith(
//                                         color: Colors.blueAccent.shade200,
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: FONTSIZES.textHuge)


enum TEST_TYPE { STUDY, TEST }

enum TABS { SEARCH, MOCK_TEST, ANALYSIS, MINIMAP, WELCOME, LOGIN, SIGNUP }

class FONTSIZES {
  static const double textTiny = 8;
  static const double textMini = 10;
  static const double textSmall = 12;
  static const double textMedium = 14;
  static const double textPrimary = 16;
  static const double textMediumLarge = 18;
  static const double textLarge = 20;
  static const double textLarger = 24;
  static const double textHuge = 28;
  static const double textVeryHuge = 32;
}

const TIME_OUT = 60;

const emptyUserId = "00000000-0000-0000-0000-000000000000"; // jwt fixed

// const url = "https://10.0.2.2:5001/api/";
const url = "https://vnrdntaiapi.azurewebsites.net/api/";

// const ai_url = "http://10.0.2.2:5000/";
const ai_url = "https://vnrdnt-ai-aimodule.herokuapp.com/";




// {
//         "id": "7df14016-d391-4a5b-9151-dc810e98c9aa",
//         "username": "user0",
//         "password": "123456789",
//         "role": 2,
//         "status": 5,
//         "createdDate": "2020-10-01T00:00:00",
//         "isDeleted": false,
//         "comments": [],
//         "paragraphModificationRequestAdmins": [],
//         "paragraphModificationRequestScribes": [],
//         "testResults": [],
//         "userModificationRequestArbitratingAdmins": [],
//         "userModificationRequestModifiedUsers": [],
//         "userModificationRequestModifyingUsers": [],
//         "userModificationRequestPromotingAdmins": []
//     }
