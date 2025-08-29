part of 'switch_cubit.dart';


class SwitchState extends Equatable {
  final bool dailyAnalyticsEnabled;
  final bool notificationsEnabled;
  final bool darkModeEnabled;

  const SwitchState({
    required this.dailyAnalyticsEnabled,
    required this.notificationsEnabled,
    required this.darkModeEnabled,
  });

  factory SwitchState.initial() {
    return const SwitchState(
      dailyAnalyticsEnabled: true,
      notificationsEnabled: false,
      darkModeEnabled: false,
    );
  }

  SwitchState copyWith({
    bool? dailyAnalyticsEnabled,
    bool? notificationsEnabled,
    bool? darkModeEnabled,
  }) {
    return SwitchState(
      dailyAnalyticsEnabled: dailyAnalyticsEnabled ?? this.dailyAnalyticsEnabled,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      darkModeEnabled: darkModeEnabled ?? this.darkModeEnabled,
    );
  }

  @override
  List<Object> get props => [
    dailyAnalyticsEnabled,
    notificationsEnabled,
    darkModeEnabled,
  ];
}