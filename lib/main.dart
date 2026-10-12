import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gana/splash_screen.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'core/unit/color/colors.dart';
import 'notification_service.dart';

import 'Form/presentation/bloc/user_form_cubit.dart';
import 'Form/presentation/pages/form_screen.dart';
import 'home/home_screen.dart';
import 'home/logic/diagram/chart_cubit.dart';
import 'home/logic/expand/expand.dart';
import 'home/logic/math/counter_math_cubit.dart';
import 'home/logic/progress/increment_cubit.dart';
import 'home/logic/switch/switch_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    final storageDirectory = await getApplicationDocumentsDirectory();
    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: storageDirectory,
    );
  } catch (e) {
    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: await getTemporaryDirectory(),
    );
  }

  await initializeNotifications();

  // Request notification permissions for both platforms
// Request permissions
  await requestNotificationsPermission(); // Android permission helper
  await requestIOSPermissions(); // iOS permission helper

  // Initialize Workmanager only on Android
  if (Platform.isAndroid) {
    Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: kDebugMode,
    );

    // register periodic task only on Android
    await scheduleDailyNotificationTask();
  } else {
    // On iOS: schedule local notification via the plugin (no background isolate)
    // You can schedule daily local notifications here. Example:
    await scheduleDailyNotificationsForIOS(); // implement in notification_service.dart
  }
  final prefs = await SharedPreferences.getInstance();
  final isFormCompleted = prefs.getBool('isFormCompleted') ?? false;

  runApp(MyApp(isFormCompleted: isFormCompleted));
}

class MyApp extends StatelessWidget {
  final bool isFormCompleted;
  const MyApp({super.key, required this.isFormCompleted});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UserFormCubit(),
        ),
        BlocProvider(
          create: (context) => DailyGoalCubit(),
        ),
        BlocProvider(
          create: (context) => CounterCubit(),
        ),
        BlocProvider(
          create: (context) => ExpandCubit(),
        ),
        BlocProvider(
          create: (context) => IncrementChartCubit(),
        ),
        BlocProvider(
          create: (context) => SwitchCubit(),
        ),

        // Add more blocs as needed
      ],
      child: BlocBuilder<SwitchCubit, SwitchState>(
        builder: (context, state) {
          return MaterialApp(
            navigatorKey: notificationNavigatorKey,
            title: 'غرسك',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
              fontFamily: 'CustomFont1',
              textTheme:  const TextTheme(
               bodyLarge: TextStyle(color: AppColors.fontPrimary, fontFamily: 'CustomFont1'),
                bodyMedium: TextStyle(color: AppColors.fontPrimary, fontFamily: 'CustomFont1'),
                bodySmall: TextStyle(color: AppColors.fontPrimary, fontFamily: 'CustomFont1'),
                displayLarge: TextStyle(color: AppColors.fontPrimary, fontFamily: 'CustomFont2'),
                displayMedium: TextStyle(color: AppColors.fontPrimary, fontFamily: 'CustomFont2'),
                displaySmall: TextStyle(color: AppColors.fontPrimary, fontFamily: 'CustomFont2'),
                headlineLarge: TextStyle(color: AppColors.fontPrimary, fontFamily: 'CustomFont2'),
                headlineMedium: TextStyle(color: AppColors.fontPrimary, fontFamily: 'CustomFont2'),
                headlineSmall: TextStyle(color: AppColors.fontPrimary, fontFamily: 'CustomFont2'),
                titleLarge: TextStyle(color: AppColors.fontPrimary, fontFamily: 'CustomFont2'),
                titleMedium: TextStyle(color: AppColors.fontPrimary, fontFamily: 'CustomFont2'),
                titleSmall: TextStyle(color: AppColors.fontPrimary, fontFamily: 'CustomFont2'),
                labelLarge: TextStyle(color: AppColors.fontPrimary, fontFamily: 'CustomFont2'),
                labelMedium: TextStyle(color: AppColors.fontPrimary, fontFamily: 'CustomFont2'),
                labelSmall: TextStyle(color: AppColors.fontPrimary, fontFamily: 'CustomFont2'),
              ),
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              useMaterial3: true,
              fontFamily: 'CustomFont1',
              textTheme:  const TextTheme(
              bodyLarge: TextStyle(color: Colors.white, fontFamily: 'CustomFont1'),
                bodyMedium: TextStyle(color: Colors.white, fontFamily: 'CustomFont1'),
                bodySmall: TextStyle(color: Colors.white, fontFamily: 'CustomFont1'),
                displayLarge: TextStyle(color: Colors.white, fontFamily: 'CustomFont2'),
                displayMedium: TextStyle(color: Colors.white, fontFamily: 'CustomFont2'),
                displaySmall: TextStyle(color: Colors.white, fontFamily: 'CustomFont2'),
                headlineLarge: TextStyle(color: Colors.white, fontFamily: 'CustomFont2'),
                headlineMedium: TextStyle(color: Colors.white, fontFamily: 'CustomFont2'),
                headlineSmall: TextStyle(color: Colors.white, fontFamily: 'CustomFont2'),
                titleLarge: TextStyle(color: Colors.white, fontFamily: 'CustomFont2'),
                titleMedium: TextStyle(color: Colors.white, fontFamily: 'CustomFont2'),
                titleSmall: TextStyle(color: Colors.white, fontFamily: 'CustomFont2'),
                labelLarge: TextStyle(color: Colors.white, fontFamily: 'CustomFont2'),
                labelMedium: TextStyle(color: Colors.white, fontFamily: 'CustomFont2'),
                labelSmall: TextStyle(color: Colors.white, fontFamily: 'CustomFont2'),

              ),
              // Customize dark theme color scheme if desired
            ),
            themeMode: state.darkModeEnabled ? ThemeMode.dark : ThemeMode.light,
            home: SplashWrapper(isFormCompleted: isFormCompleted),
            // home: isFormCompleted ?const HomeScreen() :const PlantingFormScreen(),
          );
        },
      ),
    );
  }

}

class SplashWrapper extends StatefulWidget {
  final bool isFormCompleted;
  const SplashWrapper({super.key, required this.isFormCompleted});

  @override
  State<SplashWrapper> createState() => _SplashWrapperState();
}

class _SplashWrapperState extends State<SplashWrapper> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => widget.isFormCompleted ? HomeScreen() : PlantingFormScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}
