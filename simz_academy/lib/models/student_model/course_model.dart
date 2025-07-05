import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../controllers/constants/supabase_functions.dart';

class CourseModel{
  List<String> enrolledCourses = [];
  List<String> courseName = [];

  Future<void> getCourseNames()async {

    try{
      final response = await Supabase.instance.client
          .from('local_courses')
          .select('course_id, course_name');
      courseName = (response as List).map((item) => item['course_name'].toString()).toList();
    }catch(e){
      debugPrint(e.toString());
    }

  }
  Future<void> getEnrolledCourseNames() async {
    try {
      final userId = getUserId();
      final response = await Supabase.instance.client
          .from('student_details')
          .select('courses')
          .eq('user_id', userId)
          .single(); // Only fetch the current user’s row

      final coursesData = response['courses'];

      if (coursesData != null && coursesData is List) {
        enrolledCourses = List<String>.from(coursesData);
      } else if (coursesData != null && coursesData is String) {
        // If it's a stringified list (like "[Math, Science]")
        final cleaned = coursesData.replaceAll('[', '').replaceAll(']', '');
        enrolledCourses = cleaned.split(',').map((e) => e.trim()).toList();
      } else {
        enrolledCourses = [];
      }
    } catch (e) {
      debugPrint(e.toString());
      enrolledCourses = [];
    }
  }


}