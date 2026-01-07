import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:doanlaptrinh/core/constants/app_constants.dart';
import 'package:doanlaptrinh/core/constants/route_constants.dart';
import 'package:doanlaptrinh/core/extensions/context_extensions.dart';
import 'package:doanlaptrinh/core/theme/app_colors.dart';
import 'package:doanlaptrinh/core/utils/validators.dart';
import 'package:doanlaptrinh/core/errors/result.dart';
import 'package:doanlaptrinh/features/quiz/domain/entities/question.dart';
import 'package:doanlaptrinh/features/quiz/domain/entities/quiz.dart';
import 'package:doanlaptrinh/features/quiz/presentation/controllers/create_quiz_controller.dart';
import 'package:doanlaptrinh/features/quiz/presentation/controllers/category_controller.dart';
import 'package:uuid/uuid.dart';

/// Create quiz form page
class CreateQuizFormPage extends ConsumerStatefulWidget {
  const CreateQuizFormPage({super.key});

  @override
  ConsumerState<CreateQuizFormPage> createState() => _CreateQuizFormPageState();
}

class _CreateQuizFormPageState extends ConsumerState<CreateQuizFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _tagController = TextEditingController();
  int _currentStep = 0;
  final _uuid = const Uuid();

  @override
  void initState() {
    super.initState();
    // Check if quiz data is already filled (from AI generation)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(createQuizProvider);
      // If title and questions are already filled, start from questions step
      if (state.title.isNotEmpty && state.questions.isNotEmpty) {
        setState(() {
          _currentStep = 1; // Start from questions step
        });
        // Also populate the text controllers
        _titleController.text = state.title;
        if (state.description.isNotEmpty) {
          _descriptionController.text = state.description;
        }
      } else {
        // Otherwise, sync controllers with current state
        _titleController.text = state.title;
        if (state.description.isNotEmpty) {
          _descriptionController.text = state.description;
        }
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final createQuiz = ref.watch(createQuizProvider.notifier);
    final state = ref.watch(createQuizProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tạo Quiz Mới'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          // Progress Tracker
          _ProgressTracker(currentStep: _currentStep),
          
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _currentStep == 0
                  ? _buildBasicInfoStep()
                  : _currentStep == 1
                      ? _buildQuestionsStep()
                      : _currentStep == 2
                          ? _buildSettingsStep()
                          : _buildCompleteStep(),
            ),
          ),
          
          // Footer Buttons
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                if (_currentStep > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        if (_currentStep > 0) {
                          setState(() => _currentStep--);
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(
                          color: context.colorScheme.outline.withOpacity(0.3),
                        ),
                      ),
                      child: const Text('Hủy bỏ'),
                    ),
                  ),
                if (_currentStep > 0) const SizedBox(width: 12),
                Expanded(
                  flex: _currentStep == 0 ? 1 : 2,
                  child: ElevatedButton(
                    onPressed: _currentStep == 0
                        ? () {
                            if (_formKey.currentState!.validate()) {
                              createQuiz.updateTitle(_titleController.text);
                              createQuiz.updateDescription(_descriptionController.text);
                              setState(() => _currentStep++);
                            }
                          }
                        : _currentStep == 1
                            ? state.questions.isEmpty
                                ? null
                                : () {
                                    setState(() => _currentStep++);
                                  }
                            : _currentStep == 2
                                ? () {
                                    setState(() => _currentStep++);
                                  }
                                : () async {
                                    final result = await createQuiz.saveQuiz();
                                    if (mounted) {
                                      switch (result) {
                                        case Success(data: final quiz):
                                          context.showSuccessSnackBar('Tạo quiz thành công!');
                                          context.go(RouteConstants.quizDetailPath(quiz.id));
                                        case Failure(exception: final exception):
                                          context.showErrorSnackBar(exception.toString());
                                      }
                                    }
                                  },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      disabledBackgroundColor: context.colorScheme.surface.withOpacity(0.5),
                    ),
                    child: Text(
                      _currentStep == 3 ? 'Tạo Quiz' : 'Tiếp theo',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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

  Widget _buildBasicInfoStep() {
    final state = ref.watch(createQuizProvider);
    final categoriesAsync = ref.watch(categoriesProvider);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tiêu đề quiz *
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
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Tiêu đề quiz *',
                hintText: 'Nhập tiêu đề cho quiz của bạn',
                prefixIcon: Container(
                  margin: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.title,
                    color: AppColors.primary,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
              validator: Validators.quizTitle,
              maxLength: AppConstants.maxTitleLength,
            ),
          ),
          const SizedBox(height: 20),
          
          // Mô tả *
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
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Mô tả *',
                hintText: 'Mô tả ngắn gọn về nội dung quiz',
                prefixIcon: Container(
                  margin: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.description_outlined,
                    color: AppColors.primary,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
              validator: Validators.quizDescription,
              maxLength: AppConstants.maxDescriptionLength,
              maxLines: 3,
            ),
          ),
          const SizedBox(height: 20),
          
          // Danh mục
          Text(
            'Danh mục',
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          categoriesAsync.when(
            data: (categories) {
              return Container(
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
                child: DropdownButtonFormField<String>(
                  value: state.categoryId,
                  decoration: InputDecoration(
                    hintText: 'Chọn danh mục',
                    prefixIcon: Container(
                      margin: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.category_outlined,
                        color: AppColors.primary,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                  ),
                  items: [
                    const DropdownMenuItem<String>(
                      value: null,
                      child: Text('Chọn danh mục'),
                    ),
                    ...categories.map((category) => DropdownMenuItem<String>(
                          value: category.id,
                          child: Text(category.name),
                        )),
                  ],
                  onChanged: (value) {
                    ref.read(createQuizProvider.notifier).updateCategory(value);
                  },
                ),
              );
            },
            loading: () => const CircularProgressIndicator(),
            error: (_, __) => const Text('Không thể tải danh mục'),
          ),
          const SizedBox(height: 20),
          
          // Độ khó
          Text(
            'Độ khó',
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _DifficultyRadio(
                  label: 'Dễ',
                  value: Difficulty.easy,
                  selected: state.difficulty == Difficulty.easy,
                  onTap: () {
                    ref.read(createQuizProvider.notifier).updateDifficulty(Difficulty.easy);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _DifficultyRadio(
                  label: 'Trung bình',
                  value: Difficulty.medium,
                  selected: state.difficulty == Difficulty.medium,
                  onTap: () {
                    ref.read(createQuizProvider.notifier).updateDifficulty(Difficulty.medium);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _DifficultyRadio(
                  label: 'Khó',
                  value: Difficulty.hard,
                  selected: state.difficulty == Difficulty.hard,
                  onTap: () {
                    ref.read(createQuizProvider.notifier).updateDifficulty(Difficulty.hard);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Quyền riêng tư
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quyền riêng tư',
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    state.isPublic
                        ? 'Công khai - Mọi người có thể xem'
                        : 'Riêng tư - Chỉ bạn có thể xem',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
              Switch(
                value: state.isPublic,
                onChanged: (value) {
                  ref.read(createQuizProvider.notifier).updateIsPublic(value);
                },
                activeColor: AppColors.primary,
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Thẻ (Tags)
          Text(
            'Thẻ (Tags)',
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Container(
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
                  child: TextField(
                    controller: _tagController,
                    decoration: InputDecoration(
                      hintText: 'Thêm thẻ để dễ tìm kiếm',
                      prefixIcon: Container(
                        margin: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.tag_outlined,
                          color: AppColors.primary,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                    ),
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty) {
                        ref.read(createQuizProvider.notifier).addTag(value.trim());
                        _tagController.clear();
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (_tagController.text.trim().isNotEmpty) {
                      ref.read(createQuizProvider.notifier).addTag(_tagController.text.trim());
                      _tagController.clear();
                    }
                  },
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text(
                    'Thêm',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (state.tags.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: state.tags.map((tag) {
                return Chip(
                  label: Text(tag),
                  onDeleted: () {
                    ref.read(createQuizProvider.notifier).removeTag(tag);
                  },
                  deleteIcon: const Icon(Icons.close, size: 18),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuestionsStep() {
    final state = ref.watch(createQuizProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Câu hỏi (${state.questions.length})',
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        // Action Buttons
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  context.push(RouteConstants.aiGeneration);
                },
                icon: const Icon(Icons.auto_awesome),
                label: const Text('Tạo bằng AI'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  _showAddQuestionDialog();
                },
                icon: const Icon(Icons.add),
                label: const Text('Thêm câu hỏi'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.info,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 24),
        
        // Questions List or Empty State
        if (state.questions.isEmpty)
          _EmptyQuestionsState()
        else
          ...state.questions.asMap().entries.map((entry) {
            final index = entry.key;
            final question = entry.value;
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary,
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(question.question),
                subtitle: Text('${question.options.length} lựa chọn'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _showEditQuestionDialog(index, question);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        ref.read(createQuizProvider.notifier).removeQuestion(index);
                      },
                    ),
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }

  Widget _buildSettingsStep() {
    final state = ref.watch(createQuizProvider);
    final createQuiz = ref.read(createQuizProvider.notifier);
    
    return StatefulBuilder(
      builder: (context, setState) {
        final _passingScoreController = TextEditingController(text: '70');
        final _timeLimitController = TextEditingController(text: '10');
        bool _allowReview = true;
        bool _showExplanation = true;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        Text(
          'Cài đặt Quiz',
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        
        // Công khai
        _SettingItem(
          title: 'Công khai',
          description: 'Cho phép mọi người tìm và làm quiz',
          value: state.isPublic,
          onChanged: (value) => createQuiz.updateIsPublic(value),
        ),
        const SizedBox(height: 16),
        
        // Cho phép xem lại đáp án
        _SettingItem(
          title: 'Cho phép xem lại đáp án',
          description: 'Hiển thị đáp án sau khi hoàn thành',
          value: _allowReview,
          onChanged: (value) => setState(() => _allowReview = value),
        ),
        const SizedBox(height: 16),
        
        // Hiển thị giải thích
        _SettingItem(
          title: 'Hiển thị giải thích',
          description: 'Hiện giải thích cho mỗi câu hỏi',
          value: _showExplanation,
          onChanged: (value) => setState(() => _showExplanation = value),
        ),
        const SizedBox(height: 24),
        
        // Điểm đạt (%)
        Text(
          'Điểm đạt (%) *',
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
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
          child: TextField(
            controller: _passingScoreController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: '70',
              labelText: 'Điểm đạt (%)',
              prefixIcon: Container(
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.percent,
                  color: AppColors.primary,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        
        // Thời gian giới hạn
        Text(
          'Thời gian giới hạn (phút)',
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
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
          child: TextField(
            controller: _timeLimitController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: '10',
              labelText: 'Thời gian (phút)',
              prefixIcon: Container(
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.timer_outlined,
                  color: AppColors.primary,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Để trống nếu không giới hạn',
          style: context.textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
          ),
        ),
          ],
        );
      },
    );
  }

  Widget _buildCompleteStep() {
    final state = ref.watch(createQuizProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hoàn thành',
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tiêu đề: ${state.title}', style: context.textTheme.titleMedium),
                if (state.description.isNotEmpty)
                  Text('Mô tả: ${state.description}'),
                Text('Độ khó: ${state.difficulty.name}'),
                Text('Công khai: ${state.isPublic ? "Có" : "Không"}'),
                Text('Số câu hỏi: ${state.questions.length}'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showAddQuestionDialog() {
    _showQuestionDialog(null);
  }

  void _showEditQuestionDialog(int index, Question question) {
    _showQuestionDialog(question, index: index);
  }

  void _showQuestionDialog(Question? question, {int? index}) {
    final questionController = TextEditingController(text: question?.question ?? '');
    final explanationController = TextEditingController(text: question?.explanation ?? '');
    final pointsController = TextEditingController(text: (question?.points ?? 10).toString());
    final timeLimitController = TextEditingController(text: question?.timeLimit?.toString() ?? '');
    
    // Initialize options - ensure at least 4 for multiple choice
    final initialOptions = question?.options ?? ['', '', '', ''];
    final optionsControllers = initialOptions.map((opt) {
      return TextEditingController(text: opt);
    }).toList();
    
    var correctIndex = question?.correctAnswerIndex ?? 0;
    var questionType = question?.type ?? QuestionType.multipleChoice;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.9,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // AppBar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                        color: Colors.black87,
                      ),
                      Expanded(
                        child: Text(
                          question == null ? 'Thêm câu hỏi mới' : 'Sửa câu hỏi',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          if (questionController.text.isEmpty) {
                            context.showErrorSnackBar('Câu hỏi là bắt buộc');
                            return;
                          }
                          if (optionsControllers.length < 2) {
                            context.showErrorSnackBar('Cần ít nhất 2 lựa chọn');
                            return;
                          }
                          if (optionsControllers.any((c) => c.text.trim().isEmpty)) {
                            context.showErrorSnackBar('Tất cả lựa chọn phải được điền');
                            return;
                          }

                          final newQuestion = Question(
                            id: question?.id ?? _uuid.v4(),
                            quizId: '',
                            question: questionController.text.trim(),
                            type: questionType,
                            options: optionsControllers.map((c) => c.text.trim()).toList(),
                            correctAnswerIndex: correctIndex,
                            explanation: explanationController.text.trim().isEmpty
                                ? null
                                : explanationController.text.trim(),
                            points: int.tryParse(pointsController.text) ?? 10,
                            timeLimit: timeLimitController.text.trim().isEmpty
                                ? null
                                : int.tryParse(timeLimitController.text.trim()),
                          );

                          if (index != null) {
                            ref.read(createQuizProvider.notifier).updateQuestion(index, newQuestion);
                          } else {
                            ref.read(createQuizProvider.notifier).addQuestion(newQuestion);
                          }

                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.folder_outlined, size: 18),
                        label: const Text(
                          'Lưu',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.lightPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Content
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Loại câu hỏi Section
                        const Text(
                          'Loại câu hỏi',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setDialogState(() {
                                    questionType = QuestionType.multipleChoice;
                                    if (optionsControllers.length < 4) {
                                      while (optionsControllers.length < 4) {
                                        optionsControllers.add(TextEditingController());
                                      }
                                    }
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: questionType == QuestionType.multipleChoice
                                        ? AppColors.lightPrimary.withOpacity(0.1)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: questionType == QuestionType.multipleChoice
                                          ? AppColors.lightPrimary
                                          : Colors.grey[300]!,
                                      width: questionType == QuestionType.multipleChoice ? 2 : 1,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 24,
                                            height: 24,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: questionType == QuestionType.multipleChoice
                                                  ? AppColors.lightPrimary
                                                  : Colors.transparent,
                                              border: Border.all(
                                                color: questionType == QuestionType.multipleChoice
                                                    ? AppColors.lightPrimary
                                                    : Colors.grey[400]!,
                                                width: 2,
                                              ),
                                            ),
                                            child: questionType == QuestionType.multipleChoice
                                                ? const Icon(
                                                    Icons.check,
                                                    size: 16,
                                                    color: Colors.white,
                                                  )
                                                : null,
                                          ),
                                          const SizedBox(width: 12),
                                          const Expanded(
                                            child: Text(
                                              'Trắc nghiệm',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 36),
                                          child: Text(
                                            'Nhiều lựa chọn (A, B, C, D)',
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setDialogState(() {
                                    questionType = QuestionType.trueFalse;
                                    optionsControllers.clear();
                                    optionsControllers.add(TextEditingController(text: 'Đúng'));
                                    optionsControllers.add(TextEditingController(text: 'Sai'));
                                    if (correctIndex >= 2) correctIndex = 0;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: questionType == QuestionType.trueFalse
                                        ? AppColors.lightPrimary.withOpacity(0.1)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: questionType == QuestionType.trueFalse
                                          ? AppColors.lightPrimary
                                          : Colors.grey[300]!,
                                      width: questionType == QuestionType.trueFalse ? 2 : 1,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            questionType == QuestionType.trueFalse
                                                ? Icons.check_box
                                                : Icons.check_box_outline_blank,
                                            color: questionType == QuestionType.trueFalse
                                                ? AppColors.lightPrimary
                                                : Colors.grey[400],
                                            size: 24,
                                          ),
                                          const SizedBox(width: 12),
                                          const Expanded(
                                            child: Text(
                                              'Đúng/Sai',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 36),
                                          child: Text(
                                            'Chỉ có 2 lựa chọn',
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        
                        // Câu hỏi Section
                        const Text(
                          'Câu hỏi *',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
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
                          child: TextField(
                            controller: questionController,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Nhập nội dung câu hỏi của bạn...',
                              hintStyle: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 15,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.all(20),
                            ),
                            maxLines: 3,
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Các lựa chọn Section
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Các lựa chọn *',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF9C27B0).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  // Show dialog to select correct answer
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Chọn đáp án đúng'),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: optionsControllers.asMap().entries.map((entry) {
                                          final idx = entry.key;
                                          final letter = String.fromCharCode(65 + idx); // A, B, C, D
                                          return ListTile(
                                            leading: Container(
                                              width: 40,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                color: correctIndex == idx
                                                    ? AppColors.success
                                                    : Colors.grey[300],
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  letter,
                                                  style: TextStyle(
                                                    color: correctIndex == idx
                                                        ? Colors.white
                                                        : Colors.grey[700],
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            title: Text(entry.value.text.isEmpty
                                                ? 'Lựa chọn $letter'
                                                : entry.value.text),
                                            trailing: correctIndex == idx
                                                ? const Icon(Icons.check, color: AppColors.success)
                                                : null,
                                            onTap: () {
                                              setDialogState(() => correctIndex = idx);
                                              Navigator.pop(context);
                                            },
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Chọn đáp án đúng',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF9C27B0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ...optionsControllers.asMap().entries.map((entry) {
                          final idx = entry.key;
                          final letter = String.fromCharCode(65 + idx); // A, B, C, D
                          final isCorrect = correctIndex == idx;
                          
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isCorrect
                                      ? AppColors.success
                                      : Colors.grey[300]!,
                                  width: isCorrect ? 2 : 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: isCorrect
                                        ? AppColors.success.withOpacity(0.2)
                                        : Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: isCorrect
                                            ? AppColors.success
                                            : Colors.grey[300],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          letter,
                                          style: TextStyle(
                                            color: isCorrect
                                                ? Colors.white
                                                : Colors.grey[700],
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: TextField(
                                      controller: entry.value,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.black87,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: 'Nhập nội dung lựa chọn $letter...',
                                        hintStyle: TextStyle(
                                          color: Colors.grey[400],
                                          fontSize: 14,
                                        ),
                                        border: InputBorder.none,
                                        contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 16,
                                        ),
                                      ),
                                      onTap: () {
                                        setDialogState(() => correctIndex = idx);
                                      },
                                    ),
                                  ),
                                  if (isCorrect)
                                    Padding(
                                      padding: const EdgeInsets.only(right: 12),
                                      child: Icon(
                                        Icons.check_circle,
                                        color: AppColors.success,
                                        size: 24,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        }),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            TextButton.icon(
                              onPressed: optionsControllers.length < AppConstants.maxOptionsPerQuestion
                                  ? () {
                                      setDialogState(() {
                                        optionsControllers.add(TextEditingController());
                                      });
                                    }
                                  : null,
                              icon: const Icon(Icons.add, size: 18),
                              label: const Text('Thêm lựa chọn'),
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.lightPrimary,
                              ),
                            ),
                            const Spacer(),
                            if (optionsControllers.length > 2)
                              TextButton.icon(
                                onPressed: () {
                                  setDialogState(() {
                                    final lastIndex = optionsControllers.length - 1;
                                    optionsControllers.removeAt(lastIndex);
                                    if (correctIndex >= optionsControllers.length) {
                                      correctIndex = optionsControllers.length - 1;
                                    }
                                  });
                                },
                                icon: const Icon(Icons.remove, size: 18),
                                label: const Text('Xóa lựa chọn cuối'),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.red,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        
                        // Cài đặt câu hỏi Section
                        const Text(
                          'Cài đặt câu hỏi',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Điểm số',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.grey[300]!),
                                    ),
                                    child: TextField(
                                      controller: pointsController,
                                      keyboardType: TextInputType.number,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.black87,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: '10',
                                        border: InputBorder.none,
                                        contentPadding: const EdgeInsets.all(12),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Thời gian (giây)',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.grey[300]!),
                                    ),
                                    child: TextField(
                                      controller: timeLimitController,
                                      keyboardType: TextInputType.number,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.black87,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: '30',
                                        border: InputBorder.none,
                                        contentPadding: const EdgeInsets.all(12),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Progress Tracker
class _ProgressTracker extends StatelessWidget {
  final int currentStep;

  const _ProgressTracker({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _ProgressStep(
            number: 1,
            label: 'Thông tin cơ bản',
            isActive: currentStep == 0,
            isCompleted: currentStep > 0,
          ),
          Expanded(
            child: Container(
              height: 2,
              color: currentStep > 0
                  ? AppColors.primary
                  : context.colorScheme.outline.withOpacity(0.3),
            ),
          ),
          _ProgressStep(
            number: 2,
            label: 'Câu hỏi',
            isActive: currentStep == 1,
            isCompleted: currentStep > 1,
          ),
          Expanded(
            child: Container(
              height: 2,
              color: currentStep > 1
                  ? AppColors.primary
                  : context.colorScheme.outline.withOpacity(0.3),
            ),
          ),
          _ProgressStep(
            number: 3,
            label: 'Cài đặt',
            isActive: currentStep == 2,
            isCompleted: currentStep > 2,
          ),
          Expanded(
            child: Container(
              height: 2,
              color: currentStep > 2
                  ? AppColors.primary
                  : context.colorScheme.outline.withOpacity(0.3),
            ),
          ),
          _ProgressStep(
            number: 4,
            label: 'Hoàn thành',
            isActive: currentStep == 3,
            isCompleted: false,
          ),
        ],
      ),
    );
  }
}

class _ProgressStep extends StatelessWidget {
  final int number;
  final String label;
  final bool isActive;
  final bool isCompleted;

  const _ProgressStep({
    required this.number,
    required this.label,
    required this.isActive,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isActive || isCompleted
                ? AppColors.primary
                : context.colorScheme.surface,
            shape: BoxShape.circle,
            border: Border.all(
              color: isActive || isCompleted
                  ? AppColors.primary
                  : context.colorScheme.outline.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: isCompleted
              ? const Icon(Icons.check, color: Colors.white, size: 20)
              : Center(
                  child: Text(
                    '$number',
                    style: TextStyle(
                      color: isActive ? Colors.white : context.colorScheme.onSurface.withOpacity(0.5),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: context.textTheme.bodySmall?.copyWith(
            color: isActive
                ? AppColors.primary
                : context.colorScheme.onSurface.withOpacity(0.5),
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

/// Difficulty Radio Button
class _DifficultyRadio extends StatelessWidget {
  final String label;
  final Difficulty value;
  final bool selected;
  final VoidCallback onTap;

  const _DifficultyRadio({
    required this.label,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withOpacity(0.1)
              : context.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected
                ? AppColors.primary
                : context.colorScheme.outline.withOpacity(0.3),
            width: selected ? 2 : 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: context.textTheme.bodyMedium?.copyWith(
              color: selected
                  ? AppColors.primary
                  : context.colorScheme.onSurface,
              fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

/// Empty Questions State
class _EmptyQuestionsState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: context.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.help_outline,
              size: 40,
              color: context.colorScheme.onSurface.withOpacity(0.3),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Chưa có câu hỏi nào',
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Thêm ít nhất 1 câu hỏi để có thể tạo quiz',
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingItem extends StatelessWidget {
  const _SettingItem({
    required this.title,
    required this.description,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String description;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Transform.scale(
            scale: 1.2,
            child: Checkbox(
              value: value,
              onChanged: (newValue) => onChanged(newValue ?? false),
              activeColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
