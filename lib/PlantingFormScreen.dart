import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Form/presentation/bloc/user_form_cubit.dart';
import 'core/unit/color/colors.dart';
import 'core/unit/images.dart';
import 'core/unit/string/string.dart';
import 'home/home_screen.dart';
// Replace with your constants (e.g., AppColors, AppImages, AppString)

class PlantingFormScreen extends StatefulWidget {
  const PlantingFormScreen({super.key});

  @override
  State<PlantingFormScreen> createState() => _PlantingFormScreenState();
}

class _PlantingFormScreenState extends State<PlantingFormScreen> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;

  final genderItems = ["ذكر", "أنثى"];

  String? selectedCountryName;
  String? phoneError;

  @override
  void initState() {
    super.initState();
    final state = context
        .read<UserFormCubit>()
        .state;
    _firstNameController = TextEditingController(text: state.firstName);
    _lastNameController = TextEditingController(text: state.lastName);
  }
  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
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
                        ? () {
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
                    child: const Text('ابدأ غرسك' ,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
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
