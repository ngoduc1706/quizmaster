# 🚀 Hướng Dẫn Push Code Lên GitHub

## Bước 1: Cấu hình Git (chỉ cần làm 1 lần)

Mở terminal và chạy:

```bash
git config user.name "Tên của bạn"
git config user.email "email-cua-ban@gmail.com"
```

## Bước 2: Commit Code

```bash
git commit -m "Initial commit: QuizMaster app with AI generation, admin dashboard, dark mode, and multi-language support"
```

## Bước 3: Tạo Repository Trên GitHub

1. Vào https://github.com/new
2. Điền thông tin:
   - **Repository name**: `quizmaster` (hoặc tên bạn muốn)
   - **Description**: "Flutter Quiz App with AI Generation"
   - **Public** hoặc **Private** (tùy bạn)
   - ⚠️ **QUAN TRỌNG**: KHÔNG tick "Add a README file" (vì đã có sẵn)
3. Click **"Create repository"**
4. Copy URL repository (ví dụ: `https://github.com/username/quizmaster.git`)

## Bước 4: Kết Nối và Push

Chạy các lệnh sau (thay `YOUR_USERNAME` và `YOUR_REPO_NAME` bằng thông tin của bạn):

```bash
# Kết nối với GitHub
git remote add origin https://github.com/ngoduc1706/quizmaster.git

# Đổi tên branch thành main
git branch -M main

# Push code lên GitHub
git push -u origin main
```

## ✅ Hoàn Thành!

Sau khi push xong, code sẽ có trên GitHub tại:
`https://github.com/YOUR_USERNAME/YOUR_REPO_NAME`

## 🔐 Lưu Ý Bảo Mật

- File `google-services.json` đã được commit (nếu muốn bảo mật hơn, có thể thêm vào `.gitignore`)
- Mỗi người clone về cần tự tạo Firebase project riêng
- Gemini API key cần tự thêm vào


