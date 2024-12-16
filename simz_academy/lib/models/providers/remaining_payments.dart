import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../controllers/constants/supabase_functions.dart';

/// A Riverpod provider that streams fee due amounts from Supabase
/// for the user identified by [userId], parsing text to double.
///
/// Example:
/// ```dart
/// final feeAmounts = ref.watch(feeProvider);
/// ```
final userId = getUserId(); // Fetch the current user's ID.

final feeProvider = StreamProvider<List<double>>((ref) {
  return Supabase.instance.client
      .from('student_details')
      .stream(
    primaryKey: ['user_id'],
  )
      .eq('user_id', userId)
      .map((data) =>
      data.map<double>((item) {
        // Parse the text fee_due to double, handling potential formatting
        String feeDueText = item['fee_due'] ?? '0.0';
        // Remove any non-numeric characters except decimal point
        String cleanedFee = feeDueText.replaceAll(RegExp(r'[^\d.]'), '');
        return double.tryParse(cleanedFee) ?? 0.0;
      }).toList()
  );
});