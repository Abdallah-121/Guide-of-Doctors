import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../../../domain/usecases/add_doctor_usecase.dart';

part 'add_doctor_state.dart';

class AddDoctorCubit extends Cubit<AddDoctorState> {
  final AddDoctorUseCase addDoctorUseCase;

  AddDoctorCubit(this.addDoctorUseCase) : super(AddDoctorInitial());

  Future<void> useCurrentLocation() async {
    emit(AddDoctorLoading());
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }
    final pos = await Geolocator.getCurrentPosition();
    emit(AddDoctorLocationReady(pos.latitude, pos.longitude));
  }

  Future<void> save({
    required String fullName,
    required String phone,
    required String governorate,
    required String address,
    required double latitude,
    required double longitude,
    String? clinicId,
  }) async {
    emit(AddDoctorLoading());
    final result = await addDoctorUseCase(
      fullName: fullName,
      phoneNumber: phone,
      governorate: governorate,
      address: address,
      latitude: latitude,
      longitude: longitude,
      clinicId: clinicId,
    );
    if (result.isSuccess) {
      emit(AddDoctorSuccess());
    } else {
      emit(AddDoctorError(result.failure!.message));
    }
  }
}
