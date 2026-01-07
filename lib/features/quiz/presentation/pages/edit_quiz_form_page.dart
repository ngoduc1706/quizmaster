import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:doanlaptrinh/core/constants/app_constants.dart';
import 'package:doanlaptrinh/core/constants/route_constants.dart';
import 'package:doanlaptrinh/core/extensions/context_extensions.dart';
import 'package:doanlaptrinh/core/theme/app_colors.dart';
import 'package:doanlaptrinh/core/utils/validators.dart';
import 'package:doanlaptrinh/core/errors/result.dart';
import 'package:doanlaptrinh/features/quiz/domain/entities/quiz.dart';
import 'package:doanlaptrinh/features/quiz/presentation/controllers/quiz_edit_controller.dart';
import 'package:doanlaptrinh/features/quiz/presentation/controllers/category_controller.dart';
import 'package:doanlaptrinh/features/quiz/presentation/controllers/quiz_list_controller.dart';

/// Edit quiz form page
class EditQuizFormPage extends ConsumerStatefulWidget {
  const EditQuizFormPage({
    super.key,
    required this.quizId,
    this.quiz,
  });

  final String quizId;
  final Quiz? quiz;

  @override
  ConsumerState<EditQuizFormPage> createState() => _EditQuizFormPageState();
}

class _EditQuizFormPageState extends ConsumerState<EditQuizFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _tagController;
  
  String? _selectedCategoryId;
  Difficulty _selectedDifficulty = Difficulty.medium;
  bool _isPublic = true;
  List<String> _tags = [];

  @override
  void initState() {
    super.initState();
    // Initialize with quiz data if available
    if (widget.quiz != null) {
      final quiz = widget.quiz!;
      _titleController = TextEditingController(text: quiz.title);
      _descriptionController = TextEditingController(text: quiz.description ?? '');
      _selectedCategoryId = quiz.categoryId;
      _selectedDifficulty = quiz.difficulty;
      _isPublic = quiz.isPublic;
      _tags = List<String>.from(quiz.tags);
      _tagController = TextEditingController();
    } else {
      _titleController = TextEditingController();
      _descriptionController = TextEditingController();
      _tagController = TextEditingController();
    }
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
    final quizAsync = widget.quiz != null
        ? AsyncValue.data(widget.quiz!)
        : ref.watch(quizByIdProvider(widget.quizId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chỉnh sửa Quiz'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: quizAsync.when(
        data: (quiz) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Tiêu đề quiz *',
                    hintText: 'Nhập tiêu đề cho quiz của bạn',
                    border: OutlineInputBorder(),
                  ),
                  validator: Validators.quizTitle,
                  maxLength: AppConstants.maxTitleLength,
                ),
                const SizedBox(height: 20),
                
                // Description
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Mô tả *',
                    hintText: 'Mô tả ngắn gọn về nội dung quiz',
                    border: OutlineInputBorder(),
                  ),
                  validator: Validators.quizDescription,
                  maxLength: AppConstants.maxDescriptionLength,
                  maxLines: 3,
                ),
                const SizedBox(height: 20),
                
                // Category
                Text(
                  'Danh mục',
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                ref.watch(categoriesProvider).when(
                  data: (categories) => DropdownButtonFormField<String>(
                    value: _selectedCategoryId,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Chọn danh mục',
                    ),
                    items: [
                      const DropdownMenuItem<String>(
                        value: null,
                        child: Text('Không có danh mục'),
                      ),
                      ...categories.map((category) {
                        return DropdownMenuItem<String>(
                          value: category.id,
                          child: Text(category.name),
                        );
                      }),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedCategoryId = value;
                      });
                    },
                  ),
                  loading: () => const LinearProgressIndicator(),
                  error: (_, __) => const Text('Lỗi tải danh mục'),
                ),
                const SizedBox(height: 20),
                
                // Difficulty
                Text(
                  'Độ khó',
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                SegmentedButton<Difficulty>(
                  segments: const [
                    ButtonSegment(
                      value: Difficulty.easy,
                      label: Text('Dễ'),
                    ),
                    ButtonSegment(
                      value: Difficulty.medium,
                      label: Text('Trung bình'),
                    ),
                    ButtonSegment(
                      value: Difficulty.hard,
                      label: Text('Khó'),
                    ),
                  ],
                  selected: {_selectedDifficulty},
                  onSelectionChanged: (Set<Difficulty> newSelection) {
                    setState(() {
                      _selectedDifficulty = newSelection.first;
                    });
                  },
                ),
                const SizedBox(height: 20),
                
                // Privacy
                SwitchListTile(
                  title: const Text('Công khai'),
                  subtitle: const Text('Cho phép mọi người xem và làm quiz này'),
                  value: _isPublic,
                  onChanged: (value) {
                    setState(() {
                      _isPublic = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                
                // Tags
                Text(
                  'Thẻ (Tags)',
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ..._tags.map((tag) => Chip(
                      label: Text(tag),
                      onDeleted: () {
                        setState(() {
                          _tags.remove(tag);
                        });
                      },
                    )),
                    InputChip(
                      label: const Text('+ Thêm thẻ'),
                      onSelected: (_) => _showAddTagDialog(),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                
                // Save button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _saveQuiz(quiz),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Lưu thay đổi',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Lỗi: ${error.toString()}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(quizByIdProvider(widget.quizId));
                },
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddTagDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Thêm thẻ'),
        content: TextField(
          controller: _tagController,
          decoration: const InputDecoration(
            labelText: 'Tên thẻ',
            hintText: 'Nhập tên thẻ',
          ),
          onSubmitted: (_) => _addTag(dialogContext),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () => _addTag(dialogContext),
            child: const Text('Thêm'),
          ),
        ],
      ),
    );
  }

  void _addTag(BuildContext dialogContext) {
    final tag = _tagController.text.trim();
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
      });
      _tagController.clear();
      Navigator.pop(dialogContext);
    } else if (_tags.contains(tag)) {
      context.showErrorSnackBar('Thẻ này đã tồn tại');
    }
  }

  Future<void> _saveQuiz(Quiz originalQuiz) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final updatedQuiz = originalQuiz.copyWith(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      categoryId: _selectedCategoryId,
      difficulty: _selectedDifficulty,
      isPublic: _isPublic,
      tags: _tags,
      updatedAt: DateTime.now(),
    );

    // Show loading
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (loadingContext) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    final result = await ref.read(updateQuizProvider(updatedQuiz).future);

    if (!mounted) return;
    Navigator.pop(context); // Close loading

    switch (result) {
      case Success(data: final quiz):
        if (mounted) {
          context.showSuccessSnackBar('Cập nhật quiz thành công!');
          context.pop(); // Go back to detail page
        }
      case Failure(exception: final exception):
        if (mounted) {
          context.showErrorSnackBar('Lỗi: ${exception.toString()}');
        }
    }
  }
}
