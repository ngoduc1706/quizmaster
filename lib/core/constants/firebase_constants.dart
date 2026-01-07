/// Firebase collection and field names
class FirebaseConstants {
  FirebaseConstants._();

  // Collections
  static const String usersCollection = 'users';
  static const String quizzesCollection = 'quizzes';
  static const String questionsCollection = 'questions';
  static const String resultsCollection = 'results';
  static const String categoriesCollection = 'categories';
  static const String quizAttemptsCollection = 'quizAttempts';
  
  // User Fields
  static const String userUid = 'uid';
  static const String userName = 'name';
  static const String userEmail = 'email';
  static const String userPhotoUrl = 'photoUrl';
  static const String userRole = 'role';
  static const String userSubscriptionTier = 'subscriptionTier';
  static const String userCreatedAt = 'createdAt';
  static const String userStats = 'stats';
  
  // Quiz Fields
  static const String quizId = 'id';
  static const String quizTitle = 'title';
  static const String quizDescription = 'description';
  static const String quizOwnerId = 'ownerId';
  static const String quizOwnerName = 'ownerName';
  static const String quizCategoryId = 'categoryId';
  static const String quizDifficulty = 'difficulty';
  static const String quizIsPublic = 'isPublic';
  static const String quizTags = 'tags';
  static const String quizQuestionCount = 'questionCount';
  static const String quizStats = 'stats';
  static const String quizCreatedAt = 'createdAt';
  static const String quizUpdatedAt = 'updatedAt';
  
  // Question Fields
  static const String questionId = 'id';
  static const String questionQuizId = 'quizId';
  static const String questionQuestion = 'question';
  static const String questionType = 'type';
  static const String questionOptions = 'options';
  static const String questionCorrectAnswerIndex = 'correctAnswerIndex';
  static const String questionExplanation = 'explanation';
  static const String questionPoints = 'points';
  static const String questionTimeLimit = 'timeLimit';
  static const String questionOrder = 'order';
  
  // Result Fields
  static const String resultId = 'id';
  static const String resultUserId = 'userId';
  static const String resultQuizId = 'quizId';
  static const String resultScore = 'score';
  static const String resultAccuracy = 'accuracy';
  static const String resultTimeSpent = 'timeSpent';
  static const String resultGrade = 'grade';
  static const String resultAnswersDetails = 'answersDetails';
  static const String resultCompletedAt = 'completedAt';
  
  // Category Fields
  static const String categoryId = 'id';
  static const String categoryName = 'name';
  static const String categorySlug = 'slug';
  static const String categoryColor = 'color';
  static const String categoryIcon = 'icon';
  static const String categoryIsActive = 'isActive';
  static const String categoryOrder = 'order';
}








