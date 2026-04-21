import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';

class DentalLabApp extends StatelessWidget {
  const DentalLabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AppRouter.authCubit..checkAuthStatus(),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'دليل الأطباء',
        theme: AppTheme.lightTheme,
        locale: const Locale('ar'),
        supportedLocales: const [Locale('ar')],
        builder: (context, child) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: child ?? const SizedBox.shrink(),
          );
        },
        routerConfig: AppRouter.router,
      ),
    );
  }
}
