import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../doctors/data/models/doctor_model.dart';
import '../../../doctors/domain/entities/doctor.dart';
import '../models/clinic_model.dart';

abstract class ClinicsRemoteDataSource {
  Future<List<ClinicModel>> getClinics();
  Future<ClinicModel> getClinicById(String id);
  Future<void> addClinicWithDoctors({
    required ClinicModel clinic,
    required List<Map<String, String>> doctors,
  });
  Future<List<Doctor>> getClinicDoctors(String clinicId);
}

class ClinicsRemoteDataSourceImpl implements ClinicsRemoteDataSource {
  final FirebaseFirestore firestore;

  ClinicsRemoteDataSourceImpl(this.firestore);

  CollectionReference<Map<String, dynamic>> get _clinics => firestore.collection('clinics');
  CollectionReference<Map<String, dynamic>> get _doctors => firestore.collection('doctors');

  @override
  Future<void> addClinicWithDoctors({
    required ClinicModel clinic,
    required List<Map<String, String>> doctors,
  }) async {
    try {
      final batch = firestore.batch();
      final clinicDoc = _clinics.doc(clinic.id);
      batch.set(clinicDoc, clinic.toFirestore());

      for (final doctor in doctors) {
        final doctorDoc = _doctors.doc();
        final doctorModel = DoctorModel(
          id: doctorDoc.id,
          fullName: doctor['fullName']!,
          phoneNumber: doctor['phoneNumber']!,
          governorate: clinic.governorate,
          address: clinic.address,
          latitude: clinic.latitude,
          longitude: clinic.longitude,
          clinicId: clinic.id,
        );
        batch.set(doctorDoc, doctorModel.toFirestore());
      }

      await batch.commit();
    } catch (_) {
      throw ServerException('تعذر حفظ العيادة والأطباء.');
    }
  }

  @override
  Future<ClinicModel> getClinicById(String id) async {
    try {
      final doc = await _clinics.doc(id).get();
      if (!doc.exists) throw ServerException('العيادة غير موجودة.');
      return ClinicModel.fromFirestore(doc);
    } catch (_) {
      throw ServerException('تعذر جلب تفاصيل العيادة.');
    }
  }

  @override
  Future<List<ClinicModel>> getClinics() async {
    try {
      final query = await _clinics.orderBy('name').get();
      return query.docs.map(ClinicModel.fromFirestore).toList();
    } catch (_) {
      throw ServerException('تعذر جلب العيادات.');
    }
  }

  @override
  Future<List<Doctor>> getClinicDoctors(String clinicId) async {
    try {
      final query = await _doctors.where('clinicId', isEqualTo: clinicId).orderBy('fullName').get();
      return query.docs.map((e) => DoctorModel.fromFirestore(e).toEntity()).toList();
    } catch (_) {
      throw ServerException('تعذر جلب أطباء العيادة.');
    }
  }
}
