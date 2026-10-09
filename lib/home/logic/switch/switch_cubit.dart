import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'switch_state.dart';


class SwitchCubit extends HydratedCubit<SwitchState> {
  SwitchCubit() : super(SwitchState.initial());

  void toggleDailyAnalytics() {
    emit(state.copyWith(
      dailyAnalyticsEnabled: !state.dailyAnalyticsEnabled,
    ));
  }

  void toggleNotifications() {
    emit(state.copyWith(
      notificationsEnabled: !state.notificationsEnabled,
    ));
  }

  void toggleDarkMode() {
    emit(state.copyWith(
      darkModeEnabled: !state.darkModeEnabled,
    ));
  }

  @override
  SwitchState? fromJson(Map<String, dynamic> json) {
    return SwitchState(
      dailyAnalyticsEnabled: json['dailyAnalyticsEnabled'] as bool,
      notificationsEnabled: json['notificationsEnabled'] as bool,
      darkModeEnabled: json['darkModeEnabled'] as bool,
    );
  }

  @override
  Map<String, dynamic>? toJson(SwitchState state) {
    return {
      'dailyAnalyticsEnabled': state.dailyAnalyticsEnabled,
      'notificationsEnabled': state.notificationsEnabled,
      'darkModeEnabled': state.darkModeEnabled,
    };
  }
}