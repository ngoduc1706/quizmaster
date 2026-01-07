# 🔄 Quy Trình Sửa Code và Push Lên GitHub

## Sau khi sửa code, làm theo các bước sau:

### Bước 1: Xem các file đã thay đổi
```bash
git status
```

### Bước 2: Thêm các file đã sửa vào staging
```bash
# Thêm tất cả file đã sửa
git add .

# Hoặc thêm từng file cụ thể
git add tên-file.dart
```

### Bước 3: Commit với message mô tả thay đổi
```bash
git commit -m "Mô tả ngắn gọn những gì đã sửa"
```

**Ví dụ:**
```bash
git commit -m "Fix dark mode colors in settings page"
git commit -m "Add new feature: quiz sharing"
git commit -m "Update README with new screenshots"
```

### Bước 4: Push lên GitHub
```bash
git push origin main
```

## 📝 Ví Dụ Đầy Đủ

```bash
# 1. Xem thay đổi
git status

# 2. Thêm file
git add .

# 3. Commit
git commit -m "Fix UI colors and update README"

# 4. Push
git push origin main
```

## 🔍 Các Lệnh Hữu Ích Khác

### Xem lịch sử commit
```bash
git log --oneline
```

### Xem chi tiết thay đổi trong file
```bash
git diff
```

### Xem thay đổi của file cụ thể
```bash
git diff tên-file.dart
```

### Undo thay đổi chưa commit
```bash
# Bỏ thay đổi trong file (chưa add)
git checkout -- tên-file.dart

# Bỏ tất cả thay đổi chưa commit
git checkout .
```

### Undo commit (chưa push)
```bash
# Giữ lại thay đổi, chỉ bỏ commit
git reset --soft HEAD~1

# Bỏ commit và thay đổi
git reset --hard HEAD~1
```

## ⚠️ Lưu Ý

- Luôn `git add` trước khi `git commit`
- Luôn `git commit` trước khi `git push`
- Message commit nên rõ ràng, mô tả được thay đổi
- Nếu có lỗi khi push, có thể cần `git pull` trước


