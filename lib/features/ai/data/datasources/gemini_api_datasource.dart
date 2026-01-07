import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:doanlaptrinh/core/constants/app_constants.dart';
import 'package:doanlaptrinh/core/errors/app_exceptions.dart';
import 'package:doanlaptrinh/core/errors/result.dart';
import 'package:doanlaptrinh/core/utils/logger.dart';

/// Gemini API data source
class GeminiApiDataSource {
  GeminiApiDataSource({
    required Dio dio,
    required String apiKey,
  })  : _dio = dio,
        _apiKey = apiKey;

  final Dio _dio;
  final String _apiKey;

  /// Generate quiz using Gemini API
  Future<Result<Map<String, dynamic>>> generateQuiz({
    required String topic,
    required int questionCount,
    String difficulty = 'medium',
    String language = 'en',
    List<String> questionTypes = const ['multipleChoice'],
  }) async {
    try {
      final prompt = _buildPrompt(
        topic: topic,
        questionCount: questionCount,
        difficulty: difficulty,
        language: language,
        questionTypes: questionTypes,
      );

      final response = await _dio.post(
        'https://generativelanguage.googleapis.com/v1/models/gemini-2.5-flash:generateContent?key=$_apiKey',
        data: {
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.7,
            'topK': 40,
            'topP': 0.95,
            'maxOutputTokens': 8192,
          },
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
          receiveTimeout: Duration(seconds: AppConstants.aiRequestTimeoutSeconds),
          sendTimeout: Duration(seconds: AppConstants.aiRequestTimeoutSeconds),
        ),
      );

      if (response.statusCode == 200) {
        final content = response.data['candidates']?[0]?['content']?['parts']?[0]?['text'];
        if (content != null) {
          // Parse JSON from response
          final jsonString = _extractJson(content);
          final quizData = json.decode(jsonString) as Map<String, dynamic>;
          return Success(quizData);
        }
        return const Failure(AIException('Invalid response format'));
      } else {
        return Failure(AIException('API request failed: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return Failure(AIException.timeout());
      }
      AppLogger.error('Gemini API error', e);
      return Failure(AIException.apiError(e.message));
    } catch (e, stackTrace) {
      AppLogger.error('Generate quiz error', e, stackTrace);
      return Failure(AIException('Failed to generate quiz: ${e.toString()}'));
    }
  }

  String _buildPrompt({
    required String topic,
    required int questionCount,
    required String difficulty,
    required String language,
    required List<String> questionTypes,
  }) {
    final difficultyMap = {
      'easy': 'dễ',
      'medium': 'trung bình',
      'hard': 'khó',
    };
    
    return '''
Tạo một bộ quiz về chủ đề "$topic" bằng tiếng Việt với các yêu cầu sau:
- Số câu hỏi: $questionCount
- Độ khó: ${difficultyMap[difficulty] ?? difficulty}
- Ngôn ngữ: Tiếng Việt
- Loại câu hỏi: Trắc nghiệm 4 đáp án

Trả về kết quả dưới dạng JSON với cấu trúc chính xác như sau:
{
  "title": "Tiêu đề quiz (tiếng Việt)",
  "description": "Mô tả ngắn gọn về quiz (tiếng Việt)",
  "difficulty": "$difficulty",
  "questions": [
    {
      "question": "Nội dung câu hỏi (tiếng Việt)",
      "type": "multipleChoice",
      "options": ["Đáp án A", "Đáp án B", "Đáp án C", "Đáp án D"],
      "correctAnswerIndex": 0,
      "explanation": "Giải thích đáp án đúng (tiếng Việt)",
      "points": 20,
      "timeLimit": 60
    }
  ]
}

Lưu ý quan trọng:
- TẤT CẢ nội dung phải bằng TIẾNG VIỆT
- Các câu hỏi phải liên quan đến chủ đề "$topic"
- Độ khó phù hợp với cấp độ ${difficultyMap[difficulty] ?? difficulty}
- Mỗi câu hỏi có 4 đáp án
- correctAnswerIndex là chỉ số (0-3) của đáp án đúng trong mảng options
- Mỗi câu hỏi có giải thích rõ ràng
- Mỗi câu hỏi có 20 điểm
- Thời gian mỗi câu là 60 giây
- Chỉ trả về JSON thuần túy, KHÔNG thêm markdown hay text khác
''';
  }

  String _extractJson(String content) {
    // Try to extract JSON from markdown code blocks or plain text
    final jsonMatch = RegExp(r'```(?:json)?\s*(\{[\s\S]*\})\s*```').firstMatch(content);
    if (jsonMatch != null) {
      return jsonMatch.group(1)!;
    }

    // Try to find JSON object directly
    final jsonObjectMatch = RegExp(r'\{[\s\S]*\}').firstMatch(content);
    if (jsonObjectMatch != null) {
      return jsonObjectMatch.group(0)!;
    }

    return content;
  }
}


