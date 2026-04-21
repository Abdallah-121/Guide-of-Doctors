part of 'home_cubit.dart';

abstract class HomeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeError extends HomeState {
  final String message;

  HomeError(this.message);

  @override
  List<Object?> get props => [message];
}

class HomeLoaded extends HomeState {
  final List<Doctor> allDoctors;
  final List<Clinic> allClinics;
  final List<Doctor> doctors;
  final List<Clinic> clinics;
  final String filterType;
  final String governorate;
  final String query;

  HomeLoaded({
    required this.allDoctors,
    required this.allClinics,
    required this.doctors,
    required this.clinics,
    required this.filterType,
    required this.governorate,
    required this.query,
  });

  HomeLoaded copyWith({
    List<Doctor>? allDoctors,
    List<Clinic>? allClinics,
    List<Doctor>? doctors,
    List<Clinic>? clinics,
    String? filterType,
    String? governorate,
    String? query,
  }) {
    return HomeLoaded(
      allDoctors: allDoctors ?? this.allDoctors,
      allClinics: allClinics ?? this.allClinics,
      doctors: doctors ?? this.doctors,
      clinics: clinics ?? this.clinics,
      filterType: filterType ?? this.filterType,
      governorate: governorate ?? this.governorate,
      query: query ?? this.query,
    );
  }

  @override
  List<Object?> get props => [allDoctors, allClinics, doctors, clinics, filterType, governorate, query];
}
