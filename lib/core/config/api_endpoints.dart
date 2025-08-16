class ApiEndpoints {
  // Base URL
  static const String baseUrl = 'http://10.0.2.2:8090';
  static const String baseWsURL = 'ws://10.0.2.2:8080';
  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh-token';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';

  // OTP Authentication endpoints
  static const String generateOTP = '/auth/driver/generateOTP';
  static const String verifyOTP = '/auth/driver/verifyOTP';

  // User endpoints
  static const String userProfile = '/user/profile';
  static const String updateProfile = '/user/profile';

  // Driver endpoints
  static const String getDriver = '/driver/getDriver';
  static const String getProfile = '/driver/getProfile';
  static const String saveProfile = '/driver/saveProfile';
  static const String setAccountStatus = '/driver/setAccountStatus';
  static const String saveAddress = '/driver/saveAddress';
  static const String saveAddressAndSetDefault = '/driver/saveAddressAndSetDefault';
  static const String getAddresses = '/driver/getAddresses';
  static const String getActiveAddress = '/driver/getActiveAddress';
  static const String deleteAddress = '/driver/deleteAddress';
  static const String setDefaultAddress = '/driver/setDefaultAddress';
  static const String getDriverOfficeDetails = '/driver/getOfficeDetails';
  static const String getDefaultWorkingSchedule = '/driver/getDefaultWorkingSchedule';
  static const String saveDefaultWorkingSchedule = '/driver/saveDefaultWorkingSchedule';
  static const String saveWorkingDaysException = '/driver/saveWorkingDaysException';
  static const String getPlannedTrips = '/driver/getDriverPlannedTripsForFuture';
  static const String getDriverPastOneWeekTrips = '/driver/getDriverPastOneWeekTrips';
  static const String getPastTrips = '/driver/getDriverPastTrips';
  static const String ratePastTrip = '/driver/ratePastTrip';
  static const String getPartialTripInformation = '/driver/getPartialTripInformation';
  static const String getPartialDriverDataForTripRoute = '/driver/getPartialDriverDataForTripRoute';
  static const String getVehicleDetails = '/driver/getVehicleDetails';

  // Trip endpoints
  static const String getTripDetails = '/tripData/getTripDetails';
  static const String trips = '/trips';
  static const String tripSchedules = '/trip-schedules';
  static const String completedTrips = '/trips/completed';
  static const String scheduledTrips = '/trips/scheduled';
}
