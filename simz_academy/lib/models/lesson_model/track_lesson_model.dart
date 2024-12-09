import 'package:flutter/foundation.dart';
import 'package:simz_academy/controllers/constants/supabase_functions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TrackLessonModel {
  final String userId = getUserId();
  late List<dynamic> previousLessons;
  late List<dynamic> currentLessons;

  TrackLessonModel({required this.previousLessons, required this.currentLessons});

  factory TrackLessonModel.fromJson(Map<String, dynamic> json) {
    return TrackLessonModel(
      previousLessons: json['prev_learn'] as List<dynamic>? ?? [],
      currentLessons: json['curr_learn'] as List<dynamic>? ?? [],
    );
  }

  static Future<TrackLessonModel> fetchFromSupabase() async {
    try {
      // Fetch 'prev_learn' from Supabase
      final prevLearnResponse = await Supabase.instance.client
          .from('student_details')
          .select('prev_learn')
          .eq('user_id', getUserId())
          .single(); // Ensure a single row is returned

      // Cast the 'prev_learn' field to a List<dynamic>
      List<dynamic> prevLearn = prevLearnResponse['prev_learn'] as List<dynamic>? ?? [];

      // Fetch 'curr_learn' from Supabase
      final currLearnResponse = await Supabase.instance.client
          .from('student_details')
          .select('curr_learn')
          .eq('user_id', getUserId())
          .single(); // Ensure a single row is returned

      // Cast the 'curr_learn' field to a List<dynamic>
      List<dynamic> currLearn = currLearnResponse['curr_learn'] as List<dynamic>? ?? [];

      // Pass the extracted lists to the TrackLessonModel
      var data = {
        'prev_learn': prevLearn,
        'curr_learn': currLearn,
      };
      return TrackLessonModel.fromJson(data);
    } catch (e) {
      debugPrint('Error fetching data: $e');
      return TrackLessonModel(previousLessons: [], currentLessons: []);
    }
  }

  String currentLesson() {
    if (currentLessons.isNotEmpty) {
      return currentLessons[0] as String; // Return the first lesson if it exists
    } else {
      return "No lessons available"; // Return a fallback value
    }
  }

}
