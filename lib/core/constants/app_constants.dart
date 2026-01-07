/// Application-wide constants
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'Quiz App';
  static const String appVersion = '1.0.0';
  
  // Quotas
  static const int freeQuizzesPerDay = 20;
  static const int freeAIGenerationsPerDay = 5;
  static const int proQuizzesPerDay = -1; // unlimited
  static const int proAIGenerationsPerDay = -1; // unlimited
  
  // Subscription
  static const double proMonthlyPrice = 49000.0; // VND
  static const String currency = 'VND';
  
  // Quiz Limits
  static const int minQuestionsPerQuiz = 1;
  static const int maxQuestionsPerQuiz = 100;
  static const int minOptionsPerQuestion = 2;
  static const int maxOptionsPerQuestion = 6;
  static const int maxTitleLength = 100;
  static const int maxDescriptionLength = 500;
  static const int maxQuestionLength = 500;
  static const int maxOptionLength = 200;
  static const int maxExplanationLength = 1000;
  
  // Time Limits
  static const int minTimeLimitSeconds = 10;
  static const int maxTimeLimitSeconds = 300;
  static const int defaultTimeLimitSeconds = 60;
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // Cache
  static const int cacheExpirationHours = 24;
  
  // AI
  static const int aiRequestTimeoutSeconds = 30;
  static const int aiMaxRetries = 3;
  
  // Storage
  static const int maxImageSizeMB = 5;
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'webp'];
}













