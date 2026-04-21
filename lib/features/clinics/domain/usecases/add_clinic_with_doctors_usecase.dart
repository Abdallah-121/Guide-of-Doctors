import '../../../../core/utils/result.dart';
import '../repositories/clinics_repository.dart';

class AddClinicWithDoctorsUseCase {
  final ClinicsRepository repository;

  AddClinicWithDoctorsUseCase(this.repository);

  Future<Result<void>> call({
    required String name,
    required String governorate,
    required String address,
    required double latitude,
    required double longitude,
    required List<Map<String, String>> doctors,
  }) {
    return repository.addClinicWithDoctors(
      name: name,
      governorate: governorate,
      address: address,
      latitude: latitude,
      longitude: longitude,
      doctors: doctors,
    );
  }
}
