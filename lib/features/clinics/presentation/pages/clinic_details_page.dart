import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/utils/location_utils.dart';
import '../../../../../core/widgets/app_scaffold.dart';
import '../../../../../core/widgets/map_preview.dart';
import '../../../../../core/widgets/state_widgets.dart';
import '../cubit/clinic_details_cubit.dart';

class ClinicDetailsPage extends StatelessWidget {
  final String clinicId;

  const ClinicDetailsPage({super.key, required this.clinicId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<ClinicDetailsCubit>()..load(clinicId),
      child: AppScaffold(
        title: 'تفاصيل العيادة',
        body: BlocBuilder<ClinicDetailsCubit, ClinicDetailsState>(
          builder: (context, state) {
            if (state is ClinicDetailsLoading) return const LoadingView();
            if (state is ClinicDetailsError) return ErrorStateView(message: state.message);
            if (state is! ClinicDetailsLoaded) return const SizedBox.shrink();

            return ListView(
              children: [
                Text(state.clinic.name, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text('المحافظة: ${state.clinic.governorate}'),
                Text('العنوان: ${state.clinic.address}'),
                const SizedBox(height: 12),
                MapPreview(latitude: state.clinic.latitude, longitude: state.clinic.longitude),
                const SizedBox(height: 8),
                FilledButton.icon(
                  onPressed: () => openExternalMap(
                    latitude: state.clinic.latitude,
                    longitude: state.clinic.longitude,
                  ),
                  icon: const Icon(Icons.map),
                  label: const Text('فتح في الخرائط'),
                ),
                const SizedBox(height: 12),
                Text('أطباء العيادة', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                ...state.doctors.map(
                  (doctor) => Card(
                    child: ListTile(
                      title: Text(doctor.fullName),
                      subtitle: Text(doctor.phoneNumber),
                      onTap: () => context.push('/doctor/${doctor.id}'),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
