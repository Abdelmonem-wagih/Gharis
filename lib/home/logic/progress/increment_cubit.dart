import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'dart:async';
class IncrementChartCubit extends HydratedCubit<List<int>> {
  Timer? _inactivityTimer;
  DateTime _lastReset;

  IncrementChartCubit()
      : _lastReset = DateTime.now(),
        super([0]) {
    _checkForDailyReset();
  }

  void increment() {
    _checkForDailyReset();
    _handleInactivity();

    final updated = List<int>.from(state);
    updated[updated.length - 1] += 1;
    emit(updated);
  }

  void _handleInactivity() {
    final isInactive = _inactivityTimer?.isActive == false;

    if (isInactive || _inactivityTimer == null) {
      final updated = List<int>.from(state);
      updated.add(0); // Start new session
      emit(updated);
    }

    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(const Duration(seconds: 5), () {});
  }

  int get currentValue => state.last;

  void _checkForDailyReset() {
    final now = DateTime.now();
    if (now.difference(_lastReset).inHours >= 24) {
      _lastReset = now;
      emit([0]);
    }
  }

  @override
  List<int>? fromJson(Map<String, dynamic> json) {
    final savedChart = List<int>.from(json['chart'] ?? [0]);
    final resetTime = DateTime.tryParse(json['lastReset'] ?? '');
    _lastReset = resetTime ?? DateTime.now();
    return savedChart;
  }

  @override
  Map<String, dynamic>? toJson(List<int> state) {
    return {
      'chart': state,
      'lastReset': _lastReset.toIso8601String(),
    };
  }

  @override
  Future<void> close() {
    _inactivityTimer?.cancel();
    return super.close();
  }
}
