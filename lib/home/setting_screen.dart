import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gana/home/profile_screen.dart';
import 'package:gana/home/widget/app_bar_widget.dart';
import 'package:gana/home/widget/app_widget.dart';
import 'package:share_plus/share_plus.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:workmanager/workmanager.dart';
import '../core/unit/color/colors.dart';
import '../notification_service.dart';
import 'analytics_screen.dart';
import 'logic/switch/switch_cubit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _handleNotificationToggle(
      BuildContext context, bool enable) async {
    print('Notifications enabled: $enable');
    if (enable) {
      print('Requesting notifications permission...');
      if (Platform.isIOS) {
        await requestIOSPermissions();
        await scheduleDailyNotificationsForIOS();
      } else {
        await requestNotificationsPermission();
        await scheduleDailyNotificationTask();
      }
    } else {
      print('Cancelling all notifications...');
      // Cancel all notifications
      await cancelAllNotifications();
      if (Platform.isAndroid) {
        // Also stop the recurring Workmanager task, otherwise it fires again
        // within 12h and silently re-enables notifications.
        await Workmanager().cancelByUniqueName("1");
      }
    }
    context.read<SwitchCubit>().toggleNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<SwitchCubit, SwitchState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    const AppWidget(
                      haveIcon: false,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const AppBarWidget(
                      title: 'الإعدادت الخاصة بك',
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    _buildSettingsItem(
                      title: 'الملف الشخصي',
                      haveChecked: false,
                      isChecked: false,
                      icon: 'assets/person.svg',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PersonalInfoScreen()),
                        );
                      },
                    ),
                    _buildSettingsItem(
                      title: 'الإشعارات',
                      haveChecked: true,
                      isChecked: state.notificationsEnabled,
                      icon: 'assets/noti.svg',
                      onTap: () => _handleNotificationToggle(
                        context,
                        !state.notificationsEnabled,
                      ),
                    ),
                    _buildSettingsItem(
                      title: 'التحاليل اليومية ',
                      haveChecked: true,
                      isChecked: state.dailyAnalyticsEnabled,
                      icon: 'assets/analytics.svg',
                      onTap: () =>
                          context.read<SwitchCubit>().toggleDailyAnalytics(),
                    ),
                    _buildSettingsItem(
                      title: 'الوضع المظلم',
                      haveChecked: true,
                      isChecked: state.darkModeEnabled,
                      icon: 'assets/Mode.svg',
                      onTap: () => context.read<SwitchCubit>().toggleDarkMode(),
                    ),
                    // _buildSettingsItem(
                    //   title: 'قيم غرس الجنة',
                    //   haveChecked: false,
                    //   isChecked: false,
                    //   icon: 'assets/Rate.svg',
                    //   onTap: () async {
                    //     final InAppReview inAppReview = InAppReview.instance;
                    //     if (await inAppReview.isAvailable()) {
                    //       inAppReview.openStoreListing(
                    //         appStoreId: null, // Only needed for iOS
                    //         microsoftStoreId: null, // Only needed for Windows
                    //       );
                    //     }
                    //   },
                    // ),
                    _buildSettingsItem(
                      title: 'شارك غرس الجنة',
                      haveChecked: false,
                      isChecked: false,
                      icon: 'assets/share.svg',
                      onTap: () {
                        Share.share(
                          'أنصحكم بتجربة تطبيق غرس الجنة، تطبيق مميز يساعدك على متابعة أعمالك اليومية بسهولة. حمله الآن:\n'
                          'https://play.google.com/store/apps/details?id=com.ghars.gana&pcampaignid=web_share',
                        );
                      },
                    ),
                    // _buildSettingsItem(
                    //   title: 'تواصل معنا',
                    //   haveChecked: false,
                    //   isChecked: false,
                    //   icon: 'assets/contect.svg',
                    //   onTap: () {},
                    // ),
                  ],
                ),
                SvgPicture.asset('assets/ifq.svg'),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSettingsItem({
    required String title,
    required bool isChecked,
    required bool haveChecked,
    required String icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Visibility(
              visible: haveChecked,
              child: SvgPicture.asset(
                  isChecked ? 'assets/switchOn.svg' : 'assets/switchOff.svg'),
            ),
            Row(children: [
              Visibility(
                visible: haveChecked,
                child: Text(
                  isChecked ? '(مفعلة)' : '(غير مفعل)',
                  style: TextStyle(
                      fontSize: 18,
                      color: isChecked
                          ? AppColors.primary
                          : AppColors.fontPrimary),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(width: 10),
              SvgPicture.asset(icon),
            ]),
          ],
        ),
      ),
    );
  }
}
