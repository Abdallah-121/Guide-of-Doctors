import '../../../../core/utils/result.dart';
import '../entities/doctor.dart';
import '../repositories/doctors_repository.dart';

class GetDoctorsUseCase {
  final DoctorsRepository repository;

  GetDoctorsUseCase(this.repository);

  Future<Result<List<Doctor>>> call() => repository.getDoctors();
}
