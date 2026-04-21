part of 'doctor_details_cubit.dart';

abstract class DoctorDetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DoctorDetailsInitial extends DoctorDetailsState {}

class DoctorDetailsLoading extends DoctorDetailsState {}

class DoctorDetailsLoaded extends DoctorDetailsState {
  final Doctor doctor;

  DoctorDetailsLoaded(this.doctor);

  @override
  List<Object?> get props => [doctor];
}

class DoctorDetailsError extends DoctorDetailsState {
  final String message;

  DoctorDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
