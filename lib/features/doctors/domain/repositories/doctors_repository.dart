import '../../../../core/utils/result.dart';
import '../entities/doctor.dart';

abstract class DoctorsRepository {
  Future<Result<List<Doctor>>> getDoctors();
  Future<Result<Doctor>> getDoctorById(String id);
  Future<Result<void>> addDoctor({
    required String fullName,
    required String phoneNumber,
    required String governorate,
    required String address,
    required double latitude,
    required double longitude,
    String? clinicId,
  });
  Future<Result<List<Doctor>>> getDoctorsByClinicId(String clinicId);
}
