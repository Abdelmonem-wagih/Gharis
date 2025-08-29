import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';

part 'user_form_state.dart';


class UserFormCubit extends HydratedCubit<UserFormState> {
  UserFormCubit() : super(const UserFormState());

  void updateFirstName(String value) => emit(state.copyWith(firstName: value));
  void updateLastName(String value) => emit(state.copyWith(lastName: value));
  void updatePhone(String value) => emit(state.copyWith(phone: value));
  void updateCountry(String value) => emit(state.copyWith(country: value));
  Future<void> submitForm() async {
    if (!state.isValid) return;

    emit(state.copyWith(isLoading: true));

    await Future.delayed(const Duration(seconds: 2)); // Simulated API or save

    emit(state.copyWith(isLoading: false));
  }

  @override
  UserFormState fromJson(Map<String, dynamic> json) => UserFormState.fromJson(json);

  @override
  Map<String, dynamic> toJson(UserFormState state) => state.toJson();
}
