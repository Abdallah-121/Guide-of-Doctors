import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/utils/location_utils.dart';
import '../../../../../core/widgets/app_scaffold.dart';
import '../../../../../core/widgets/state_widgets.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../cubit/home_cubit.dart';
import '../widgets/clinic_card.dart';
import '../widgets/doctor_card.dart';
import '../widgets/search_bar_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<HomeCubit>()..load(),
      child: AppScaffold(
        title: 'دليل أطباء المخابر',
        actions: [
          IconButton(
            onPressed: () => context.read<AuthCubit>().logout(),
            icon: const Icon(Icons.logout),
          ),
        ],
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton.small(
              heroTag: 'addDoctor',
              onPressed: () => context.push('/add-doctor'),
              child: const Icon(Icons.person_add),
            ),
            const SizedBox(height: 8),
            FloatingActionButton(
              heroTag: 'addClinic',
              onPressed: () => context.push('/add-clinic'),
              child: const Icon(Icons.local_hospital),
            ),
          ],
        ),
        body: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) return const LoadingView();
            if (state is HomeError) {
              return ErrorStateView(
                message: state.message,
                onRetry: () => context.read<HomeCubit>().load(),
              );
            }
            if (state is! HomeLoaded) return const SizedBox.shrink();

            final hasItems = state.doctors.isNotEmpty || state.clinics.isNotEmpty;
            return Column(
              children: [
                SearchBarWidget(onChanged: context.read<HomeCubit>().updateQuery),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  children: [
                    ChoiceChip(
                      label: const Text('الكل'),
                      selected: state.filterType == 'all',
                      onSelected: (_) => context.read<HomeCubit>().updateType('all'),
                    ),
                    ChoiceChip(
                      label: const Text('الأطباء'),
                      selected: state.filterType == 'doctor',
                      onSelected: (_) => context.read<HomeCubit>().updateType('doctor'),
                    ),
                    ChoiceChip(
                      label: const Text('العيادات'),
                      selected: state.filterType == 'clinic',
                      onSelected: (_) => context.read<HomeCubit>().updateType('clinic'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: state.governorate,
                  decoration: const InputDecoration(labelText: 'المحافظة'),
                  items: const [
                    DropdownMenuItem(value: 'حلب', child: Text('حلب')),
                    DropdownMenuItem(value: 'دمشق', child: Text('دمشق')),
                    DropdownMenuItem(value: 'حمص', child: Text('حمص')),
                  ],
                  onChanged: (value) => context.read<HomeCubit>().updateGovernorate(value ?? 'حلب'),
                ),
                const SizedBox(height: 8),
                if (!hasItems) const Expanded(child: EmptyStateView(message: 'لا توجد نتائج مطابقة')),
                if (hasItems)
                  Expanded(
                    child: ListView(
                      children: [
                        if (state.filterType != 'clinic')
                          ...state.doctors.map(
                            (e) => DoctorCard(
                              doctor: e,
                              onDetails: () => context.push('/doctor/${e.id}'),
                              onMap: () => openExternalMap(latitude: e.latitude, longitude: e.longitude),
                            ),
                          ),
                        if (state.filterType != 'doctor')
                          ...state.clinics.map(
                            (e) => ClinicCard(
                              clinic: e,
                              onTap: () => context.push('/clinic/${e.id}'),
                            ),
                          ),
                      ],
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
