import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simz_academy/controllers/constants/supabase_functions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PaymentHistoryModel {
  // Static cached lists to persist data across instances
  static final List<String> _cachedAmounts = [];
  static final List<String> _cachedCourseNames = [];
  static final List<String> _cachedCreatedAtDates = [];

  // Instance lists to work with current data
  List<String> amounts = [];
  List<String> courseNames = [];
  List<String> createdAtDates = [];

  final String userId = getUserId();

  Future<void> getPaymentHistory() async {
    // Check if cached lists are empty or not initialized
    if (_cachedAmounts.isEmpty) {
      try {
        final response = await Supabase.instance.client
            .from('fee')
            .select('*')
            .eq('user_id', userId);

        // Clear existing lists before populating
        _cachedAmounts.clear();
        _cachedCourseNames.clear();
        _cachedCreatedAtDates.clear();

        // Iterate through the response and populate cached lists
        for (var payment in response) {
          // Convert amount to string
          _cachedAmounts.add(payment['amount'].toString());
          _cachedCourseNames.add(payment['course']);

          // Convert timestamp to a formatted date
          DateTime createdAt = DateTime.parse(payment['created_at']);
          _cachedCreatedAtDates.add(DateFormat('dd MMM yyyy').format(createdAt));
        }

        // Update instance lists with cached data
        _updateInstanceLists();

        debugPrint('Payment History Fetched from Supabase:');
        debugPrint('Cached Amounts: $_cachedAmounts');
        debugPrint('Cached Courses: $_cachedCourseNames');
        debugPrint('Cached Created At: $_cachedCreatedAtDates');
      } catch (e) {
        debugPrint('Error fetching payment history: $e');
      }
    } else {
      // If cached data exists, update instance lists
      _updateInstanceLists();
      debugPrint('Using cached payment history');
    }
  }

  // Method to update instance lists with cached data
  void _updateInstanceLists() {
    amounts = List.from(_cachedAmounts);
    courseNames = List.from(_cachedCourseNames);
    createdAtDates = List.from(_cachedCreatedAtDates);
  }

  // Optional: Method to clear cache if needed
  static void clearCache() {
    _cachedAmounts.clear();
    _cachedCourseNames.clear();
    _cachedCreatedAtDates.clear();
  }
}