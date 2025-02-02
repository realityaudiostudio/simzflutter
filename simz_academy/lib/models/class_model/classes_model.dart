import 'package:flutter/material.dart';
import 'package:simz_academy/controllers/constants/supabase_functions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ClassesModel {
  final String userId = getUserId();
  late final List<String> courses;
  late final List<Map<String, dynamic>> liveClasses = [];
  late final List<Map<String, dynamic>> upcomingClasses = [];

  Future<void> getClasses() async {
    // Get user's courses
    final response = await Supabase.instance.client
        .from('student_details')
        .select('courses')
        .eq('user_id', userId);

    final List<dynamic> coursesDynamic = response[0]['courses'];
    courses = coursesDynamic.map((course) => course.toString()).toList();
    debugPrint('User courses: ${courses.toString()}');

    // Get all classes
    final classResponse = await Supabase.instance.client
        .from('live')
        .select('live_class,mentor,meet_url,course,day_of_that');
    debugPrint('All classes: ${classResponse.toString()}');

    // Get the user's local timezone offset
    final DateTime now = DateTime.now();
    final Duration localOffset = now.timeZoneOffset;

    // IST offset is +5:30 (19800 seconds)
    final Duration istOffset = Duration(hours: 5, minutes: 30);

    for (var classData in classResponse) {
      if (courses.contains(classData['course'])) {
        // Convert IST time to UTC, then to local time
        DateTime classTimeIST = DateTime.parse(classData['day_of_that']);
        DateTime classTimeUTC = classTimeIST.subtract(istOffset);
        DateTime classTimeLocal = classTimeUTC.add(localOffset);

        // Create a new map with converted time
        Map<String, dynamic> localClassData = Map.from(classData);
        localClassData['day_of_that'] = classTimeLocal.toIso8601String();

        // Compare with current local time
        if (classTimeLocal.isBefore(now)) {
          liveClasses.add(localClassData);
        } else {
          upcomingClasses.add(localClassData);
        }
      }
    }

    // Sort classes by local date
    liveClasses.sort((a, b) =>
        DateTime.parse(a['day_of_that']).compareTo(DateTime.parse(b['day_of_that']))
    );
    upcomingClasses.sort((a, b) =>
        DateTime.parse(a['day_of_that']).compareTo(DateTime.parse(b['day_of_that']))
    );

    debugPrint('Live classes: ${liveClasses.toString()}');
    debugPrint('Upcoming classes: ${upcomingClasses.toString()}');
  }

  // Helper method to format datetime for display
  String formatClassTime(String dateTimeString) {
    final DateTime dateTime = DateTime.parse(dateTimeString);
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')} ${dateTime.timeZoneName}';
  }
}


