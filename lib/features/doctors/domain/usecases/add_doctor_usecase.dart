import '../../../../core/utils/result.dart';
import '../repositories/doctors_repository.dart';

class AddDoctorUseCase {
  final DoctorsRepository repository;

  AddDoctorUseCase(this.repository);

  Future<Result<void>> call({
    required String fullName,
    required String phoneNumber,
    required String governorate,
    required String address,
    required double latitude,
    required double longitude,
    String? clinicId,
  }) {
    return repository.addDoctor(
      fullName: fullName,
      phoneNumber: phoneNumber,
      governorate: governorate,
      address: address,
      latitude: latitude,
      longitude: longitude,
      clinicId: clinicId,
    );
  }
}
