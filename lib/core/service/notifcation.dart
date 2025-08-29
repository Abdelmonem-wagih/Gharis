// dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:workmanager/workmanager.dart';

// Define a unique name for the work task
const String dailyTask = "dailyNotification";

// Create an instance for flutter_local_notifications
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

// List of notifications messages
final List<String> messages = [
  "نخلة تنتظرك في الجنة! استمر بذكر الله واغرس المزيد مع غرس الجنة.",
  "لا تدع يومك يمضي بلا غرس. افتح غرس الجنة الآن وازرع أشجاراً في جنتك.",
  "أجور عظيمة وغرس في الجنة ينتظرك!  ذكر الله قليلاً يثمر كثيراً في الآخرة. افتح التطبيق الآن.",
  "هل نسيت غرس اليوم؟ بضع ثوانٍ من الذكر تُثمر نخيلاً في الجنة. عد إلى غرس الجنة الآن.",
  "لا تفوت فرصة غرس الجنة. كل تسبيحة تسبيحة عظيمة لك نخلة في الجنة. هيا للذكر!",
  "نور يومك بذكر الله. بانتظارك في غرس الجنة.",
  "اجعل لسانك رطباً بذكر الله. غرس الجنة ينتظرك ليزهر بذكرك.",
  "دع قلبك يطمئن بذكر الله.  تطبيق غرس الجنة رفيقك في الذكر.",
  "ذكر الله حصنك ونجاتك.  تطبيق غرس الجنة هنا ليساعدك على الدوام على الذكر.",
  "«سُبْحَانَ اللهِ العَظِيمِ وَبِحَمْدِهِ»... نخلة في الجنة! غرس الجنة بانتظارك.",
  "«سُبْحَانَ اللَّهِ، وَالْحَمْدُ لِلَّهِ، وَلَا إِلَهَ إِلَّا اللَّهُ، وَاللَّهُ أَكْبَرُ» ... شجرة في الجنة! لا تنسى غرسك اليوم.",
  "«فاذكروني أذكركم...»  تطبيق غرس الجنة هنا ليذكرك بالله فتذكره.",
  "هل تريد غرس نخلة الآن؟ افتح غرس الجنة وقل: سبحان الله العظيم وبحمده.",
  "كم شجرة غرست اليوم؟  تذكر، كل ذكرى شجرة في الجنة.  عد لغرس الجنة واملأ جنتك بالأشجار."
];

