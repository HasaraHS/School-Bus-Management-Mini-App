# Setup Guide (macOS)

This project has two parts:
- `backend/` (Node.js + Express + Supabase)
- `mobile/` (Flutter app)

## 1. Prerequisites

Install the following on macOS:

### Required tool versions
- Xcode: 15 or newer
- Flutter SDK: `>=3.38.0`
- Dart SDK: `>=3.10.8 <4.0.0` (comes with Flutter)
- Node.js: `>=20.0.0`
- npm: version bundled with Node 20+
- CocoaPods: `>=1.14.0`

### Verify installed versions
```bash
xcodebuild -version
flutter --version
dart --version
node --version
npm --version
pod --version
```

## 2. Clone Repository
```bash
git clone https://github.com/HasaraHS/School-Bus-Management-Mini-App.git
cd school_bus_management_mini_app
```

## 3. Environment Variables

Create env files from examples:

```bash
cp backend/.env.example backend/.env
cp mobile/.env.example mobile/.env
```

Then fill in real values.

### `backend/.env` variables
- `SUPABASE_URL` - Supabase project URL
- `SUPABASE_KEY` - Supabase service key (or secure server-side key)
- `JWT_SECRET` - secret used to sign auth tokens
- `PORT` - backend port (default `3000`)

### `mobile/.env` variables
- `API_BASE_URL` - backend base URL including `/api`
- `MAPBOX_ACCESS_TOKEN` - Mapbox access token used by map screen

API base URL examples:
- iOS Simulator: `API_BASE_URL=http://127.0.0.1:3000/api`
- Android Emulator: `API_BASE_URL=http://10.0.2.2:3000/api`
- Physical device: `API_BASE_URL=http://<YOUR_COMPUTER_LAN_IP>:3000/api`

## 4. Backend Installation and Run
```bash
cd backend
npm install
npm run dev
```

Optional production start:
```bash
npm start
```

Expected log:
`Server is running on port 3000`

## 5. Mobile Installation and Run
```bash
cd mobile
flutter pub get
flutter doctor
```

If CocoaPods dependencies are missing on first iOS build:
```bash
cd ios
pod install
cd ..
```

Run on iOS simulator:
```bash
flutter run -d ios
```

Run on Android emulator/device:
```bash
flutter run -d android
```

Run on macOS desktop:
```bash
flutter run -d macos
```

## 6. Recommended Startup Order
1. Start backend (`npm run dev`)
2. Start mobile app (`flutter run`)
3. Log in and verify API calls succeed

## 7. Common Issues

### `Missing Supabase credentials`
Check `backend/.env` values for `SUPABASE_URL` and `SUPABASE_KEY`.

### `MAPBOX_ACCESS_TOKEN is missing in .env`
Set `MAPBOX_ACCESS_TOKEN` in `mobile/.env`.

### iOS build fails due to pods
Run:
```bash
cd mobile
flutter clean
flutter pub get
cd ios
pod repo update
pod install
```

### Mobile cannot reach backend
Use the correct `API_BASE_URL` for simulator/device network context.

## 8. Useful Commands

Backend:
```bash
cd backend
npm run dev
```

Mobile:
```bash
cd mobile
flutter pub get
flutter run
```
