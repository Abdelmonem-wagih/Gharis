import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gana/core/unit/color/colors.dart';
import 'package:gana/core/unit/images.dart';
import 'package:gana/core/unit/string/string.dart';
import 'package:gana/home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../bloc/user_form_cubit.dart';
// Replace with your constants (e.g., AppColors, AppImages, AppString)

class PlantingFormScreen extends StatefulWidget {
  const PlantingFormScreen({super.key});

  @override
  State<PlantingFormScreen> createState() => _PlantingFormScreenState();
}

class _PlantingFormScreenState extends State<PlantingFormScreen> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _phoneController;


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
    final state = context.read<UserFormCubit>().state;
    _firstNameController = TextEditingController(text: state.firstName);
    _lastNameController = TextEditingController(text: state.lastName);
    _phoneController = TextEditingController(text: state.phone);

    // Set default country
    final defaultCountry = countryList.first;
    selectedCountryName = state.country.isNotEmpty
        ? state.country
        : defaultCountry["name"];
    final country = countryList.firstWhere(
          (c) => c["name"] == selectedCountryName,
      orElse: () => defaultCountry,
    );
    selectedCountryCode = country["code"];
    selectedCountryFlag = country["flag"];
  }

  void _onCountryChanged(String? countryName) {
    final country = countryList.firstWhere(
          (c) => c["name"] == countryName,
      orElse: () => countryList.first,
    );
    setState(() {
      selectedCountryName = country["name"];
      selectedCountryCode = country["code"];
      selectedCountryFlag = country["flag"];
      phoneError = null;
    });
    context.read<UserFormCubit>().updateCountry(selectedCountryName!);
  }

  bool _validatePhone(String phone) {
    if (selectedCountryCode == null) return false;
    final normalized = phone.replaceAll(' ', '');
    return normalized.startsWith(selectedCountryCode!);
  }

  void _onPhoneChanged(String value) {
    context.read<UserFormCubit>().updatePhone(value);
    setState(() {
      phoneError = null;
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserFormCubit, UserFormState>(
      builder: (context, state) {
        final cubit = context.read<UserFormCubit>();

        return Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(height: 50),
                Center(child: Image.asset(AppImages.logo, height: 100, width: 100)),
                const SizedBox(height: 10),
                const Center(
                  child: Text(
                    AppString.welcomeMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Text(
                  AppString.complateMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 260),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel("الاسم الأول"),
                          _buildTextField(
                            controller: _firstNameController,
                            onChanged: cubit.updateFirstName,
                          ),
                          _buildLabel("الاسم الثاني"),
                          _buildTextField(
                            controller: _lastNameController,
                            onChanged: cubit.updateLastName,
                          ),
                          // _buildLabel("الدولة"),
                          // _buildCountryDropdown(
                          //   value: selectedCountryName,
                          //   items: countryList,
                          //   onChanged: _onCountryChanged,
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
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: state.isValid
                        ? () async{
                      final prefs = await SharedPreferences.getInstance();
                      prefs.setBool('isFormCompleted' , true) ;
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                      );
                    }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      state.isValid ? AppColors.primary : Colors.grey[300],
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('ابدأ غرسك'),
                  ),
                )
              ],
            ),
          ),
        );
      },
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
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
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 6),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required Function(String) onChanged,
  }) {
    return TextField(

      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
      items: items.map((item) {
        return DropdownMenuItem(value: item, child: Text(item));
      }).toList(),
    );
  }
}
