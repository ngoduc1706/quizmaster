import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:doanlaptrinh/core/constants/route_constants.dart';
import 'package:doanlaptrinh/core/extensions/context_extensions.dart';
import 'package:doanlaptrinh/core/theme/app_colors.dart';
import 'package:doanlaptrinh/core/widgets/error_view.dart';
import 'package:doanlaptrinh/core/widgets/loading_indicator.dart';
import 'package:doanlaptrinh/features/quiz/domain/entities/question.dart';
import 'package:doanlaptrinh/features/quiz/presentation/controllers/question_management_controller.dart';

/// Manage Questions Page for existing quiz
class ManageQuestionsPage extends ConsumerStatefulWidget {
  const ManageQuestionsPage({
    super.key,
    this.quizId,
  });

  final String? quizId;

  @override
  ConsumerState<ManageQuestionsPage> createState() => _ManageQuestionsPageState();
}

class _ManageQuestionsPageState extends ConsumerState<ManageQuestionsPage> {
  int? _editingQuestionIndex;

  @override
  Widget build(BuildContext context) {
    if (widget.quizId == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Quản lý câu hỏi'),
        ),
        body: const Center(
          child: Text('Không tìm thấy quiz'),
        ),
      );
    }

    final questionsAsync = ref.watch(quizQuestionsProvider(widget.quizId!));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý câu hỏi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              setState(() {
                _editingQuestionIndex = null;
              });
              _showAddQuestionDialog();
            },
          ),
        ],
      ),
      body: questionsAsync.when(
        data: (questions) {
          if (questions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.quiz_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Chưa có câu hỏi nào',
                    style: context.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Nhấn nút + để thêm câu hỏi đầu tiên',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => _showAddQuestionDialog(),
                    icon: const Icon(Icons.add),
                    label: const Text('Thêm câu hỏi'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: questions.length,
            itemBuilder: (context, index) {
              final question = questions[index];
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
                  title: Text(
                    question.question,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    '${question.options.length} lựa chọn • ${question.points} điểm',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          setState(() {
                            _editingQuestionIndex = index;
                          });
                          _showEditQuestionDialog(question, index);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _showDeleteConfirmation(question),
                      ),
                    ],
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
        loading: () => const Center(child: LoadingIndicator()),
        error: (error, stack) => ErrorView(
          message: error.toString(),
          onRetry: () {
            ref.invalidate(quizQuestionsProvider(widget.quizId!));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddQuestionDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddQuestionDialog() {
    showDialog(
      context: context,
      builder: (context) => _QuestionFormDialog(
        quizId: widget.quizId!,
        question: null,
        onSaved: () {
          ref.invalidate(quizQuestionsProvider(widget.quizId!));
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showEditQuestionDialog(Question question, int index) {
    showDialog(
      context: context,
      builder: (context) => _QuestionFormDialog(
        quizId: widget.quizId!,
        question: question,
        onSaved: () {
          ref.invalidate(quizQuestionsProvider(widget.quizId!));
          Navigator.pop(context);
          setState(() {
            _editingQuestionIndex = null;
          });
        },
      ),
    );
  }

  void _showDeleteConfirmation(Question question) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc chắn muốn xóa câu hỏi này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              
              if (!context.mounted) return;
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (loadingContext) => const Center(
                  child: CircularProgressIndicator(),
                ),
              );

              try {
                await ref.read(deleteQuestionProvider(question.id).future);
                if (!context.mounted) return;
                Navigator.pop(context);
                ref.invalidate(quizQuestionsProvider(widget.quizId!));
                context.showSuccessSnackBar('Đã xóa câu hỏi thành công');
              } catch (e) {
                if (!context.mounted) return;
                Navigator.pop(context);
                context.showErrorSnackBar('Lỗi: ${e.toString()}');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }
}

class _QuestionFormDialog extends ConsumerStatefulWidget {
  const _QuestionFormDialog({
    required this.quizId,
    this.question,
    required this.onSaved,
  });

  final String quizId;
  final Question? question;
  final VoidCallback onSaved;

  @override
  ConsumerState<_QuestionFormDialog> createState() => _QuestionFormDialogState();
}

class _QuestionFormDialogState extends ConsumerState<_QuestionFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _questionController;
  late final List<TextEditingController> _optionControllers;
  late final TextEditingController _pointsController;
  late final TextEditingController _timeLimitController;
  late final TextEditingController _explanationController;

  QuestionType _questionType = QuestionType.multipleChoice;
  int _correctAnswerIndex = 0;

  @override
  void initState() {
    super.initState();
    _questionController = TextEditingController(
      text: widget.question?.question ?? '',
    );
    _pointsController = TextEditingController(
      text: widget.question?.points.toString() ?? '10',
    );
    _timeLimitController = TextEditingController(
      text: widget.question?.timeLimit?.toString() ?? '',
    );
    _explanationController = TextEditingController(
      text: widget.question?.explanation ?? '',
    );

    if (widget.question != null) {
      _questionType = widget.question!.type;
      _correctAnswerIndex = widget.question!.correctAnswerIndex;
      _optionControllers = widget.question!.options
          .map((opt) => TextEditingController(text: opt))
          .toList();
    } else {
      _optionControllers = [
        TextEditingController(),
        TextEditingController(),
        TextEditingController(),
        TextEditingController(),
      ];
    }
  }

  @override
  void dispose() {
    _questionController.dispose();
    _pointsController.dispose();
    _timeLimitController.dispose();
    _explanationController.dispose();
    for (var controller in _optionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _saveQuestion() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_questionController.text.trim().isEmpty) {
      context.showErrorSnackBar('Vui lòng nhập câu hỏi');
      return;
    }

    if (_optionControllers.length < 2) {
      context.showErrorSnackBar('Cần ít nhất 2 lựa chọn');
      return;
    }

    if (_optionControllers.any((c) => c.text.trim().isEmpty)) {
      context.showErrorSnackBar('Tất cả lựa chọn phải được điền');
      return;
    }

    final question = Question(
      id: widget.question?.id ?? const Uuid().v4(),
      quizId: widget.quizId,
      question: _questionController.text.trim(),
      type: _questionType,
      options: _optionControllers.map((c) => c.text.trim()).toList(),
      correctAnswerIndex: _correctAnswerIndex,
      explanation: _explanationController.text.trim().isNotEmpty
          ? _explanationController.text.trim()
          : null,
      points: int.tryParse(_pointsController.text) ?? 10,
      timeLimit: _timeLimitController.text.isNotEmpty
          ? int.tryParse(_timeLimitController.text)
          : null,
      order: widget.question?.order ?? 0,
    );

    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (loadingContext) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      if (widget.question != null) {
        await ref.read(updateQuestionProvider(question).future);
      } else {
        await ref.read(createQuestionProvider(question).future);
      }

      if (!mounted) return;
      Navigator.pop(context); // Close loading
      widget.onSaved();
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Close loading
      context.showErrorSnackBar('Lỗi: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              title: Text(widget.question == null ? 'Thêm câu hỏi' : 'Sửa câu hỏi'),
              actions: [
                TextButton(
                  onPressed: _saveQuestion,
                  child: const Text('Lưu'),
                ),
              ],
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Question Type
                      Text(
                        'Loại câu hỏi',
                        style: context.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: ChoiceChip(
                              label: const Text('Trắc nghiệm'),
                              selected: _questionType == QuestionType.multipleChoice,
                              onSelected: (selected) {
                                if (selected) {
                                  setState(() {
                                    _questionType = QuestionType.multipleChoice;
                                    if (_optionControllers.length < 4) {
                                      while (_optionControllers.length < 4) {
                                        _optionControllers.add(TextEditingController());
                                      }
                                    }
                                  });
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ChoiceChip(
                              label: const Text('Đúng/Sai'),
                              selected: _questionType == QuestionType.trueFalse,
                              onSelected: (selected) {
                                if (selected) {
                                  setState(() {
                                    _questionType = QuestionType.trueFalse;
                                    _optionControllers.clear();
                                    _optionControllers.add(
                                      TextEditingController(text: 'Đúng'),
                                    );
                                    _optionControllers.add(
                                      TextEditingController(text: 'Sai'),
                                    );
                                    _correctAnswerIndex = 0;
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Question Text
                      TextFormField(
                        controller: _questionController,
                        decoration: const InputDecoration(
                          labelText: 'Câu hỏi *',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Vui lòng nhập câu hỏi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Options
                      Text(
                        'Các lựa chọn *',
                        style: context.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      ..._optionControllers.asMap().entries.map((entry) {
                        final index = entry.key;
                        final controller = entry.value;
                        final isCorrect = index == _correctAnswerIndex;
                        final label = String.fromCharCode(65 + index);

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isCorrect
                                      ? AppColors.success
                                      : Colors.grey[300],
                                ),
                                child: Center(
                                  child: Text(
                                    label,
                                    style: TextStyle(
                                      color: isCorrect ? Colors.white : Colors.black87,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextFormField(
                                  controller: controller,
                                  decoration: InputDecoration(
                                    hintText: 'Lựa chọn $label',
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: isCorrect
                                            ? AppColors.success
                                            : Colors.grey,
                                        width: isCorrect ? 2 : 1,
                                      ),
                                    ),
                                    suffixIcon: isCorrect
                                        ? const Icon(
                                            Icons.check_circle,
                                            color: AppColors.success,
                                          )
                                        : null,
                                  ),
                                  onTap: () {
                                    setState(() {
                                      _correctAnswerIndex = index;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Vui lòng nhập lựa chọn';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      
                      if (_questionType == QuestionType.multipleChoice) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            TextButton(
                              onPressed: _optionControllers.length < 6
                                  ? () {
                                      setState(() {
                                        _optionControllers.add(TextEditingController());
                                      });
                                    }
                                  : null,
                              child: const Text('+ Thêm lựa chọn'),
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: _optionControllers.length > 2
                                  ? () {
                                      setState(() {
                                        if (_correctAnswerIndex >=
                                            _optionControllers.length - 1) {
                                          _correctAnswerIndex =
                                              _optionControllers.length - 2;
                                        }
                                        _optionControllers.removeLast().dispose();
                                      });
                                    }
                                  : null,
                              child: const Text(
                                'Xóa lựa chọn',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      ],
                      
                      const SizedBox(height: 16),
                      
                      // Points and Time Limit
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _pointsController,
                              decoration: const InputDecoration(
                                labelText: 'Điểm số',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: _timeLimitController,
                              decoration: const InputDecoration(
                                labelText: 'Thời gian (giây)',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Explanation
                      TextFormField(
                        controller: _explanationController,
                        decoration: const InputDecoration(
                          labelText: 'Giải thích (Tùy chọn)',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
