import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/doctor.dart';
import '../../domain/repositories/doctors_repository.dart';
import '../datasources/doctors_remote_data_source.dart';
import '../models/doctor_model.dart';

class DoctorsRepositoryImpl implements DoctorsRepository {
  final DoctorsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  DoctorsRepositoryImpl({required this.remoteDataSource, required this.networkInfo});

  @override
  Future<Result<void>> addDoctor({
    required String fullName,
    required String phoneNumber,
    required String governorate,
    required String address,
    required double latitude,
    required double longitude,
    String? clinicId,
  }) async {
    if (!await networkInfo.isConnected) {
      return Result.failure(const NetworkFailure('تحقق من الاتصال بالإنترنت.'));
    }
    try {
      final id = FirebaseFirestore.instance.collection('doctors').doc().id;
      final model = DoctorModel(
        id: id,
        fullName: fullName,
        phoneNumber: phoneNumber,
        governorate: governorate,
        address: address,
        latitude: latitude,
        longitude: longitude,
        clinicId: clinicId,
      );
      await remoteDataSource.addDoctor(model);
      return Result.success(null);
    } catch (e) {
      return Result.failure(ServerFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Result<Doctor>> getDoctorById(String id) async {
    if (!await networkInfo.isConnected) {
      return Result.failure(const NetworkFailure('تحقق من الاتصال بالإنترنت.'));
    }
    try {
      final doctor = await remoteDataSource.getDoctorById(id);
      return Result.success(doctor.toEntity());
    } catch (e) {
      return Result.failure(ServerFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Result<List<Doctor>>> getDoctors() async {
    if (!await networkInfo.isConnected) {
      return Result.failure(const NetworkFailure('تحقق من الاتصال بالإنترنت.'));
    }
    try {
      final doctors = await remoteDataSource.getDoctors();
      return Result.success(doctors.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Result.failure(ServerFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Result<List<Doctor>>> getDoctorsByClinicId(String clinicId) async {
    if (!await networkInfo.isConnected) {
      return Result.failure(const NetworkFailure('تحقق من الاتصال بالإنترنت.'));
    }
    try {
      final doctors = await remoteDataSource.getDoctorsByClinicId(clinicId);
      return Result.success(doctors.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Result.failure(ServerFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }
}
