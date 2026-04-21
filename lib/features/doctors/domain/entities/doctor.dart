import 'package:equatable/equatable.dart';

class Doctor extends Equatable {
  final String id;
  final String fullName;
  final String phoneNumber;
  final String governorate;
  final String address;
  final double latitude;
  final double longitude;
  final String? clinicId;

  const Doctor({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.governorate,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.clinicId,
  });

  @override
  List<Object?> get props => [id, fullName, phoneNumber, governorate, address, latitude, longitude, clinicId];
}
