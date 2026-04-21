import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/clinics/data/datasources/clinics_remote_data_source.dart';
import '../../features/clinics/data/repositories/clinics_repository_impl.dart';
import '../../features/clinics/domain/repositories/clinics_repository.dart';
import '../../features/clinics/domain/usecases/add_clinic_with_doctors_usecase.dart';
import '../../features/clinics/domain/usecases/get_clinic_by_id_usecase.dart';
import '../../features/clinics/domain/usecases/get_clinic_doctors_usecase.dart';
import '../../features/clinics/domain/usecases/get_clinics_usecase.dart';
import '../../features/clinics/presentation/cubit/add_clinic_cubit.dart';
import '../../features/clinics/presentation/cubit/clinic_details_cubit.dart';
import '../../features/doctors/data/datasources/doctors_remote_data_source.dart';
import '../../features/doctors/data/repositories/doctors_repository_impl.dart';
import '../../features/doctors/domain/repositories/doctors_repository.dart';
import '../../features/doctors/domain/usecases/add_doctor_usecase.dart';
import '../../features/doctors/domain/usecases/get_doctor_by_id_usecase.dart';
import '../../features/doctors/domain/usecases/get_doctors_usecase.dart';
import '../../features/doctors/presentation/cubit/add_doctor_cubit.dart';
import '../../features/doctors/presentation/cubit/doctor_details_cubit.dart';
import '../../features/home/domain/usecases/get_home_data_usecase.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';
import '../network/network_info.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(Connectivity.new);

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<DoctorsRemoteDataSource>(() => DoctorsRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<ClinicsRemoteDataSource>(() => ClinicsRemoteDataSourceImpl(sl()));

  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()));
  sl.registerLazySingleton<DoctorsRepository>(() => DoctorsRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()));
  sl.registerLazySingleton<ClinicsRepository>(() => ClinicsRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()));

  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => GetDoctorsUseCase(sl()));
  sl.registerLazySingleton(() => GetDoctorByIdUseCase(sl()));
  sl.registerLazySingleton(() => AddDoctorUseCase(sl()));
  sl.registerLazySingleton(() => GetClinicsUseCase(sl()));
  sl.registerLazySingleton(() => GetClinicByIdUseCase(sl()));
  sl.registerLazySingleton(() => GetClinicDoctorsUseCase(sl()));
  sl.registerLazySingleton(() => AddClinicWithDoctorsUseCase(sl()));
  sl.registerLazySingleton(() => GetHomeDataUseCase(doctorsRepository: sl(), clinicsRepository: sl()));

  sl.registerLazySingleton(
    () => AuthCubit(
      loginUseCase: sl(),
      logoutUseCase: sl(),
      getCurrentUserUseCase: sl(),
    ),
  );
  sl.registerFactory(() => HomeCubit(sl()));
  sl.registerFactory(() => AddDoctorCubit(sl()));
  sl.registerFactory(() => DoctorDetailsCubit(sl()));
  sl.registerFactory(() => AddClinicCubit(sl()));
  sl.registerFactory(() => ClinicDetailsCubit(getClinicByIdUseCase: sl(), getClinicDoctorsUseCase: sl()));
}
