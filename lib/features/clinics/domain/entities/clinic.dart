import 'package:equatable/equatable.dart';

class Clinic extends Equatable {
  final String id;
  final String name;
  final String governorate;
  final String address;
  final double latitude;
  final double longitude;
  final int doctorsCount;

  const Clinic({
    required this.id,
    required this.name,
    required this.governorate,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.doctorsCount,
  });

  @override
  List<Object?> get props => [id, name, governorate, address, latitude, longitude, doctorsCount];
}
