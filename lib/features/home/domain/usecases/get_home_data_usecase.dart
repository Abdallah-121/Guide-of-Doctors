import '../../../../core/utils/result.dart';
import '../../../clinics/domain/entities/clinic.dart';
import '../../../clinics/domain/repositories/clinics_repository.dart';
import '../../../doctors/domain/entities/doctor.dart';
import '../../../doctors/domain/repositories/doctors_repository.dart';

class HomeData {
  final List<Doctor> doctors;
  final List<Clinic> clinics;

  HomeData({required this.doctors, required this.clinics});
}

class GetHomeDataUseCase {
  final DoctorsRepository doctorsRepository;
  final ClinicsRepository clinicsRepository;

  GetHomeDataUseCase({required this.doctorsRepository, required this.clinicsRepository});

  Future<Result<HomeData>> call() async {
    final doctorsResult = await doctorsRepository.getDoctors();
    if (!doctorsResult.isSuccess) return Result.failure(doctorsResult.failure!);

    final clinicsResult = await clinicsRepository.getClinics();
    if (!clinicsResult.isSuccess) return Result.failure(clinicsResult.failure!);

    return Result.success(HomeData(doctors: doctorsResult.data!, clinics: clinicsResult.data!));
  }
}
