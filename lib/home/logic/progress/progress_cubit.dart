import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProgressCubit extends Cubit<double> {
  ProgressCubit() : super(0.2); // Initial progress (20%)

  void updateProgress(double value) {
    emit(value);
  }
}
