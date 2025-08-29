part of 'counter_math_cubit.dart';

class CounterState {
  final List<int> pressCounts;
  final DateTime? lastPressTime;
  final DateTime? lastResetTime;
  final int weeklyTotal;
  final int monthlyTotal;
  final int total;
  final List<int> totalList; // قائمة المجاميع الكلية
  final Map<String, int> weeklyMap; // بيانات أسبوعية
  final Map<String, int> monthlyMap; // بيانات شهرية

  CounterState({
    required this.pressCounts,
    this.lastPressTime,
    this.lastResetTime,
    this.weeklyTotal = 0,
    this.monthlyTotal = 0,
    this.total = 0,
    this.totalList = const [],
    this.weeklyMap = const {},
    this.monthlyMap = const {},
  });

  factory CounterState.initial() {
    return CounterState(
      pressCounts: [],
      lastPressTime: null,
      lastResetTime: null,
      weeklyTotal: 0,
      monthlyTotal: 0,
      total: 0,
      totalList: [],
      weeklyMap: {},
      monthlyMap: {},
    );
  }

  CounterState copyWith({
    List<int>? pressCounts,
    DateTime? lastPressTime,
    DateTime? lastResetTime,
    int? weeklyTotal,
    int? monthlyTotal,
    int? total,
    List<int>? totalList,
    Map<String, int>? weeklyMap,
    Map<String, int>? monthlyMap,
  }) {
    return CounterState(
      pressCounts: pressCounts ?? this.pressCounts,
      lastPressTime: lastPressTime ?? this.lastPressTime,
      lastResetTime: lastResetTime ?? this.lastResetTime,
      weeklyTotal: weeklyTotal ?? this.weeklyTotal,
      monthlyTotal: monthlyTotal ?? this.monthlyTotal,
      total: total ?? this.total,
      totalList: totalList ?? this.totalList,
      weeklyMap: weeklyMap ?? this.weeklyMap,
      monthlyMap: monthlyMap ?? this.monthlyMap,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pressCounts': pressCounts,
      'lastPressTime': lastPressTime?.toIso8601String(),
      'lastResetTime': lastResetTime?.toIso8601String(),
      'weeklyTotal': weeklyTotal,
      'monthlyTotal': monthlyTotal,
      'total': total,
      'totalList': totalList,
      'weeklyMap': weeklyMap,
      'monthlyMap': monthlyMap,
    };
  }

  factory CounterState.fromJson(Map<String, dynamic> json) {
    return CounterState(
      pressCounts: List<int>.from(json['pressCounts']),
      lastPressTime: json['lastPressTime'] != null ? DateTime.parse(json['lastPressTime']) : null,
      lastResetTime: json['lastResetTime'] != null ? DateTime.parse(json['lastResetTime']) : null,
      weeklyTotal: json['weeklyTotal'] ?? 0,
      monthlyTotal: json['monthlyTotal'] ?? 0,
      total: json['total'] ?? 0,
      totalList: List<int>.from(json['totalList'] ?? []),
      weeklyMap: Map<String, int>.from(json['weeklyMap'] ?? {}),
      monthlyMap: Map<String, int>.from(json['monthlyMap'] ?? {}),
    );
  }
}