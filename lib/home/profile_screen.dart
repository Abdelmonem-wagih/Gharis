import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gana/home/widget/app_bar_widget.dart';

import '../Form/presentation/bloc/user_form_cubit.dart';
import '../core/unit/color/colors.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String? _selectedCountry = "مصر";

  // List of countries with flag and phone code
  final List<Map<String, String>> countryList = [
    {"name": "مصر", "flag": "🇪🇬", "code": "+20"},
    {"name": "السعودية", "flag": "🇸🇦", "code": "+966"},
    {"name": "الإمارات", "flag": "🇦🇪", "code": "+971"},
    {"name": "الكويت", "flag": "🇰🇼", "code": "+965"},
    {"name": "قطر", "flag": "🇶🇦", "code": "+974"},
    {"name": "البحرين", "flag": "🇧🇭", "code": "+973"},
    {"name": "عمان", "flag": "🇴🇲", "code": "+968"},
    {"name": "الأردن", "flag": "🇯🇴", "code": "+962"},
    {"name": "فلسطين", "flag": "🇵🇸", "code": "+970"},
    {"name": "لبنان", "flag": "🇱🇧", "code": "+961"},
    {"name": "سوريا", "flag": "🇸🇾", "code": "+963"},
    {"name": "العراق", "flag": "🇮🇶", "code": "+964"},
    {"name": "اليمن", "flag": "🇾🇪", "code": "+967"},
    {"name": "المغرب", "flag": "🇲🇦", "code": "+212"},
    {"name": "الجزائر", "flag": "🇩🇿", "code": "+213"},
    {"name": "تونس", "flag": "🇹🇳", "code": "+216"},
    {"name": "ليبيا", "flag": "🇱🇾", "code": "+218"},
    {"name": "السودان", "flag": "🇸🇩", "code": "+249"},
    {"name": "موريتانيا", "flag": "🇲🇷", "code": "+222"},
    {"name": "الصومال", "flag": "🇸🇴", "code": "+252"},
  ];
  String? selectedCountryName;
  String? selectedCountryCode;
  String? selectedCountryFlag;
  String? phoneError;
  @override
  void initState() {
    super.initState();

    final formState = context.read<UserFormCubit>().state;

    _firstNameController.text = formState.firstName ?? '';
    _lastNameController.text = formState.lastName ?? '';
    _phoneController.text = formState.phone ?? '';
    _selectedCountry = formState.country ?? 'مصر';
  }

  void _onPhoneChanged(String value) {
    context.read<UserFormCubit>().updatePhone(value);
    setState(() {
      phoneError = null;
    });
  }

  bool get isFormValid =>
      _firstNameController.text.isNotEmpty &&
      _lastNameController.text.isNotEmpty &&
      _phoneController.text.isNotEmpty &&
      _selectedCountry != null ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(20),
              child: AppBarWidget(title: 'الملف الشخصي'),
            ),
            Expanded(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 210),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel("الاسم الأول"),
                            _buildTextField(
                              
                              _firstNameController,
                                  (val) => context.read<UserFormCubit>().updateFirstName(val),
                            ),
                            _buildLabel("الاسم الثاني"),
                            _buildTextField(
                              _lastNameController,
                                  (val) => context.read<UserFormCubit>().updateLastName(val),
                            ),
                            // _buildLabel("الدولة"),
                            // _buildCountryDropdown(
                            //   value: _selectedCountry,
                            //   items: countryList,
                            //   onChanged: (val) =>
                            //       setState(() => _selectedCountry = val),
                            // ),
                            // _buildLabel("رقم الهاتف اختياري"),
                            // _buildPhoneField(
                            //   controller: _phoneController,
                            //   onChanged: _onPhoneChanged,
                            //   countryCode: selectedCountryCode,
                            //   errorText: phoneError,
                            // ),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                height: 50,
                width: double.infinity,
                child: BlocBuilder<UserFormCubit, UserFormState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: (!state.isValid || state.isLoading)
                          ? null
                          : () async {
                              final cubit = context.read<UserFormCubit>();

                              // cubit.updateFirstName(_firstNameController.text);
                              // cubit.updateLastName(_lastNameController.text);
                              // cubit.updatePhone(_phoneController.text);
                              // cubit.updateCountry(_selectedCountry ?? 'مصر');
                              // cubit.updateGender(_selectedGender ?? 'ذكر');

                              await cubit.submitForm();

                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('تم حفظ التغييرات بنجاح')),
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: state.isValid
                            ? AppColors.primary
                            : Colors.grey[300],
                        foregroundColor: Colors.white,
                      ),
                      child: state.isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : const Text(
                              "حفظ التغييرات",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 6),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, Function(String) onChanged) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10), // More curve
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    final safeValue = items.contains(value) ? value : null;

    return DropdownButtonFormField<String>(
      value: safeValue,
      onChanged: onChanged,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10), // More curve
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
    );
  }

  Widget _buildPhoneField({
    required TextEditingController controller,
    required Function(String) onChanged,
    required String? countryCode,
    String? errorText,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.phone,
      onChanged: onChanged,
      decoration: InputDecoration(
        prefixText: countryCode != null ? '$countryCode ' : '',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        errorText: errorText,
      ),
    );
  }

  Widget _buildCountryDropdown({
    required String? value,
    required List<Map<String, String>> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
      items: items.map((country) {
        return DropdownMenuItem<String>(
          value: country["name"],
          child: Row(
            children: [
              Text(country["flag"] ?? ""),
              const SizedBox(width: 8),
              Text(country["name"] ?? ""),
              const SizedBox(width: 8),
              Text(country["code"] ?? ""),
            ],
          ),
        );
      }).toList(),
    );
  }
}
