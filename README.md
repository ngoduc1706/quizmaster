# 📱 QuizMaster - Ứng Dụng Tạo và Làm Quiz Thông Minh

Ứng dụng mobile Flutter cho phép tạo, chia sẻ và làm quiz với sự hỗ trợ của AI.

![Flutter](https://img.shields.io/badge/Flutter-3.24+-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.10+-0175C2?logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?logo=firebase&logoColor=black)

## ✨ Tính Năng

- 🔐 Đăng ký/Đăng nhập với Email & Password
- 🎯 Tạo quiz với form đa bước (Thông tin → Câu hỏi → Cài đặt → Hoàn thành)
- 🤖 Tạo quiz tự động bằng AI (Google Gemini)
- 📱 Làm quiz với timer và xem kết quả chi tiết
- 🏠 Trang chủ và khám phá quiz
- 👨‍💼 Admin Dashboard (quản lý users, quizzes, categories)
- 🌙 Dark Mode / Light Mode
- 🌍 Đa ngôn ngữ (Tiếng Việt / English)
- ⚙️ Cài đặt đầy đủ (profile, theme, language, security)

## 🚀 Cài Đặt và Chạy

### Yêu Cầu
- Flutter SDK 3.24+
- Firebase project đã được tạo
- Google Gemini API key (cho tính năng AI)

### Bước 1: Clone Repository
```bash
git clone <repository-url>
cd doanlaptrinh
```

### Bước 2: Cài Đặt Dependencies
```bash
flutter pub get
```

### Bước 3: Code Generation
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Bước 4: Cấu Hình Firebase

1. Tải file `google-services.json` từ Firebase Console
2. Đặt vào `android/app/google-services.json`
3. Thêm SHA-1/SHA-256 fingerprints trong Firebase Console
4. Bật Email/Password authentication trong Firebase Console

### Bước 5: Cấu Hình Gemini API

Thêm API key vào file `lib/features/ai/data/datasources/gemini_api_datasource.dart`:
```dart
static const String _apiKey = 'YOUR_GEMINI_API_KEY';
```

### Bước 6: Chạy Ứng Dụng
```bash
flutter run
```

## 📸 Hình Ảnh Ứng Dụng



### Trang Welcome
<img src="screenshots/welcome.png" width="300" alt="Welcome Page">
*Màn hình chào mừng với animation và gradient*

### Trang Đăng Nhập
<img src="screenshots/login.png" width="300" alt="Login Page">
*Form đăng nhập với thiết kế hiện đại*

### Trang Đăng Ký
<img src="screenshots/signup.png" width="300" alt="Signup Page">
*Form đăng ký với validation*

### Trang Chủ
<img src="screenshots/home.png" width="300" alt="Home Page">
*Trang chủ với quiz gần đây, danh mục và tính năng nổi bật*

### Trang Khám Phá
<img src="screenshots/discover.png" width="300" alt="Discover Page">
*Tìm kiếm và lọc quiz với bộ lọc nâng cao*

### Tạo Quiz - Bước 1: Thông Tin Cơ Bản
<img src="screenshots/create_quiz_step1.png" width="300" alt="Create Quiz Step 1">
*Form nhập thông tin cơ bản của quiz*

### Tạo Quiz - Bước 2: Câu Hỏi
<img src="screenshots/create_quiz_step2.png" width="300" alt="Create Quiz Step 2">
*Thêm câu hỏi với giao diện hiện đại*

### Form Thêm Câu Hỏi
<img src="screenshots/add_question.png" width="300" alt="Add Question Dialog">
*Dialog thêm câu hỏi với các tùy chọn*

### Tạo Quiz - Bước 3: Cài Đặt
<img src="screenshots/create_quiz_step3.png" width="300" alt="Create Quiz Step 3">
*Cấu hình cài đặt quiz (công khai, xem lại đáp án, v.v.)*

### Tạo Quiz Bằng AI
<img src="screenshots/ai_generation.png" width="300" alt="AI Generation">
*Tạo quiz tự động bằng AI với tùy chỉnh*

### Làm Quiz
<img src="screenshots/quiz_play.png" width="300" alt="Quiz Play">
*Giao diện làm quiz với timer*

### Kết Quả Quiz
<img src="screenshots/quiz_result.png" width="300" alt="Quiz Result">
*Xem kết quả với emoji động và màu sắc*

### Xem Lại Đáp Án
<img src="screenshots/answer_review.png" width="300" alt="Answer Review">
*Chi tiết từng câu hỏi và đáp án*

### Trang Profile
<img src="screenshots/profile.png" width="300" alt="Profile Page">
*Hồ sơ người dùng với thống kê*

### Trang Cài Đặt
<img src="screenshots/settings.png" width="300" alt="Settings Page">
*Cài đặt với dark mode và ngôn ngữ*

### Admin Dashboard
<img src="screenshots/admin_dashboard.png" width="300" alt="Admin Dashboard">
*Dashboard quản lý với các tab*

### Quản Lý Quiz
<img src="screenshots/quiz_management.png" width="300" alt="Quiz Management">
*Quản lý tất cả quiz trong hệ thống*


## 📝 Lưu Ý

- Tài khoản admin mặc định: `ad@gmail.com` / `12345vh`
- Đảm bảo đã cấu hình Firebase và Gemini API trước khi chạy
- File `google-services.json` phải được thêm vào `android/app/`

## 📄 License

Dự án học tập - Đồ án Lập Trình Mobile

---

**Phiên bản**: 1.0.0  
**Cập nhật**: Tháng 1, 2025
