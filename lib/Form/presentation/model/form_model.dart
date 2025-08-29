// models/planting_form.dart
class PlantingForm {
  final bool firstOption;
  final bool secondOption;
  final bool thirdOption;
  final String? country;
  final String? city;
  final String? dataNumber1;
  final String? dataNumber2;
  final String? gender;
  final bool isMale;

  PlantingForm({
    required this.firstOption,
    required this.secondOption,
    required this.thirdOption,
    this.country,
    this.city,
    this.dataNumber1,
    this.dataNumber2,
    this.gender,
    required this.isMale,
  });

  PlantingForm copyWith({
    bool? firstOption,
    bool? secondOption,
    bool? thirdOption,
    String? country,
    String? city,
    String? dataNumber1,
    String? dataNumber2,
    String? gender,
    bool? isMale,
  }) {
    return PlantingForm(
      firstOption: firstOption ?? this.firstOption,
      secondOption: secondOption ?? this.secondOption,
      thirdOption: thirdOption ?? this.thirdOption,
      country: country ?? this.country,
      city: city ?? this.city,
      dataNumber1: dataNumber1 ?? this.dataNumber1,
      dataNumber2: dataNumber2 ?? this.dataNumber2,
      gender: gender ?? this.gender,
      isMale: isMale ?? this.isMale,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstOption': firstOption,
      'secondOption': secondOption,
      'thirdOption': thirdOption,
      'country': country,
      'city': city,
      'dataNumber1': dataNumber1,
      'dataNumber2': dataNumber2,
      'gender': gender,
      'isMale': isMale,
    };
  }

  factory PlantingForm.fromJson(Map<String, dynamic> json) {
    return PlantingForm(
      firstOption: json['firstOption'] ?? false,
      secondOption: json['secondOption'] ?? false,
      thirdOption: json['thirdOption'] ?? false,
      country: json['country'],
      city: json['city'],
      dataNumber1: json['dataNumber1'],
      dataNumber2: json['dataNumber2'],
      gender: json['gender'],
      isMale: json['isMale'] ?? false,
    );
  }
}