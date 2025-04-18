class EnvConfig {
  static const String apiBaseUrl = 'http://transport-test-backend.ap-south-1.elasticbeanstalk.com:8090';
  
  // Add other environment variables here
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
  static const bool enableLogging = true;
} 