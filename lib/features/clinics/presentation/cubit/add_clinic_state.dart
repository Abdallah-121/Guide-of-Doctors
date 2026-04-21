part of 'add_clinic_cubit.dart';

abstract class AddClinicState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddClinicInitial extends AddClinicState {}

class AddClinicLoading extends AddClinicState {}

class AddClinicSuccess extends AddClinicState {}

class AddClinicError extends AddClinicState {
  final String message;

  AddClinicError(this.message);

  @override
  List<Object?> get props => [message];
}

class AddClinicLocationReady extends AddClinicState {
  final double latitude;
  final double longitude;

  AddClinicLocationReady(this.latitude, this.longitude);

  @override
  List<Object?> get props => [latitude, longitude];
}
