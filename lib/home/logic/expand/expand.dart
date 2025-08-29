import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpandCubit extends Cubit<bool> {
  ExpandCubit() : super(false); // Default is collapsed

  void toggleExpand() {
    emit(!state);
  }
}
