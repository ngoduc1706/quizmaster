import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:doanlaptrinh/core/constants/route_constants.dart';
import 'package:doanlaptrinh/core/extensions/context_extensions.dart';
import 'package:doanlaptrinh/core/theme/app_colors.dart';
import 'package:doanlaptrinh/core/errors/result.dart';
import 'package:doanlaptrinh/core/widgets/loading_indicator.dart';
import 'package:doanlaptrinh/features/quiz/presentation/controllers/quiz_session_controller.dart';
import 'package:doanlaptrinh/features/quiz/domain/entities/quiz.dart';
import 'package:doanlaptrinh/features/quiz/domain/entities/question.dart';

/// Quiz play page with total timer
class QuizPlayPage extends ConsumerStatefulWidget {
  const QuizPlayPage({
    super.key,
    required this.quizId,
  });

  final String quizId;

  @override
  ConsumerState<QuizPlayPage> createState() => _QuizPlayPageState();
}

class _QuizPlayPageState extends ConsumerState<QuizPlayPage> {
  Timer? _totalTimer;
  int _totalTimeRemaining = 0; // Total time in seconds
  bool _isTimeUp = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(quizSessionProvider(widget.quizId).notifier).initialize(widget.quizId);
    });
  }

  @override
  void dispose() {
    _totalTimer?.cancel();
    super.dispose();
  }

  void _startTotalTimer(int totalTimeSeconds) {
    _totalTimeRemaining = totalTimeSeconds;
    _totalTimer?.cancel();
    _totalTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_totalTimeRemaining > 0) {
            _totalTimeRemaining--;
          } else {
            timer.cancel();
            _isTimeUp = true;
            _autoSubmitQuiz();
          }
        });
      }
    });
  }

  Future<void> _autoSubmitQuiz() async {
    if (_isTimeUp) {
      final sessionNotifier = ref.read(quizSessionProvider(widget.quizId).notifier);
      
      // Show dialog
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (dialogContext) => AlertDialog(
            title: const Text('Hết thời gian!'),
            content: const Text('Thời gian làm bài đã hết. Hệ thống sẽ tự động chấm bài của bạn.'),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(dialogContext);
                  
                  // Submit quiz
                  final submitResult = await sessionNotifier.submitQuiz();
                  
                  if (mounted) {
                    switch (submitResult) {
                      case Success(data: final quizResult):
                        context.pushReplacement(
                          RouteConstants.quizResultPath(widget.quizId),
                          extra: quizResult,
                        );
                      case Failure(exception: final exception):
                        context.showErrorSnackBar(exception.toString());
                    }
                  }
                },
                child: const Text('Xem kết quả'),
              ),
            ],
          ),
        );
      }
    }
  }

  int _calculateTotalTime(List<Question>? questions) {
    if (questions == null || questions.isEmpty) {
      // Default: 10 minutes per question, minimum 5 minutes
      return 5 * 60; // 5 minutes
    }
    
    // Calculate total time: sum of all question time limits, or default
    int totalSeconds = 0;
    for (var question in questions) {
      if (question.timeLimit != null) {
        totalSeconds += question.timeLimit!;
      } else {
        totalSeconds += 60; // Default 60 seconds per question
      }
    }
    
    // Minimum 5 minutes, maximum 30 minutes
    if (totalSeconds < 5 * 60) totalSeconds = 5 * 60;
    if (totalSeconds > 30 * 60) totalSeconds = 30 * 60;
    
    return totalSeconds;
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(quizSessionProvider(widget.quizId));
    final sessionNotifier = ref.read(quizSessionProvider(widget.quizId).notifier);

    if (session.quiz == null || session.questions == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Đang tải...')),
        body: const Center(child: LoadingIndicator()),
      );
    }

    // Start total timer on first load
    if (_totalTimeRemaining == 0 && session.questions != null) {
      final totalTime = _calculateTotalTime(session.questions);
      _startTotalTimer(totalTime);
    }

    final currentQuestion = session.currentQuestion;
    if (currentQuestion == null) {
      return const Scaffold(
        body: Center(child: Text('Không có câu hỏi')),
      );
    }

    final hasAnswer = session.currentAnswer != null;
    final questionNumber = session.currentIndex + 1;
    final totalQuestions = session.questions!.length;
    final progress = (questionNumber / totalQuestions);

    // Warning colors based on time remaining
    final timeColor = _totalTimeRemaining < 60
        ? Colors.red
        : _totalTimeRemaining < 300
            ? Colors.orange
            : AppColors.primary;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black87),
          onPressed: () {
            _totalTimer?.cancel();
            context.pop();
          },
        ),
        title: Column(
          children: [
            Text(
              'Câu $questionNumber/$totalQuestions',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            // Progress bar
            Container(
              height: 4,
              width: 200,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(2),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progress,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          // Total Timer
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: timeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: timeColor, width: 2),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.timer_rounded, color: timeColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  _formatTime(_totalTimeRemaining),
                  style: TextStyle(
                    color: timeColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Question Type Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withOpacity(0.1),
                          AppColors.primary.withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.quiz_rounded,
                          color: AppColors.primary,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Trắc nghiệm',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Question Number Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Câu $questionNumber',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Question Text
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      currentQuestion.question,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        height: 1.5,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Options
                  ...currentQuestion.options.asMap().entries.map((entry) {
                    final index = entry.key;
                    final option = entry.value;
                    final isSelected = session.currentAnswer?.selectedIndex == index;
                    final label = String.fromCharCode(65 + index); // A, B, C, D...

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _isTimeUp
                              ? null
                              : () {
                                  sessionNotifier.selectAnswer(index);
                                },
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              gradient: isSelected
                                  ? LinearGradient(
                                      colors: [
                                        AppColors.primary,
                                        AppColors.primary.withOpacity(0.8),
                                      ],
                                    )
                                  : null,
                              color: isSelected ? null : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : Colors.grey[300]!,
                                width: isSelected ? 2 : 1,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: AppColors.primary.withOpacity(0.3),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ]
                                  : [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                            ),
                            child: Row(
                              children: [
                                // Letter Circle
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isSelected
                                        ? Colors.white
                                        : AppColors.primary.withOpacity(0.1),
                                    border: Border.all(
                                      color: isSelected
                                          ? Colors.white
                                          : AppColors.primary,
                                      width: 2,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      label,
                                      style: TextStyle(
                                        color: isSelected
                                            ? AppColors.primary
                                            : AppColors.primary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                // Option text
                                Expanded(
                                  child: Text(
                                    option,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                      color: isSelected
                                          ? Colors.white
                                          : const Color(0xFF1E293B),
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(
                                    Icons.check_circle,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Navigation Footer
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Previous Button
                if (session.canGoPrevious)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _isTimeUp
                          ? null
                          : () {
                              sessionNotifier.previousQuestion();
                            },
                      icon: const Icon(Icons.arrow_back_rounded),
                      label: const Text('Trước'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: AppColors.primary, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                if (session.canGoPrevious) const SizedBox(width: 12),
                
                // Next/Submit Button
                Expanded(
                  flex: 2,
                  child: session.isLastQuestion
                      ? Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF6366F1),
                                Color(0xFF8B5CF6),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton.icon(
                            onPressed: (_isTimeUp || hasAnswer)
                                ? () async {
                                    _totalTimer?.cancel();
                                    
                                    final submitResult =
                                        await sessionNotifier.submitQuiz();
                                    
                                    if (mounted) {
                                      switch (submitResult) {
                                        case Success(data: final quizResult):
                                          context.pushReplacement(
                                            RouteConstants.quizResultPath(
                                                widget.quizId),
                                            extra: quizResult,
                                          );
                                        case Failure(exception: final exception):
                                          context.showErrorSnackBar(
                                              exception.toString());
                                      }
                                    }
                                  }
                                : null,
                            icon: const Icon(Icons.check_circle_rounded),
                            label: const Text(
                              'Nộp bài',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            gradient: hasAnswer
                                ? const LinearGradient(
                                    colors: [
                                      Color(0xFF6366F1),
                                      Color(0xFF8B5CF6),
                                    ],
                                  )
                                : null,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: hasAnswer
                                ? [
                                    BoxShadow(
                                      color: AppColors.primary.withOpacity(0.3),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                : null,
                          ),
                          child: ElevatedButton.icon(
                            onPressed: (_isTimeUp || hasAnswer)
                                ? () {
                                    sessionNotifier.nextQuestion();
                                  }
                                : null,
                            icon: const Icon(Icons.arrow_forward_rounded),
                            label: const Text(
                              'Tiếp theo',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: hasAnswer
                                  ? Colors.transparent
                                  : Colors.grey[300],
                              shadowColor: Colors.transparent,
                              foregroundColor: hasAnswer
                                  ? Colors.white
                                  : Colors.grey[600],
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
