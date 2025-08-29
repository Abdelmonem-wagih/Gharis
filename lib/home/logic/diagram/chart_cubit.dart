import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'chart_state.dart';

// lib/cubit/daily_goal_cubit.dart


class DailyGoalCubit extends HydratedCubit<DailyGoalState> {
  DailyGoalCubit() : super( DailyGoalState());

  void updateProgress(double newProgress) {
    emit(state.copyWith(
      currentProgress: newProgress,
      lastUpdated: DateTime.now(),
    ));
  }

  void setDailyGoal(int goal) {
    emit(state.copyWith(dailyGoal: goal));
  }

  @override
  DailyGoalState? fromJson(Map<String, dynamic> json) {
    return DailyGoalState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(DailyGoalState state) {
    return state.toMap();
  }
}
