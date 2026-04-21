import '../../../../core/utils/result.dart';
import '../entities/clinic.dart';
import '../repositories/clinics_repository.dart';

class GetClinicByIdUseCase {
  final ClinicsRepository repository;

  GetClinicByIdUseCase(this.repository);

  Future<Result<Clinic>> call(String id) => repository.getClinicById(id);
}
