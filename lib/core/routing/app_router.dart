import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:doanlaptrinh/core/constants/route_constants.dart';
import 'package:doanlaptrinh/features/auth/presentation/controllers/auth_controller.dart';
import 'package:doanlaptrinh/features/auth/presentation/pages/settings_page.dart';
import 'package:doanlaptrinh/features/auth/presentation/pages/welcome_page.dart';
import 'package:doanlaptrinh/features/auth/presentation/pages/login_page.dart';
import 'package:doanlaptrinh/features/auth/presentation/pages/signup_page.dart';
import 'package:doanlaptrinh/features/auth/presentation/pages/profile_page.dart';
import 'package:doanlaptrinh/features/auth/presentation/pages/settings_page.dart';
import 'package:doanlaptrinh/features/quiz/presentation/pages/home_page.dart';
import 'package:doanlaptrinh/features/quiz/presentation/pages/discover_page.dart';
import 'package:doanlaptrinh/features/quiz/presentation/pages/create_quiz_landing_page.dart';
import 'package:doanlaptrinh/features/quiz/presentation/pages/create_quiz_form_page.dart';
import 'package:doanlaptrinh/features/quiz/presentation/pages/my_quizzes_page.dart';
import 'package:doanlaptrinh/features/quiz/presentation/pages/manage_questions_page.dart';
import 'package:doanlaptrinh/features/quiz/presentation/pages/quiz_detail_page.dart';
import 'package:doanlaptrinh/features/quiz/presentation/pages/quiz_play_page.dart';
import 'package:doanlaptrinh/features/quiz/presentation/pages/quiz_result_page.dart';
import 'package:doanlaptrinh/features/quiz/presentation/pages/edit_quiz_form_page.dart';
import 'package:doanlaptrinh/features/quiz/domain/entities/question.dart';
import 'package:doanlaptrinh/features/quiz/domain/entities/quiz.dart';
import 'package:doanlaptrinh/features/ai/presentation/pages/ai_quiz_generation_page.dart';
import 'package:doanlaptrinh/features/admin/presentation/pages/admin_dashboard_page.dart';

/// Redirect logic provider
final redirectProvider = Provider<String?>((ref) {
  // Don't redirect while loading
  final authState = ref.watch(authStateProvider);
  if (authState.isLoading) {
    return null;
  }
  
  return null; // Let individual routes handle redirects
});

/// Application router configuration
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RouteConstants.welcome,
    redirect: (context, state) {
      final authState = ref.read(authStateProvider);
      final user = authState.valueOrNull;
      final isAuthenticated = user != null;
      final isWelcomePage = state.matchedLocation == RouteConstants.welcome;
      final isLoginPage = state.matchedLocation == RouteConstants.login;
      final isSignupPage = state.matchedLocation == RouteConstants.signup;
      final isSettingsPage = state.matchedLocation == RouteConstants.settings;
      final isProfilePage = state.matchedLocation == RouteConstants.profile;
      
      // Don't redirect while loading
      if (authState.isLoading) {
        return null;
      }
      
      // Allow access to welcome, login and signup pages when not authenticated
      if (!isAuthenticated && !isWelcomePage && !isLoginPage && !isSignupPage) {
        // Don't redirect if Settings/Profile are opened via Navigator (not GoRouter)
        // This check prevents redirect when Settings is opened via Navigator.push
        if (isSettingsPage || isProfilePage) {
          return null; // Allow it, Settings/Profile will handle auth check internally
        }
        return RouteConstants.welcome;
      }
      
      // Redirect to home if authenticated and on welcome/login/signup page
      if (isAuthenticated && (isWelcomePage || isLoginPage || isSignupPage)) {
        return RouteConstants.home;
      }
      
      // Settings and Profile pages - allow if authenticated, or if opened via Navigator
      // (Navigator routes won't trigger this redirect)
      if (!isAuthenticated && (isSettingsPage || isProfilePage)) {
        // Only redirect if this is actually a GoRouter navigation
        // Navigator.push routes won't have matchedLocation set, so this won't trigger
        return RouteConstants.welcome;
      }
      
      return null;
    },
    routes: [
      GoRoute(
        path: RouteConstants.welcome,
        name: 'welcome',
        builder: (context, state) => const WelcomePage(),
      ),
      GoRoute(
        path: RouteConstants.login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RouteConstants.signup,
        name: 'signup',
        builder: (context, state) => const SignupPage(),
      ),
      GoRoute(
        path: RouteConstants.profile,
        name: 'profile',
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: RouteConstants.settings,
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: RouteConstants.home,
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: RouteConstants.discover,
        name: 'discover',
        builder: (context, state) => const DiscoverPage(),
      ),
      GoRoute(
        path: RouteConstants.createQuiz,
        name: 'createQuiz',
        builder: (context, state) => const CreateQuizLandingPage(),
      ),
      GoRoute(
        path: '${RouteConstants.createQuiz}/form',
        name: 'createQuizForm',
        builder: (context, state) => const CreateQuizFormPage(),
      ),
      GoRoute(
        path: RouteConstants.myQuizzes,
        name: 'myQuizzes',
        builder: (context, state) => const MyQuizzesPage(),
      ),
      GoRoute(
        path: RouteConstants.manageQuestions,
        name: 'manageQuestions',
        builder: (context, state) => const ManageQuestionsPage(),
      ),
      GoRoute(
        path: RouteConstants.quizDetail,
        name: 'quizDetail',
        builder: (context, state) {
          final quizId = state.pathParameters['id']!;
          return QuizDetailPage(quizId: quizId);
        },
      ),
      GoRoute(
        path: RouteConstants.editQuiz,
        name: 'editQuiz',
        builder: (context, state) {
          final quizId = state.pathParameters['id']!;
          final quiz = state.extra as Quiz?;
          return EditQuizFormPage(quizId: quizId, quiz: quiz);
        },
      ),
      GoRoute(
        path: RouteConstants.quizPlay,
        name: 'quizPlay',
        builder: (context, state) {
          final quizId = state.pathParameters['id']!;
          return QuizPlayPage(quizId: quizId);
        },
      ),
      GoRoute(
        path: RouteConstants.quizResult,
        name: 'quizResult',
        builder: (context, state) {
          final quizId = state.pathParameters['id']!;
          final result = state.extra as QuizResult?;
          return QuizResultPage(quizId: quizId, result: result);
        },
      ),
      GoRoute(
        path: RouteConstants.aiGeneration,
        name: 'aiGeneration',
        builder: (context, state) => const AIQuizGenerationPage(),
      ),
      GoRoute(
        path: RouteConstants.adminDashboard,
        name: 'adminDashboard',
        builder: (context, state) => const AdminDashboardPage(),
      ),
    ],
    refreshListenable: GoRouterRefreshNotifier(ref),
  );
});

/// Helper to refresh router when auth state changes
class GoRouterRefreshNotifier extends ChangeNotifier {
  GoRouterRefreshNotifier(this.ref) {
    ref.listen(authStateProvider, (previous, next) {
      notifyListeners();
    });
  }

  final Ref ref;
}


