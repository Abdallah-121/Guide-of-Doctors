part of 'add_doctor_cubit.dart';

abstract class AddDoctorState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddDoctorInitial extends AddDoctorState {}

class AddDoctorLoading extends AddDoctorState {}

class AddDoctorSuccess extends AddDoctorState {}

class AddDoctorError extends AddDoctorState {
  final String message;

  AddDoctorError(this.message);

  @override
  List<Object?> get props => [message];
}

class AddDoctorLocationReady extends AddDoctorState {
  final double latitude;
  final double longitude;

  AddDoctorLocationReady(this.latitude, this.longitude);

  @override
  List<Object?> get props => [latitude, longitude];
}
