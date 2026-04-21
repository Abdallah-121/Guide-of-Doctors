import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/doctor_model.dart';

abstract class DoctorsRemoteDataSource {
  Future<List<DoctorModel>> getDoctors();
  Future<DoctorModel> getDoctorById(String id);
  Future<void> addDoctor(DoctorModel model);
  Future<List<DoctorModel>> getDoctorsByClinicId(String clinicId);
}

class DoctorsRemoteDataSourceImpl implements DoctorsRemoteDataSource {
  final FirebaseFirestore firestore;

  DoctorsRemoteDataSourceImpl(this.firestore);

  CollectionReference<Map<String, dynamic>> get _doctors => firestore.collection('doctors');

  @override
  Future<void> addDoctor(DoctorModel model) async {
    try {
      await _doctors.doc(model.id).set(model.toFirestore());
    } catch (_) {
      throw ServerException('تعذر حفظ الطبيب.');
    }
  }

  @override
  Future<DoctorModel> getDoctorById(String id) async {
    try {
      final doc = await _doctors.doc(id).get();
      if (!doc.exists) throw ServerException('الطبيب غير موجود.');
      return DoctorModel.fromFirestore(doc);
    } catch (_) {
      throw ServerException('تعذر جلب تفاصيل الطبيب.');
    }
  }

  @override
  Future<List<DoctorModel>> getDoctors() async {
    try {
      final query = await _doctors.orderBy('fullName').get();
      return query.docs.map(DoctorModel.fromFirestore).toList();
    } catch (_) {
      throw ServerException('تعذر جلب الأطباء.');
    }
  }

  @override
  Future<List<DoctorModel>> getDoctorsByClinicId(String clinicId) async {
    try {
      final query = await _doctors.where('clinicId', isEqualTo: clinicId).orderBy('fullName').get();
      return query.docs.map(DoctorModel.fromFirestore).toList();
    } catch (_) {
      throw ServerException('تعذر جلب أطباء العيادة.');
    }
  }
}
