part of 'clinic_details_cubit.dart';

abstract class ClinicDetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ClinicDetailsInitial extends ClinicDetailsState {}

class ClinicDetailsLoading extends ClinicDetailsState {}

class ClinicDetailsLoaded extends ClinicDetailsState {
  final Clinic clinic;
  final List<Doctor> doctors;

  ClinicDetailsLoaded(this.clinic, this.doctors);

  @override
  List<Object?> get props => [clinic, doctors];
}

class ClinicDetailsError extends ClinicDetailsState {
  final String message;

  ClinicDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
