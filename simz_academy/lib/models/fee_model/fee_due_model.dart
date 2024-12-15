import 'package:flutter/material.dart';
import 'package:simz_academy/controllers/constants/supabase_functions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FeeDueModel {
  final String userId = getUserId();
  static String? cachedFeeDue;

  Future<String> getFeeDue() async {
    // If cached value exists and is not '0' or null, return it
    if (cachedFeeDue != null && cachedFeeDue != '0' && cachedFeeDue != '') {
      debugPrint('Returning cached fee due: $cachedFeeDue');
      return cachedFeeDue!;
    }

    // Fetch from Supabase
    final response = await Supabase.instance.client
        .from('student_details')
        .select('fee_due')
        .eq('user_id', userId);

    // Check if response is not empty and fee_due is not null
    if (response.isNotEmpty && response[0]['fee_due'] != null) {
      cachedFeeDue = response[0]['fee_due'].toString();

      // Ensure we don't keep an empty or null value
      if (cachedFeeDue == null || cachedFeeDue == '') {
        cachedFeeDue = '0';
      }

      debugPrint('Fetched new fee due: $cachedFeeDue');
      return cachedFeeDue!;
    }

    // Default to '0' if no data found
    cachedFeeDue = '0';
    return cachedFeeDue!;
  }

  // Method to reset the cached value if needed
  void resetCachedFeeDue() {
    cachedFeeDue = null;
  }
}