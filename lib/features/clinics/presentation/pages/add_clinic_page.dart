import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/widgets/app_scaffold.dart';
import '../../../../../core/widgets/app_text_field.dart';
import '../../../../../core/widgets/map_picker_page.dart';
import '../../../../../core/widgets/map_preview.dart';
import '../cubit/add_clinic_cubit.dart';

class AddClinicPage extends StatefulWidget {
  const AddClinicPage({super.key});

  @override
  State<AddClinicPage> createState() => _AddClinicPageState();
}

class _AddClinicPageState extends State<AddClinicPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _governorate = TextEditingController(text: AppStrings.defaultGovernorate);
  final _address = TextEditingController();
  final List<TextEditingController> doctorNames = [TextEditingController()];
  final List<TextEditingController> doctorPhones = [TextEditingController()];
  double? lat;
  double? lng;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddClinicCubit, AddClinicState>(
      listener: (context, state) {
        if (state is AddClinicLocationReady) {
          lat = state.latitude;
          lng = state.longitude;
          setState(() {});
        }
        if (state is AddClinicSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم حفظ العيادة بنجاح')));
          context.pop();
        }
        if (state is AddClinicError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        return AppScaffold(
          title: 'إضافة عيادة',
          body: Form(
            key: _formKey,
            child: ListView(
              children: [
                AppTextField(controller: _name, label: 'اسم العيادة', validator: _required),
                const SizedBox(height: 10),
                AppTextField(controller: _governorate, label: 'المحافظة', validator: _required),
                const SizedBox(height: 10),
                AppTextField(controller: _address, label: 'العنوان التفصيلي', validator: _required, maxLines: 2),
                const SizedBox(height: 12),
                if (lat != null && lng != null) MapPreview(latitude: lat!, longitude: lng!),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => context.read<AddClinicCubit>().useCurrentLocation(),
                        child: const Text('موقعي الحالي'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
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
                        child: const Text('اختيار يدوي'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text('أطباء العيادة', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                ...List.generate(doctorNames.length, (i) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          AppTextField(controller: doctorNames[i], label: 'الاسم الثلاثي للطبيب', validator: _required),
                          const SizedBox(height: 8),
                          AppTextField(
                            controller: doctorPhones[i],
                            label: 'رقم الهاتف',
                            validator: _required,
                            keyboardType: TextInputType.phone,
                          ),
                          if (doctorNames.length > 1)
                            Align(
                              alignment: Alignment.centerLeft,
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    doctorNames.removeAt(i);
                                    doctorPhones.removeAt(i);
                                  });
                                },
                                icon: const Icon(Icons.delete_outline),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }),
                OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      doctorNames.add(TextEditingController());
                      doctorPhones.add(TextEditingController());
                    });
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('إضافة طبيب آخر'),
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: state is AddClinicLoading
                      ? null
                      : () {
                          if (_formKey.currentState!.validate() && lat != null && lng != null) {
                            final doctors = List.generate(
                              doctorNames.length,
                              (index) => {
                                'fullName': doctorNames[index].text,
                                'phoneNumber': doctorPhones[index].text,
                              },
                            );
                            context.read<AddClinicCubit>().save(
                                  name: _name.text,
                                  governorate: _governorate.text,
                                  address: _address.text,
                                  latitude: lat!,
                                  longitude: lng!,
                                  doctors: doctors,
                                );
                          }
                        },
                  child: const Text('حفظ العيادة والأطباء'),
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
