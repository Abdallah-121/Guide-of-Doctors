import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/doctor.dart';

class DoctorModel {
  final String id;
  final String fullName;
  final String phoneNumber;
  final String governorate;
  final String address;
  final double latitude;
  final double longitude;
  final String? clinicId;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;

  const DoctorModel({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.governorate,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.clinicId,
    this.createdAt,
    this.updatedAt,
  });

  factory DoctorModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final json = doc.data() ?? {};
    return DoctorModel(
      id: doc.id,
      fullName: json['fullName'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      governorate: json['governorate'] ?? '',
      address: json['address'] ?? '',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      clinicId: json['clinicId'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'governorate': governorate,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'clinicId': clinicId,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  Doctor toEntity() => Doctor(
        id: id,
        fullName: fullName,
        phoneNumber: phoneNumber,
        governorate: governorate,
        address: address,
        latitude: latitude,
        longitude: longitude,
        clinicId: clinicId,
      );
}
