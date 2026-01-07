/// Application route paths
class RouteConstants {
  RouteConstants._();

  // Auth
  static const String welcome = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String profile = '/profile';
  static const String settings = '/settings';
  
  // Quiz
  static const String home = '/home';
  static const String discover = '/discover';
  static const String createQuiz = '/create-quiz';
  static const String myQuizzes = '/my-quizzes';
  static const String manageQuestions = '/manage-questions';
  static const String quizDetail = '/quiz/:id';
  static const String editQuiz = '/quiz/:id/edit';
  static const String quizPreStart = '/quiz/:id/pre-start';
  static const String quizPlay = '/quiz/:id/play';
  static const String quizResult = '/quiz/:id/result';
  
  // AI
  static const String aiGeneration = '/ai-generation';
  
  // Admin
  static const String adminDashboard = '/admin';
  static const String adminUsers = '/admin/users';
  static const String adminCategories = '/admin/categories';
  static const String adminAnalytics = '/admin/analytics';
  static const String adminSubscriptions = '/admin/subscriptions';
  
  // Helper methods
  static String quizDetailPath(String quizId) => '/quiz/$quizId';
  static String editQuizPath(String quizId) => '/quiz/$quizId/edit';
  static String quizPreStartPath(String quizId) => '/quiz/$quizId/pre-start';
  static String quizPlayPath(String quizId) => '/quiz/$quizId/play';
  static String quizResultPath(String quizId) => '/quiz/$quizId/result';
}
