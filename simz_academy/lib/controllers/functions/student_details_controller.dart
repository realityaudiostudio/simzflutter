import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/student_model/student_details_model.dart';

Future<void> sendStudentDetailsToSupabase(StudentDetails studentDetails) async {
  final supabase = Supabase.instance.client;

  try {
    final response = await supabase.from('student_details').insert(studentDetails.toJson());

    if (response != null) {
      debugPrint('Data inserted successfully: $response');
    }
  } catch (error) {
    debugPrint('Error inserting data: $error');
  }
}
