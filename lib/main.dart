import 'package:breezodriver/core/utils%20copy/size_config.dart';
import 'package:breezodriver/features/auth/viewmodels/business_viewmodel.dart';
import 'package:breezodriver/features/auth/viewmodels/location_viewmodel.dart';
import 'package:breezodriver/features/auth/views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/services/service_locator.dart';
import 'features/auth/viewmodels/auth_viewmodel.dart';
import 'features/home/viewmodels/home_viewmodel.dart';
import 'features/trips/viewmodels/trip_details_viewmodel.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize service locator
  await setupServiceLocator();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => serviceLocator<AuthViewModel>()),
        ChangeNotifierProvider(create: (_) => serviceLocator<HomeViewModel>()),
        ChangeNotifierProvider(create: (_) => serviceLocator<LocationViewModel>()),
        ChangeNotifierProvider(create: (_) => serviceLocator<BusinessViewModel>()),
        ChangeNotifierProvider(create: (_) => serviceLocator<TripDetailsViewModel>()),
      ],
      child: MaterialApp(
        title: 'Breezo Driver',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
         home: Builder(
          builder: (context) {
            SizeConfig().init(context);
            // return MainNavigationScreen();
            return SplashScreen();
          },
        ),
      ),
    );
  }
}
