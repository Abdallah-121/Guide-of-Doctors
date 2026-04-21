import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../../../domain/usecases/add_clinic_with_doctors_usecase.dart';

part 'add_clinic_state.dart';

class AddClinicCubit extends Cubit<AddClinicState> {
  final AddClinicWithDoctorsUseCase addClinicWithDoctorsUseCase;

  AddClinicCubit(this.addClinicWithDoctorsUseCase) : super(AddClinicInitial());

  Future<void> useCurrentLocation() async {
    emit(AddClinicLoading());
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }
    final pos = await Geolocator.getCurrentPosition();
    emit(AddClinicLocationReady(pos.latitude, pos.longitude));
  }

  Future<void> save({
    required String name,
    required String governorate,
    required String address,
    required double latitude,
    required double longitude,
    required List<Map<String, String>> doctors,
  }) async {
    emit(AddClinicLoading());
    final result = await addClinicWithDoctorsUseCase(
      name: name,
      governorate: governorate,
      address: address,
      latitude: latitude,
      longitude: longitude,
      doctors: doctors,
    );
    if (result.isSuccess) {
      emit(AddClinicSuccess());
    } else {
      emit(AddClinicError(result.failure!.message));
    }
  }
}
