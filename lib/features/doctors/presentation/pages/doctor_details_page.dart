import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../../core/utils/location_utils.dart';
import '../../../../../core/widgets/app_scaffold.dart';
import '../../../../../core/widgets/map_preview.dart';
import '../../../../../core/widgets/state_widgets.dart';
import '../cubit/doctor_details_cubit.dart';

class DoctorDetailsPage extends StatelessWidget {
  final String doctorId;

  const DoctorDetailsPage({super.key, required this.doctorId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<DoctorDetailsCubit>()..load(doctorId),
      child: AppScaffold(
        title: 'تفاصيل الطبيب',
        body: BlocBuilder<DoctorDetailsCubit, DoctorDetailsState>(
          builder: (context, state) {
            if (state is DoctorDetailsLoading) return const LoadingView();
            if (state is DoctorDetailsError) return ErrorStateView(message: state.message);
            if (state is! DoctorDetailsLoaded) return const SizedBox.shrink();

            final doctor = state.doctor;
            return ListView(
              children: [
                Text(doctor.fullName, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text('الهاتف: ${doctor.phoneNumber}'),
                Text('المحافظة: ${doctor.governorate}'),
                Text('العنوان: ${doctor.address}'),
                if (doctor.clinicId != null) Text('المعرف العيادي: ${doctor.clinicId}'),
                const SizedBox(height: 12),
                MapPreview(latitude: doctor.latitude, longitude: doctor.longitude),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: () => openExternalMap(latitude: doctor.latitude, longitude: doctor.longitude),
                  icon: const Icon(Icons.map),
                  label: const Text('فتح في الخرائط'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
