# Backend ↔ Frontend Connection Guide

This project reads backend URL from a Dart define named `BASE_URL_API_V1`.

## 1) Start backend first
Make sure your backend server is running and reachable, for example:

- `http://127.0.0.1:8000/api/v1` (local machine)
- `http://192.168.1.50:8000/api/v1` (LAN, phone testing)

## 2) Pick correct host by platform

- **Android Emulator**: use `10.0.2.2` instead of `localhost`
  - Example: `http://10.0.2.2:8000/api/v1`
- **iOS Simulator**: usually `127.0.0.1` works
  - Example: `http://127.0.0.1:8000/api/v1`
- **Physical Android/iOS device**: use your computer LAN IP
  - Example: `http://192.168.1.50:8000/api/v1`

## 3) Run app with backend URL

```bash
flutter clean
flutter pub get
flutter run --dart-define=BASE_URL_API_V1=http://10.0.2.2:8000/api/v1
```

For a physical device:

```bash
flutter run --dart-define=BASE_URL_API_V1=http://192.168.1.50:8000/api/v1
```

## 4) If app still cannot connect

- Confirm backend CORS / host binding allows your client origin or device IP.
- Ensure backend binds to `0.0.0.0`, not only `127.0.0.1`, for phone testing.
- Open firewall for backend port (e.g., 8000).
- Verify endpoint health in browser/Postman first.

## 5) Common gotcha in this repo

If Flutter fails before running (YAML parse error), regenerate lockfile:

```bash
# from frontend/
rm -f pubspec.lock
flutter pub get
```

If using Windows PowerShell/CMD, just delete `pubspec.lock` manually and rerun `flutter pub get`.
If your `pubspec.yaml` ever gets corrupted on Windows, run:

```bash
bash scripts/repair_pubspec.sh
flutter pub get
```
