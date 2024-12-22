import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simz_academy/controllers/constants/supabase_functions.dart';
//import 'package:simz_academy/views/screens/login_screen.dart';
import 'package:simz_academy/views/screens/splash_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
      url: supaBaseUrl,
      anonKey:supaAnonKey
  );
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
      title : 'Simz Academy',
    );
  }
}
