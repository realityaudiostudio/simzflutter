import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:simz_academy/controllers/constants/supabase_functions.dart';

class BadgeModel {
  late List<String> badgeName = [];
  final String userId = getUserId();

  // Static variable to store cached badges
  static List<String>? _cachedBadgeNames;

  // Extracting data from JSON with caching
  Future<void> getBadge() async {
    // Check if cached data exists
    if (_cachedBadgeNames != null && _cachedBadgeNames!.isNotEmpty) {
      badgeName = _cachedBadgeNames!;
      debugPrint("Using cached badges: $badgeName");
      return;
    }

    try {
      // Fetch the badges from Supabase
      final response = await Supabase.instance.client
          .from('student_details')
          .select('badges')
          .eq('user_id', userId)
          .single();

      final badges = response['badges'] as List<dynamic>;

      // Convert and assign the badges to the list
      badgeName = badges.map((badge) => badge.toString()).toList();

      // Cache the badges for future use
      _cachedBadgeNames = List.from(badgeName);

      debugPrint("Fetched and cached badges: $badgeName");

    } catch (e) {
      debugPrint("Error fetching badges: $e");
    }
  }

  // Optionally, create a method to invalidate the cache if needed
  static void invalidateCache() {
    _cachedBadgeNames = null;
  }
}
