// import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../controllers/constants/supabase_functions.dart';

class CertificateModel {
  final String userId;
  List<String> certificateName;
  List<String> certificateUrl;

  // Static variable to store cached certificates
  static CertificateModel? _cachedCertificates;

  // Default constructor
  CertificateModel({
    required this.userId,
    this.certificateName = const [],
    this.certificateUrl = const [],
  });

  // Constructor for populating data from JSON
  CertificateModel.fromJson({
    required this.userId,
    required List<dynamic> json,
  })  : certificateName = json.map((e) => e['name'] as String? ?? 'Unknown Certificate').toList(),
        certificateUrl = json.map((e) => e['link'] as String? ?? '').toList();

  // Fetch certificates from Supabase
  static Future<CertificateModel?> fetchCertificates() async {
    // Check if cached data exists and is recent
    if (_cachedCertificates != null) {
      // You can add a timestamp check here to invalidate cache after a certain time
      debugPrint("Returning cached certificates");
      return _cachedCertificates;
    }

    final supabase = Supabase.instance.client;
    try {
      final userId = getUserId();
      debugPrint("Fetching certificates for userId: $userId");

      // Query the 'student_details' table in Supabase to get certificates
      final response = await supabase
          .from('student_details')
          .select('certificates')
          .eq('user_id', userId)
          .single();

      debugPrint("Raw response: $response");

      // Check if certificates exist and are not null or empty
      if (response['certificates'] == null ||
          (response['certificates'] is List &&
              (response['certificates'] as List).isEmpty)) {
        debugPrint("No certificates found for userId: $userId");
        return CertificateModel(userId: userId); // Return an empty model
      }

      // Parse the certificates JSON into a List
      final certificatesJson = response['certificates'] as List<dynamic>;
      debugPrint("Certificates JSON: $certificatesJson");

      // Cache the certificates for future use
      _cachedCertificates = CertificateModel.fromJson(
        userId: userId,
        json: certificatesJson,
      );

      return _cachedCertificates;
    } catch (e) {
      debugPrint("Detailed error fetching certificates: $e");
      return CertificateModel(userId: getUserId()); // Return an empty model on error
    }
  }

  // Optionally, you can create a method to invalidate the cache when needed
  static void invalidateCache() {
    _cachedCertificates = null;
  }
}
