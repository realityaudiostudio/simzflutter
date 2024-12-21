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

    // Sort classes into live and upcoming
    final DateTime currentTime = DateTime.now();

    for (var classData in classResponse) {
      // Only process if the class's course is in user's courses
      if (courses.contains(classData['course'])) {
        final DateTime classTime = DateTime.parse(classData['day_of_that']);

        // If class time is before current time, it's a live class
        if (classTime.isBefore(currentTime)) {
          liveClasses.add(classData);
        } else {
          // If class time is after current time, it's an upcoming class
          upcomingClasses.add(classData);
        }
      }
    }

    // Sort classes by date
    liveClasses.sort((a, b) =>
        DateTime.parse(a['day_of_that']).compareTo(DateTime.parse(b['day_of_that']))
    );

    upcomingClasses.sort((a, b) =>
        DateTime.parse(a['day_of_that']).compareTo(DateTime.parse(b['day_of_that']))
    );

    debugPrint('Live classes: ${liveClasses.toString()}');
    debugPrint('Upcoming classes: ${upcomingClasses.toString()}');
  }
}