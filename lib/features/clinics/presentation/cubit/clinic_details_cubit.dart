import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../doctors/domain/entities/doctor.dart';
import '../../domain/entities/clinic.dart';
import '../../domain/usecases/get_clinic_by_id_usecase.dart';
import '../../domain/usecases/get_clinic_doctors_usecase.dart';

part 'clinic_details_state.dart';

class ClinicDetailsCubit extends Cubit<ClinicDetailsState> {
  final GetClinicByIdUseCase getClinicByIdUseCase;
  final GetClinicDoctorsUseCase getClinicDoctorsUseCase;

  ClinicDetailsCubit({required this.getClinicByIdUseCase, required this.getClinicDoctorsUseCase})
      : super(ClinicDetailsInitial());

  Future<void> load(String clinicId) async {
    emit(ClinicDetailsLoading());
    final clinicResult = await getClinicByIdUseCase(clinicId);
    if (!clinicResult.isSuccess) {
      emit(ClinicDetailsError(clinicResult.failure!.message));
      return;
    }

    final doctorsResult = await getClinicDoctorsUseCase(clinicId);
    if (!doctorsResult.isSuccess) {
      emit(ClinicDetailsError(doctorsResult.failure!.message));
      return;
    }

    emit(ClinicDetailsLoaded(clinicResult.data!, doctorsResult.data!));
  }
}
