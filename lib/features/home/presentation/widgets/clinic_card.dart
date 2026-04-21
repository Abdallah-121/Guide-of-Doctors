import 'package:flutter/material.dart';

import '../../../clinics/domain/entities/clinic.dart';

class ClinicCard extends StatelessWidget {
  final Clinic clinic;
  final VoidCallback onTap;

  const ClinicCard({super.key, required this.clinic, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        title: Text(clinic.name),
        subtitle: Text('${clinic.address} - ${clinic.governorate}'),
        trailing: Text('الأطباء: ${clinic.doctorsCount}'),
      ),
    );
  }
}
