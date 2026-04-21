import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../clinics/domain/entities/clinic.dart';
import '../../../doctors/domain/entities/doctor.dart';
import '../../domain/usecases/get_home_data_usecase.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetHomeDataUseCase getHomeDataUseCase;

  HomeCubit(this.getHomeDataUseCase) : super(HomeInitial());

  String _query = '';
  String _typeFilter = 'all';
  String _governorate = 'حلب';

  Future<void> load() async {
    emit(HomeLoading());
    final result = await getHomeDataUseCase();
    if (!result.isSuccess) {
      emit(HomeError(result.failure!.message));
      return;
    }
    emit(HomeLoaded(
      allDoctors: result.data!.doctors,
      allClinics: result.data!.clinics,
      doctors: _filterDoctors(result.data!.doctors),
      clinics: _filterClinics(result.data!.clinics),
      filterType: _typeFilter,
      governorate: _governorate,
      query: _query,
    ));
  }

  void updateQuery(String query) => _applyFilters(query: query);

  void updateType(String type) => _applyFilters(type: type);

  void updateGovernorate(String governorate) => _applyFilters(governorate: governorate);

  void _applyFilters({String? query, String? type, String? governorate}) {
    final current = state;
    if (current is! HomeLoaded) return;
    _query = query ?? _query;
    _typeFilter = type ?? _typeFilter;
    _governorate = governorate ?? _governorate;

    emit(current.copyWith(
      query: _query,
      filterType: _typeFilter,
      governorate: _governorate,
      doctors: _filterDoctors(current.allDoctors),
      clinics: _filterClinics(current.allClinics),
    ));
  }

  List<Doctor> _filterDoctors(List<Doctor> list) {
    return list.where((e) {
      final matchQuery = _query.isEmpty || e.fullName.toLowerCase().contains(_query.toLowerCase());
      final matchGov = _governorate.isEmpty || e.governorate == _governorate;
      return matchQuery && matchGov;
    }).toList();
  }

  List<Clinic> _filterClinics(List<Clinic> list) {
    return list.where((e) {
      final matchQuery = _query.isEmpty || e.name.toLowerCase().contains(_query.toLowerCase());
      final matchGov = _governorate.isEmpty || e.governorate == _governorate;
      return matchQuery && matchGov;
    }).toList();
  }
}
