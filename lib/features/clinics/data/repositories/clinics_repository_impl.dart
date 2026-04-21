import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/utils/result.dart';
import '../../../doctors/domain/entities/doctor.dart';
import '../../domain/entities/clinic.dart';
import '../../domain/repositories/clinics_repository.dart';
import '../datasources/clinics_remote_data_source.dart';
import '../models/clinic_model.dart';

class ClinicsRepositoryImpl implements ClinicsRepository {
  final ClinicsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ClinicsRepositoryImpl({required this.remoteDataSource, required this.networkInfo});

  @override
  Future<Result<void>> addClinicWithDoctors({
    required String name,
    required String governorate,
    required String address,
    required double latitude,
    required double longitude,
    required List<Map<String, String>> doctors,
  }) async {
    if (!await networkInfo.isConnected) {
      return Result.failure(const NetworkFailure('تحقق من الاتصال بالإنترنت.'));
    }
    try {
      final id = FirebaseFirestore.instance.collection('clinics').doc().id;
      final clinicModel = ClinicModel(
        id: id,
        name: name,
        governorate: governorate,
        address: address,
        latitude: latitude,
        longitude: longitude,
        doctorsCount: doctors.length,
      );
      await remoteDataSource.addClinicWithDoctors(clinic: clinicModel, doctors: doctors);
      return Result.success(null);
    } catch (e) {
      return Result.failure(ServerFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Result<Clinic>> getClinicById(String id) async {
    if (!await networkInfo.isConnected) {
      return Result.failure(const NetworkFailure('تحقق من الاتصال بالإنترنت.'));
    }
    try {
      final clinic = await remoteDataSource.getClinicById(id);
      return Result.success(clinic.toEntity());
    } catch (e) {
      return Result.failure(ServerFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Result<List<Doctor>>> getClinicDoctors(String clinicId) async {
    if (!await networkInfo.isConnected) {
      return Result.failure(const NetworkFailure('تحقق من الاتصال بالإنترنت.'));
    }
    try {
      final doctors = await remoteDataSource.getClinicDoctors(clinicId);
      return Result.success(doctors);
    } catch (e) {
      return Result.failure(ServerFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Result<List<Clinic>>> getClinics() async {
    if (!await networkInfo.isConnected) {
      return Result.failure(const NetworkFailure('تحقق من الاتصال بالإنترنت.'));
    }
    try {
      final clinics = await remoteDataSource.getClinics();
      return Result.success(clinics.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Result.failure(ServerFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }
}
