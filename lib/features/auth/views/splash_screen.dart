// lib/views/screens/splash_screen.dart

import 'package:breezodriver/core/utils/app_assets.dart';
import 'package:breezodriver/features/auth/views/phone_number_screen.dart';
import 'package:breezodriver/features/auth/views/select_home_location.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    // Request location permission
    var locationStatus = await Permission.location.request();

    
    // Optional: Request background location if needed
    if (locationStatus.isGranted) {
      await Permission.locationAlways.request();
    }
    await _attemptLocalNetworkAccess();

    // Navigate after delay, regardless of permission status
    // You can handle permission denial in the location screen
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => 
              const SelectLocationScreen(isFromAllAddress: false),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = 0.0;
            const end = 1.0;
            const curve = Curves.easeIn;

            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var fadeAnimation = animation.drive(tween);

            return FadeTransition(
              opacity: fadeAnimation,
              child: child,
            );
          },
        ),
      );
    });
  }
  Future<void> _attemptLocalNetworkAccess() async {
    try {
      // Bind a socket on any available port. This can trigger the local network prompt on iOS.
      final serverSocket = await ServerSocket.bind(InternetAddress.anyIPv4, 0);
      // Close it immediately if you just want to force the permission prompt.
      await serverSocket.close();
    } catch (e) {
      // If binding fails or the user denies local network access, you can handle it here
      debugPrint('Local network bind failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
       return Scaffold(
      body: Container(
        
        child: Center(
          child: Image.asset(
            AppAssets.logo,
            width: 150, // Adjust sizing to fit your design
          ),
        ),
      ),
    );

  }
}
