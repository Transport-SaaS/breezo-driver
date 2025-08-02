import 'package:breezodriver/core/network/api_client.dart';
import 'package:breezodriver/features/auth/data/auth_repository.dart';
import 'package:breezodriver/features/profile/repositories/driver_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../storage/secure_storage.dart';
import 'shared_prefs_service.dart';

final GetIt serviceLocator = GetIt.instance;

Future<void> setupServiceLocator() async {
  serviceLocator.registerLazySingleton<SecureStorage>(() => SecureStorage());
  // Register SharedPreferences instance
  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerSingleton<SharedPreferences>(sharedPreferences);
  
  // Register services
  serviceLocator.registerSingleton<SharedPrefsService>(SharedPrefsService(serviceLocator<SharedPreferences>()));
  
  // Core
  serviceLocator.registerLazySingleton<ApiClient>(
    () => ApiClient(secureStorage: serviceLocator<SecureStorage>()),
  );

  //repositories
  serviceLocator.registerLazySingleton<AuthRepository>(
        () => AuthRepository(
      apiClient: serviceLocator<ApiClient>(),
      secureStorage: serviceLocator<SecureStorage>(),
    ),
  );

  serviceLocator.registerLazySingleton<DriverRepository>(
        () => DriverRepository(
      apiClient: serviceLocator<ApiClient>(),
      secureStorage: serviceLocator<SecureStorage>(),
    ),
  );

}

// Note: TripDetailsViewModel should be created with a specific TripModel instance,
// not through GetIt directly. We'll handle its creation in the UI layer.