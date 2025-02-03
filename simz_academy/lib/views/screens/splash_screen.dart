import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:simz_academy/views/UIHelper/home_ui_helper.dart';
import 'package:simz_academy/views/screens/bottom_nav.dart';
//import 'package:simz_academy/screens/bottom_nav.dart';
import 'package:simz_academy/views/screens/login_screen.dart';
import 'package:simz_academy/views/screens/no_internet.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ignore: must_be_immutable
class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () async {
      final hasNetwork = await _checkNetwork();
      final hasSession = Supabase.instance.client.auth.currentSession != null;

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => hasNetwork
                  ? (hasSession ? const BottomNav() : const LoginScreen())
                  : const NoInternet()
          )
      );
    });

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: const [
              Color.fromRGBO(254, 202, 206, 1), // rgba(254, 202, 206, 1)
              Colors.white, // white in the center
              Color.fromRGBO(196, 220, 243, 1), // rgba(196, 220, 243, 1)
            ],
            stops: const [0.0, 0.5, 1.0], // Control color spread
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "lib/assets/images/simz_logo.png",
                fit: BoxFit.fill,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:  [
                  HomeUiHelper().customText('Simz ', 32, FontWeight.w600, Color(0xFF380F43),),
                  HomeUiHelper().customText('Academy', 32, FontWeight.w600, Color(0xFF1B3C5F),),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Update checkNetwork to return Future<void>
  Future<bool> _checkNetwork() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  bool checkUserSignIn() {
    final Session? session = Supabase.instance.client.auth.currentSession;
    if (session == null) {
      return false;
    } else {
      return true;
    }
  }
}
