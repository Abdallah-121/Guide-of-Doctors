import '../../../../core/utils/result.dart';
import '../entities/clinic.dart';
import '../repositories/clinics_repository.dart';

class GetClinicsUseCase {
  final ClinicsRepository repository;

  GetClinicsUseCase(this.repository);

  Future<Result<List<Clinic>>> call() => repository.getClinics();
}
