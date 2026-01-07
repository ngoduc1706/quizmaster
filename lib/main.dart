import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:doanlaptrinh/core/constants/route_constants.dart';
import 'package:doanlaptrinh/core/theme/app_theme.dart';
import 'package:doanlaptrinh/core/localization/app_localizations.dart';
import 'package:doanlaptrinh/core/services/language_service.dart';
import 'package:doanlaptrinh/features/auth/presentation/controllers/auth_controller.dart';
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
import 'package:doanlaptrinh/features/quiz/presentation/pages/quiz_pre_start_page.dart';
import 'package:doanlaptrinh/features/quiz/presentation/pages/quiz_play_page.dart';
import 'package:doanlaptrinh/features/quiz/presentation/pages/quiz_result_page.dart';
import 'package:doanlaptrinh/features/quiz/presentation/pages/edit_quiz_form_page.dart';
import 'package:doanlaptrinh/features/quiz/domain/entities/question.dart';
import 'package:doanlaptrinh/features/quiz/domain/entities/quiz.dart';
import 'package:doanlaptrinh/features/ai/presentation/pages/ai_quiz_generation_page.dart';
import 'package:doanlaptrinh/features/admin/presentation/pages/admin_dashboard_page.dart';
import 'package:doanlaptrinh/features/admin/presentation/widgets/admin_setup_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp();
  
  runApp(
    const ProviderScope(
      child: QuizApp(),
    ),
  );
}

/// Helper to refresh router when auth state changes
class GoRouterRefreshNotifier extends ChangeNotifier {
  GoRouterRefreshNotifier(this.ref) {
    ref.listen(authStateProvider, (previous, next) {
      notifyListeners();
    });
  }

  final Ref ref;
}

/// Application router provider
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
      
      // Don't redirect while loading
      if (authState.isLoading) {
        return null;
      }
      
      // Allow access to welcome, login and signup pages when not authenticated
      if (!isAuthenticated && !isWelcomePage && !isLoginPage && !isSignupPage) {
        return RouteConstants.welcome;
      }
      
      // Redirect to home if authenticated and on welcome/login/signup page
      if (isAuthenticated && (isWelcomePage || isLoginPage || isSignupPage)) {
        return RouteConstants.home;
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
        builder: (context, state) {
          final quizId = state.extra as String?;
          return ManageQuestionsPage(quizId: quizId);
        },
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
        path: RouteConstants.quizPreStart,
        name: 'quizPreStart',
        builder: (context, state) {
          final quizId = state.pathParameters['id']!;
          return QuizPreStartPage(quizId: quizId);
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

class QuizApp extends ConsumerStatefulWidget {
  const QuizApp({super.key});

  @override
  ConsumerState<QuizApp> createState() => _QuizAppState();
}

class _QuizAppState extends ConsumerState<QuizApp> {
  Locale? _locale;

  @override
  void initState() {
    super.initState();
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final locale = await LanguageService.getLocale();
    if (mounted) {
      setState(() {
        _locale = locale;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);
    final currentLanguage = ref.watch(currentLanguageProvider);
    
    // Update locale when language changes
    if (_locale?.languageCode != currentLanguage.locale.languageCode) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _locale = currentLanguage.locale;
        });
      });
    }
    
    return AdminSetupWidget(
      child: MaterialApp.router(
        title: 'Quiz App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeMode,
        locale: _locale,
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('vi', 'VN'),
          Locale('en', 'US'),
        ],
        routerConfig: router,
      ),
    );
  }
}
