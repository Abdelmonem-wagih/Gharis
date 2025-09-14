import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';

const String dailyNotificationTask = "dailyNotificationTask";

final List<String> notificationMessages = [
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
  "كم شجرة غرست اليوم؟  تذكر، كل ذكرى شجرة في الجنة.  عد لغرس الجنة واملأ جنتك بالأشجار.",
  "هل حصلت على غرس اليوم في الجنة؟ تذكر، 'سبحان الله العظيم وبحمده' نخلة لك في الجنة مع غرس الجنة.",
  "استغل دقائق فراغك في غرس الجنة وازرع نخلاً مباركاً بذكر الله.",
  " لحظات قليلة مع غرس الجنة تغرس لك أشجاراً في الجنة. لا تدعها تفوتك!",
  "لا تنسى حصاد اليوم من الغرس! افتح غرس الجنة واذكر الله لتزيد أشجار جنتك.",
];

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<void> showRandomNotification() async {
  final random = Random();
  final message =
      notificationMessages[random.nextInt(notificationMessages.length)];
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'daily_channel_id',
    'Daily Notifications',
    channelDescription: 'Daily random reminder',
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
  );

  const DarwinNotificationDetails iosPlatformChannelSpecifics =
      DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iosPlatformChannelSpecifics,
      );

  await flutterLocalNotificationsPlugin.show(
    0,
    'غرس الجنة',
    message,
    platformChannelSpecifics,
  );
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await initializeNotifications();
    await showRandomNotification();
    return Future.value(true);
  });
}

Future<void> requestIOSPermissions() async {
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
    alert: true,
    badge: true,
    sound: true,
  );
}

Future<void> requestNotificationsPermission() async {
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();
}

Future<void> cancelAllNotifications() async {
  await flutterLocalNotificationsPlugin.cancelAll();
}

Future<void> showNotification(int count, String name) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'your_channel_id',
    'your_channel_name',
    channelDescription: 'your_channel_description',
    importance: Importance.max,
    priority: Priority.high,
    showWhen: false,
  );

  const DarwinNotificationDetails iosPlatformChannelSpecifics =
      DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iosPlatformChannelSpecifics,
      );

  await flutterLocalNotificationsPlugin.show(
    0,
    '🎉 تهانينا!',
    'لقد غرست اليوم $count $name في الجن استمر في هذا الخير مع غرس الجنة وزد رصيدك في الآخرة.',
    platformChannelSpecifics,
    payload: 'item x',
  );
}

Future<void> scheduleDailyNotificationTask() async {
  await Workmanager().registerPeriodicTask(
    "1",
    dailyNotificationTask,
    frequency: const Duration(hours: 12),
    constraints: Constraints(
      networkType: NetworkType.not_required,
      requiresBatteryNotLow: false,
      requiresCharging: false,
      requiresDeviceIdle: false,
      requiresStorageNotLow: false,
    ),
  );
}
