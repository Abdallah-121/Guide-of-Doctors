import '../../../../core/utils/result.dart';
import '../../../doctors/domain/entities/doctor.dart';
import '../repositories/clinics_repository.dart';

class GetClinicDoctorsUseCase {
  final ClinicsRepository repository;

  GetClinicDoctorsUseCase(this.repository);

  Future<Result<List<Doctor>>> call(String clinicId) => repository.getClinicDoctors(clinicId);
}
