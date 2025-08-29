part of 'chart_cubit.dart';

@immutable
class DailyGoalState {
  final double currentProgress;
  final int dailyGoal;
  final DateTime lastUpdated;

   DailyGoalState({
    this.currentProgress = 0,
    this.dailyGoal = 10,
    DateTime? lastUpdated,
  }) : lastUpdated = lastUpdated ?? DateTime.now();

  DailyGoalState copyWith({
    double? currentProgress,
    int? dailyGoal,
    DateTime? lastUpdated,
  }) {
    return DailyGoalState(
      currentProgress: currentProgress ?? this.currentProgress,
      dailyGoal: dailyGoal ?? this.dailyGoal,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'currentProgress': currentProgress,
      'dailyGoal': dailyGoal,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory DailyGoalState.fromMap(Map<String, dynamic> map) {
    return DailyGoalState(
      currentProgress: map['currentProgress']?.toDouble() ?? 0,
      dailyGoal: map['dailyGoal']?.toInt() ?? 10,
      lastUpdated: DateTime.parse(map['lastUpdated']),
    );
  }
}