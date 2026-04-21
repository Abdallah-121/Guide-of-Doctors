import '../../../../core/utils/result.dart';
import '../../../doctors/domain/entities/doctor.dart';
import '../entities/clinic.dart';

abstract class ClinicsRepository {
  Future<Result<List<Clinic>>> getClinics();
  Future<Result<Clinic>> getClinicById(String id);
  Future<Result<void>> addClinicWithDoctors({
    required String name,
    required String governorate,
    required String address,
    required double latitude,
    required double longitude,
    required List<Map<String, String>> doctors,
  });
  Future<Result<List<Doctor>>> getClinicDoctors(String clinicId);
}
