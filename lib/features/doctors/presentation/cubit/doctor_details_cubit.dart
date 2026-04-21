import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/doctor.dart';
import '../../../domain/usecases/get_doctor_by_id_usecase.dart';

part 'doctor_details_state.dart';

class DoctorDetailsCubit extends Cubit<DoctorDetailsState> {
  final GetDoctorByIdUseCase getDoctorByIdUseCase;

  DoctorDetailsCubit(this.getDoctorByIdUseCase) : super(DoctorDetailsInitial());

  Future<void> load(String id) async {
    emit(DoctorDetailsLoading());
    final result = await getDoctorByIdUseCase(id);
    if (result.isSuccess) {
      emit(DoctorDetailsLoaded(result.data!));
    } else {
      emit(DoctorDetailsError(result.failure!.message));
    }
  }
}
