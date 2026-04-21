import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/widgets/app_scaffold.dart';
import '../../../../../core/widgets/app_text_field.dart';
import '../../../../../core/widgets/map_picker_page.dart';
import '../../../../../core/widgets/map_preview.dart';
import '../cubit/add_doctor_cubit.dart';

class AddDoctorPage extends StatefulWidget {
  const AddDoctorPage({super.key});

  @override
  State<AddDoctorPage> createState() => _AddDoctorPageState();
}

class _AddDoctorPageState extends State<AddDoctorPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _governorate = TextEditingController(text: AppStrings.defaultGovernorate);
  final _address = TextEditingController();
  double? lat;
  double? lng;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddDoctorCubit, AddDoctorState>(
      listener: (context, state) {
        if (state is AddDoctorLocationReady) {
          lat = state.latitude;
          lng = state.longitude;
          setState(() {});
        }
        if (state is AddDoctorSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم حفظ الطبيب بنجاح')));
          context.pop();
        }
        if (state is AddDoctorError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        return AppScaffold(
          title: 'إضافة طبيب',
          body: Form(
            key: _formKey,
            child: ListView(
              children: [
                AppTextField(controller: _name, label: 'الاسم الثلاثي', validator: _required),
                const SizedBox(height: 10),
                AppTextField(controller: _phone, label: 'رقم الهاتف', validator: _required, keyboardType: TextInputType.phone),
                const SizedBox(height: 10),
                AppTextField(controller: _governorate, label: 'المحافظة', validator: _required),
                const SizedBox(height: 10),
                AppTextField(controller: _address, label: 'العنوان التفصيلي', validator: _required, maxLines: 2),
                const SizedBox(height: 12),
                if (lat != null && lng != null) MapPreview(latitude: lat!, longitude: lng!),
                if (lat == null || lng == null)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text('يرجى تحديد الموقع (خط العرض/الطول).'),
                  ),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => context.read<AddDoctorCubit>().useCurrentLocation(),
                        icon: const Icon(Icons.my_location),
                        label: const Text('موقعي الحالي'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final picked = await Navigator.push<LatLng>(
                            context,
                            MaterialPageRoute(builder: (_) => MapPickerPage(initialLat: lat, initialLng: lng)),
                          );
                          if (picked != null) {
                            lat = picked.latitude;
                            lng = picked.longitude;
                            setState(() {});
                          }
                        },
                        icon: const Icon(Icons.map),
                        label: const Text('اختيار يدوي'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: state is AddDoctorLoading
                      ? null
                      : () {
                          if (_formKey.currentState!.validate() && lat != null && lng != null) {
                            context.read<AddDoctorCubit>().save(
                                  fullName: _name.text,
                                  phone: _phone.text,
                                  governorate: _governorate.text,
                                  address: _address.text,
                                  latitude: lat!,
                                  longitude: lng!,
                                );
                          }
                        },
                  child: const Text('حفظ'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String? _required(String? value) => (value == null || value.trim().isEmpty) ? 'هذا الحقل مطلوب' : null;
}
