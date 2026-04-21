import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/clinics/presentation/cubit/add_clinic_cubit.dart';
import '../../features/clinics/presentation/pages/add_clinic_page.dart';
import '../../features/clinics/presentation/pages/clinic_details_page.dart';
import '../../features/doctors/presentation/cubit/add_doctor_cubit.dart';
import '../../features/doctors/presentation/pages/add_doctor_page.dart';
import '../../features/doctors/presentation/pages/doctor_details_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import 'router_refresh_notifier.dart';

class AppRouter {
  static final getIt = GetIt.I;
  static final authCubit = getIt<AuthCubit>();

  static final router = GoRouter(
    initialLocation: '/',
    refreshListenable: RouterRefreshNotifier(authCubit.stream),
    redirect: (context, state) {
      final isAuth = authCubit.state is Authenticated;
      final isLogin = state.uri.path == '/login';
      if (!isAuth && !isLogin) return '/login';
      if (isAuth && isLogin) return '/';
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
      GoRoute(path: '/', builder: (_, __) => const HomePage()),
      GoRoute(
        path: '/add-doctor',
        builder: (_, __) => BlocProvider(create: (_) => getIt<AddDoctorCubit>(), child: const AddDoctorPage()),
      ),
      GoRoute(
        path: '/add-clinic',
        builder: (_, __) => BlocProvider(create: (_) => getIt<AddClinicCubit>(), child: const AddClinicPage()),
      ),
      GoRoute(
        path: '/doctor/:id',
        builder: (_, state) => DoctorDetailsPage(doctorId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/clinic/:id',
        builder: (_, state) => ClinicDetailsPage(clinicId: state.pathParameters['id']!),
      ),
    ],
  );
}
