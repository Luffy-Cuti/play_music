# play_msuci

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Troubleshooting (app không hiện khi `flutter run`)

Nếu app chạy nhưng không hiện UI (hoặc chỉ màn hình trắng), hãy kiểm tra:

1. **Flutter SDK** đã cài và chạy được:
   ```bash
   flutter --version
   ```
2. **Firebase config** đúng nền tảng đang chạy.
    - Android/iOS dùng `google-services.json` / `GoogleService-Info.plist`.
    - Web cần cấu hình Firebase cho web (`firebase_options.dart` + `Firebase.initializeApp(options: ...)`).
3. Chạy lại:
   ```bash
   flutter clean
   flutter pub get
   flutter run -v
   ```

App hiện tại đã thêm màn hình báo lỗi khởi động để bạn thấy nguyên nhân thay vì không hiển thị gì.
