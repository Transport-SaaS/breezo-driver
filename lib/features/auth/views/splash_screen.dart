// lib/views/screens/splash_screen.dart

import 'package:breezodriver/core/utils/app_assets.dart';
import 'package:breezodriver/features/auth/views/phone_number_screen.dart';
import 'package:breezodriver/features/home/views/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../../profile/viewmodels/driver_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';

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
    Future.delayed(const Duration(seconds: 3), () async {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      final isAuthenticated = await authViewModel.checkAuthentication();
      if(isAuthenticated) {
        final driverViewModel = Provider.of<DriverViewModel>(context, listen: false);
        await driverViewModel.loadTransporterOfficeDetails();
        await driverViewModel.loadDriverData();
        await driverViewModel.loadDefaultAddress();
        await driverViewModel.loadVehicleDetails();
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      }
      else {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
            const PhoneNumberScreen(),
            // const HomeScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation,
                child) {
              const begin = 0.0;
              const end = 1.0;
              const curve = Curves.easeIn;

              var tween = Tween(begin: begin, end: end).chain(
                  CurveTween(curve: curve));
              var fadeAnimation = animation.drive(tween);

              return FadeTransition(
                opacity: fadeAnimation,
                child: child,
              );
            },
          ),
        );
      }
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              AppAssets.logo,
              width: 150, // Adjust sizing to fit your design
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Driver Partner App",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );

  }
}
