import 'package:breezodriver/core/network/api_client.dart';
import 'package:breezodriver/features/auth/viewmodels/location_viewmodel.dart';
import 'package:breezodriver/features/auth/viewmodels/otp_viewmodel.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/auth/viewmodels/auth_viewmodel.dart';
import '../../features/auth/viewmodels/business_viewmodel.dart';
import '../../features/home/viewmodels/home_viewmodel.dart';
import 'shared_prefs_service.dart';
import '../../features/trips/models/trip_model.dart';
import 'package:breezodriver/features/auth/services/driver_service.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Register SharedPreferences instance
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);
  
  // Register services
  getIt.registerSingleton<SharedPrefsService>(SharedPrefsService(getIt<SharedPreferences>()));
  
  // Core
  getIt.registerLazySingleton(() => ApiClient());
  
  // Services
  getIt.registerLazySingleton(() => DriverService(getIt()));
  
  // Register ViewModels
  getIt.registerFactory<AuthViewModel>(() => AuthViewModel(getIt<SharedPrefsService>()));
  getIt.registerFactory<HomeViewModel>(() => HomeViewModel(getIt<SharedPrefsService>()));
  getIt.registerFactory<LocationViewModel>(() => LocationViewModel());
  getIt.registerFactory(() => BusinessViewModel());
  getIt.registerFactory(() => OtpViewModel(getIt<ApiClient>()));
}

// Note: TripDetailsViewModel should be created with a specific TripModel instance,
// not through GetIt directly. We'll handle its creation in the UI layer.