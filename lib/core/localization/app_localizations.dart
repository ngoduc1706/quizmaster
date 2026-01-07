import 'package:flutter/material.dart';

/// Simple localization class for app strings
class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  // Vietnamese translations
  static final Map<String, Map<String, String>> _localizedValues = {
    'vi': {
      // Common
      'app_name': 'QuizMaster',
      'welcome': 'Chào mừng',
      'login': 'Đăng nhập',
      'signup': 'Đăng ký',
      'logout': 'Đăng xuất',
      'settings': 'Cài đặt',
      'profile': 'Hồ sơ',
      'home': 'Trang chủ',
      'cancel': 'Hủy',
      'save': 'Lưu',
      'delete': 'Xóa',
      'edit': 'Chỉnh sửa',
      'create': 'Tạo',
      'search': 'Tìm kiếm',
      
      // Settings
      'account': 'Tài khoản',
      'edit_profile': 'Chỉnh sửa hồ sơ',
      'update_personal_info': 'Cập nhật thông tin cá nhân',
      'notifications': 'Thông báo',
      'manage_notifications': 'Quản lý thông báo',
      'interface': 'Giao diện',
      'dark_mode': 'Chế độ tối',
      'toggle_dark_mode': 'Bật/tắt giao diện tối',
      'language': 'Ngôn ngữ',
      'security': 'Bảo mật',
      'change_password': 'Đổi mật khẩu',
      'update_account_password': 'Cập nhật mật khẩu tài khoản',
      'account_security': 'Bảo mật tài khoản',
      'manage_access_rights': 'Quản lý quyền truy cập',
      'about_app': 'Về ứng dụng',
      'app_information': 'Thông tin ứng dụng',
      'app_version': 'Phiên bản',
      'actions': 'Hành động',
      'delete_account': 'Xóa tài khoản',
      'delete_account_permanently': 'Xóa vĩnh viễn tài khoản và dữ liệu',
      
      // Welcome
      'welcome_to_quizmaster': 'Chào mừng đến với QuizMaster',
      'start_now_free': 'Bắt đầu ngay - Miễn phí',
      'create_quiz_easily': 'Tạo Quiz Dễ Dàng',
      'design_your_quiz': 'Thiết kế quiz của riêng bạn chỉ trong vài phút',
    },
    'en': {
      // Common
      'app_name': 'QuizMaster',
      'welcome': 'Welcome',
      'login': 'Sign In',
      'signup': 'Sign Up',
      'logout': 'Logout',
      'settings': 'Settings',
      'profile': 'Profile',
      'home': 'Home',
      'cancel': 'Cancel',
      'save': 'Save',
      'delete': 'Delete',
      'edit': 'Edit',
      'create': 'Create',
      'search': 'Search',
      
      // Settings
      'account': 'Account',
      'edit_profile': 'Edit Profile',
      'update_personal_info': 'Update personal information',
      'notifications': 'Notifications',
      'manage_notifications': 'Manage notifications',
      'interface': 'Interface',
      'dark_mode': 'Dark Mode',
      'toggle_dark_mode': 'Turn on/off dark interface',
      'language': 'Language',
      'security': 'Security',
      'change_password': 'Change Password',
      'update_account_password': 'Update account password',
      'account_security': 'Account Security',
      'manage_access_rights': 'Manage access rights',
      'about_app': 'About App',
      'app_information': 'App Information',
      'app_version': 'Version',
      'actions': 'Actions',
      'delete_account': 'Delete Account',
      'delete_account_permanently': 'Permanently delete account and data',
      
      // Welcome
      'welcome_to_quizmaster': 'Welcome to QuizMaster',
      'start_now_free': 'Get Started - Free',
      'create_quiz_easily': 'Create Quiz Easily',
      'design_your_quiz': 'Design your own quiz in just minutes',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }

  // Getters for common strings
  String get appName => translate('app_name');
  String get welcome => translate('welcome');
  String get login => translate('login');
  String get signup => translate('signup');
  String get logout => translate('logout');
  String get settings => translate('settings');
  String get profile => translate('profile');
  String get home => translate('home');
  String get cancel => translate('cancel');
  String get save => translate('save');
  String get delete => translate('delete');
  String get edit => translate('edit');
  String get create => translate('create');
  String get search => translate('search');
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['vi', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}


