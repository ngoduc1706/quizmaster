import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:doanlaptrinh/core/constants/route_constants.dart';
import 'package:doanlaptrinh/core/extensions/context_extensions.dart';
import 'package:doanlaptrinh/core/errors/result.dart';
import 'package:doanlaptrinh/features/ai/data/repositories/gemini_repository.dart';
import 'package:doanlaptrinh/features/ai/presentation/controllers/ai_generation_controller.dart';
import 'package:doanlaptrinh/features/quiz/presentation/controllers/create_quiz_controller.dart';

/// AI quiz generation page
class AIQuizGenerationPage extends ConsumerStatefulWidget {
  const AIQuizGenerationPage({super.key});

  @override
  ConsumerState<AIQuizGenerationPage> createState() => _AIQuizGenerationPageState();
}

class _AIQuizGenerationPageState extends ConsumerState<AIQuizGenerationPage> {
  final _topicController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _topicController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final aiState = ref.watch(aIGenerationProvider);
    final aiNotifier = ref.read(aIGenerationProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Tạo Quiz bằng AI',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF667EEA).withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.auto_awesome,
                        size: 48,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Tạo Quiz với AI',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Nhập chủ đề và để AI tạo quiz cho bạn',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Topic input
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: _topicController,
                  decoration: InputDecoration(
                    labelText: 'Chủ đề',
                    hintText: 'VD: Lịch sử Việt Nam, Toán học, Khoa học...',
                    prefixIcon: const Icon(Icons.topic_outlined, color: Color(0xFF667EEA)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.all(20),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Vui lòng nhập chủ đề';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    aiNotifier.updateTopic(value);
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Question count
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF667EEA).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.quiz_outlined,
                            color: Color(0xFF667EEA),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Số câu hỏi',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF667EEA),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${aiState.questionCount}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SliderTheme(
                      data: SliderThemeData(
                        activeTrackColor: const Color(0xFF667EEA),
                        inactiveTrackColor: const Color(0xFF667EEA).withOpacity(0.2),
                        thumbColor: const Color(0xFF667EEA),
                        overlayColor: const Color(0xFF667EEA).withOpacity(0.2),
                        trackHeight: 6,
                      ),
                      child: Slider(
                        value: aiState.questionCount.toDouble(),
                        min: 5,
                        max: 20,
                        divisions: 15,
                        onChanged: (value) {
                          aiNotifier.updateQuestionCount(value.toInt());
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '5 câu',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          '20 câu',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Difficulty
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF667EEA).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.speed,
                            color: Color(0xFF667EEA),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Độ khó',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildDifficultyButton(
                            'Dễ',
                            'easy',
                            Colors.green,
                            aiState.difficulty == 'easy',
                            () => aiNotifier.updateDifficulty('easy'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildDifficultyButton(
                            'Trung bình',
                            'medium',
                            Colors.orange,
                            aiState.difficulty == 'medium',
                            () => aiNotifier.updateDifficulty('medium'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildDifficultyButton(
                            'Khó',
                            'hard',
                            Colors.red,
                            aiState.difficulty == 'hard',
                            () => aiNotifier.updateDifficulty('hard'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Generate button
              Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF667EEA).withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;

                    // Show loading dialog
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => const Center(
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.all(24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(height: 16),
                                Text('Đang tạo quiz bằng AI...'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );

                    final result = await aiNotifier.generateQuiz();
                    
                    if (mounted) {
                      Navigator.of(context).pop(); // Close loading dialog
                      
                      switch (result) {
                        case Success(data: final generatedQuiz):
                          _navigateToCreateQuiz(generatedQuiz);
                        case Failure(exception: final exception):
                          context.showErrorSnackBar(exception.toString());
                      }
                    }
                  },
                  icon: const Icon(Icons.auto_awesome, size: 24),
                  label: const Text(
                    'Tạo Quiz với AI',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDifficultyButton(
    String label,
    String value,
    Color color,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.grey[700],
          ),
        ),
      ),
    );
  }

  void _navigateToCreateQuiz(GeneratedQuizData generatedQuiz) {
    final createQuizNotifier = ref.read(createQuizProvider.notifier);
    
    // Set basic info
    createQuizNotifier.updateTitle(generatedQuiz.title);
    if (generatedQuiz.description != null) {
      createQuizNotifier.updateDescription(generatedQuiz.description!);
    }
    createQuizNotifier.updateDifficulty(generatedQuiz.difficulty);

    // Add questions
    for (final question in generatedQuiz.questions) {
      createQuizNotifier.addQuestion(question);
    }

    // Navigate to create quiz form page
    context.push('${RouteConstants.createQuiz}/form');
  }
}


