/// Form validation utilities
class Validators {
  Validators._();

  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    return null;
  }

  static String? minLength(String? value, int min, {String? fieldName}) {
    if (value == null || value.length < min) {
      return '${fieldName ?? 'This field'} must be at least $min characters';
    }
    return null;
  }

  static String? maxLength(String? value, int max, {String? fieldName}) {
    if (value == null || value.length > max) {
      return '${fieldName ?? 'This field'} must not exceed $max characters';
    }
    return null;
  }

  static String? length(String? value, int length, {String? fieldName}) {
    if (value == null || value.length != length) {
      return '${fieldName ?? 'This field'} must be exactly $length characters';
    }
    return null;
  }

  static String? range(int? value, int min, int max, {String? fieldName}) {
    if (value == null) {
      return '${fieldName ?? 'This field'} is required';
    }
    if (value < min || value > max) {
      return '${fieldName ?? 'This field'} must be between $min and $max';
    }
    return null;
  }

  static String? url(String? value) {
    if (value == null || value.isEmpty) {
      return 'URL is required';
    }
    final urlRegex = RegExp(
      r'^https?://[^\s/$.?#].[^\s]*$',
    );
    if (!urlRegex.hasMatch(value)) {
      return 'Please enter a valid URL';
    }
    return null;
  }

  static String? quizTitle(String? value) {
    return required(value, fieldName: 'Title') ??
        maxLength(value, 100, fieldName: 'Title');
  }

  static String? quizDescription(String? value) {
    if (value != null && value.isNotEmpty) {
      return maxLength(value, 500, fieldName: 'Description');
    }
    return null;
  }

  static String? questionText(String? value) {
    return required(value, fieldName: 'Question') ??
        maxLength(value, 500, fieldName: 'Question');
  }

  static String? optionText(String? value) {
    return required(value, fieldName: 'Option') ??
        maxLength(value, 200, fieldName: 'Option');
  }
}






