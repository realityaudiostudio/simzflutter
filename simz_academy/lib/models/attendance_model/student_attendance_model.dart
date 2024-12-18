import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../controllers/constants/supabase_functions.dart';

class StudentAttendanceModel {
  String userId = getUserId();
  List<DateTime> attendance = [];
  List<DateTime> absentDates = [];

  Future<void> getAttendance() async {
    final response = await Supabase.instance.client
        .from('attendance')
        .select('date,is_present')
        .eq('user_id', userId);

    debugPrint('Attendance: $response');

    // Parse only present dates, ignoring time component
    attendance = response
        .where((item) => item['is_present'] == true)
        .map<DateTime>((item) {
      DateTime parsedDate = DateTime.parse(item['date']);
      // Use date-only to avoid time-based discrepancies
      return DateTime(parsedDate.year, parsedDate.month, parsedDate.day);
    })
        .toList();

    absentDates = response
        .where((item) => item['is_present'] == false)
        .map<DateTime>((item) {
      DateTime parsedDate = DateTime.parse(item['date']);
      // Use date-only to avoid time-based discrepancies
      return DateTime(parsedDate.year, parsedDate.month, parsedDate.day);
    })
        .toList();

    debugPrint("Attendance Dates: $attendance");
  }
}