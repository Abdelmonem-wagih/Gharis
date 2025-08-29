import 'dart:async';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intl/intl.dart';
part 'counter_math_state.dart';

class CounterCubit extends HydratedCubit<CounterState> {
  Timer? _dailyTimer;
  Timer? _weeklyTimer;
  Timer? _monthlyTimer;
  Timer? _totalTimer;

  CounterCubit() : super(CounterState.initial()) {
    _startTimers();
  }

  void _startTimers() {
    _dailyTimer = Timer.periodic(Duration(hours: 24), (timer) {
      resetCounter();
    });

    _weeklyTimer = Timer.periodic(Duration(days: 7), (timer) {
      saveWeeklyTotal();
    });

    _monthlyTimer = Timer.periodic(Duration(days: 30), (timer) {
      saveMonthlyTotal();
    });

    _totalTimer = Timer.periodic(Duration(days: 365), (timer) {
      saveTotal();
    });
  }

  void increment() {
    final currentTime = DateTime.now();
    final lastPressTime = state.lastPressTime;

    if (lastPressTime != null && currentTime.difference(lastPressTime).inSeconds > 5) {
      emit(state.copyWith(
        pressCounts: [...state.pressCounts, 1],
        lastPressTime: currentTime,
      ));
    } else {
      final updatedPressCounts = List<int>.from(state.pressCounts);
      if (updatedPressCounts.isNotEmpty) {
        updatedPressCounts[updatedPressCounts.length - 1]++;
      } else {
        updatedPressCounts.add(1);
      }
      emit(state.copyWith(
        pressCounts: updatedPressCounts,
        lastPressTime: currentTime,
      ));
    }

    final totalPresses = state.pressCounts.fold(0, (sum, count) => sum + count);
    emit(state.copyWith(
      total: state.total + 1,
      weeklyTotal: state.weeklyTotal + 1,
      monthlyTotal: state.monthlyTotal + 1,
    ));
  }

  void resetCounter() {
    emit(state.copyWith(
      pressCounts: [],
      lastResetTime: DateTime.now(),
    ));
  }

  void saveTotal() {
    final total = state.total;
    List<int> updatedTotalList = List.from(state.totalList);

    if (updatedTotalList.length >= 5) {
      updatedTotalList.removeAt(0);
    }
    updatedTotalList.add(total);

    emit(state.copyWith(
      totalList: updatedTotalList,
    ));
  }

  void saveWeeklyTotal() {
    final weeklyTotal = state.weeklyTotal;
    Map<String, int> updatedWeeklyMap = Map.from(state.weeklyMap);

    String weekKey = 'Week ${updatedWeeklyMap.length + 1}';
    updatedWeeklyMap[weekKey] = weeklyTotal;

    if (updatedWeeklyMap.length > 5) {
      updatedWeeklyMap.remove(updatedWeeklyMap.keys.first);
    }

    emit(state.copyWith(
      weeklyMap: updatedWeeklyMap,
      weeklyTotal: 0,
    ));
  }

  void saveMonthlyTotal() {
    final monthlyTotal = state.monthlyTotal;
    Map<String, int> updatedMonthlyMap = Map.from(state.monthlyMap);

    String monthKey = DateFormat('MMM').format(DateTime.now());
    updatedMonthlyMap[monthKey] = monthlyTotal;

    if (updatedMonthlyMap.length > 5) {
      updatedMonthlyMap.remove(updatedMonthlyMap.keys.first);
    }

    emit(state.copyWith(
      monthlyMap: updatedMonthlyMap,
      monthlyTotal: 0,
    ));
  }

  @override
  CounterState? fromJson(Map<String, dynamic> json) {
    return CounterState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(CounterState state) {
    return state.toJson();
  }

  @override
  Future<void> close() {
    _dailyTimer?.cancel();
    _weeklyTimer?.cancel();
    _monthlyTimer?.cancel();
    _totalTimer?.cancel();
    return super.close();
  }
}