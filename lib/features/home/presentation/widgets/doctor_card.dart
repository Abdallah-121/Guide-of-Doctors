import 'package:flutter/material.dart';

import '../../../doctors/domain/entities/doctor.dart';

class DoctorCard extends StatelessWidget {
  final Doctor doctor;
  final VoidCallback onDetails;
  final VoidCallback onMap;

  const DoctorCard({
    super.key,
    required this.doctor,
    required this.onDetails,
    required this.onMap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(doctor.fullName),
        subtitle: Text('${doctor.address} - ${doctor.governorate}'),
        trailing: Wrap(
          spacing: 6,
          children: [
            IconButton(onPressed: onMap, icon: const Icon(Icons.map_outlined)),
            IconButton(onPressed: onDetails, icon: const Icon(Icons.arrow_forward_ios)),
          ],
        ),
      ),
    );
  }
}
