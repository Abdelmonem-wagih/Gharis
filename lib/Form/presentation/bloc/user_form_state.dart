part of 'user_form_cubit.dart';

class UserFormState extends Equatable {
  final String firstName;
  final String lastName;
  final String phone;
  final String country;
  final bool isLoading; // 🆕 new field

  const UserFormState({
    this.firstName = '',
    this.lastName = '',
    this.phone = '',
    this.isLoading = false, // 🆕 default

    this.country = 'مصر', // ✅ Default must exist in dropdown items
  });

  bool get isValid =>
      firstName.isNotEmpty && lastName.isNotEmpty;

  UserFormState copyWith({
    String? firstName,
    String? lastName,
    String? phone,
    String? country,
    bool? isLoading, // 🆕 add to copy
  }) {
    return UserFormState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      country: country ?? this.country,
      isLoading: isLoading ?? this.isLoading, // 🆕
    );
  }

  factory UserFormState.fromJson(Map<String, dynamic> json) {
    return UserFormState(
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      phone: json['phone'] ?? '',
      country: json['country'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'country': country,
    };
  }

  @override
  List<Object?> get props =>
      [firstName, lastName, phone, country, isLoading]; // 🆕
}
