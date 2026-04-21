import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/clinic.dart';

class ClinicModel {
  final String id;
  final String name;
  final String governorate;
  final String address;
  final double latitude;
  final double longitude;
  final int doctorsCount;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;

  const ClinicModel({
    required this.id,
    required this.name,
    required this.governorate,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.doctorsCount,
    this.createdAt,
    this.updatedAt,
  });

  factory ClinicModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final json = doc.data() ?? {};
    return ClinicModel(
      id: doc.id,
      name: json['name'] ?? '',
      governorate: json['governorate'] ?? '',
      address: json['address'] ?? '',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      doctorsCount: json['doctorsCount'] ?? 0,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'governorate': governorate,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'doctorsCount': doctorsCount,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  Clinic toEntity() => Clinic(
        id: id,
        name: name,
        governorate: governorate,
        address: address,
        latitude: latitude,
        longitude: longitude,
        doctorsCount: doctorsCount,
      );
}
