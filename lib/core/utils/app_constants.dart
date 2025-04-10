class AppConstants {
  // API URLs
  static const String baseUrl = 'https://api.example.com';
  static const String loginEndpoint = '/auth/login';
  static const String profileEndpoint = '/user/profile';
  
  // Timeouts
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
  static const int downloadTimeout = 60000; // 60 seconds
  
  // Error messages
  static const String connectionError = 'Connection error. Please check your internet connection.';
  // static const String connectionTimeout = 'Connection timed out. Please try again.';
  static const String serverError = 'Server error. Please try again later.';
  static const String unknownError = 'An unknown error occurred.';
  
  // Download related
  static const String downloadStarted = 'Download started';
  static const String downloadCompleted = 'Download completed';
  static const String downloadFailed = 'Download failed';
  static const String downloadCancelled = 'Download cancelled';
}