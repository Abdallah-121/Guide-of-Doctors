import '../../../../core/utils/result.dart';
import '../entities/doctor.dart';
import '../repositories/doctors_repository.dart';

class GetDoctorByIdUseCase {
  final DoctorsRepository repository;

  GetDoctorByIdUseCase(this.repository);

  Future<Result<Doctor>> call(String id) => repository.getDoctorById(id);
}
