# School Bus Management Mini App

Flutter mobile app + Node.js backend for school bus tracking.

## Project Structure
- `mobile/` - Flutter client (Android/iOS/macOS)
- `backend/` - Express API + Supabase integration

## Quick Start
Use the full setup guide in `SETUP.md`.

### 1) Configure environment files
- Copy `backend/.env.example` to `backend/.env`
- Copy `mobile/.env.example` to `mobile/.env`

### 2) Start backend
```bash
cd backend
npm install
npm run dev
```

Backend runs on `http://localhost:3000` by default and exposes routes under `/api`.

### 3) Start mobile app
```bash
cd mobile
flutter pub get
flutter run
```

## Environment Variables
Example files are included:
- `backend/.env.example`
- `mobile/.env.example`

## API Base URL Notes
`mobile/.env` should point to the backend API prefix:
- iOS Simulator: `API_BASE_URL=http://127.0.0.1:3000/api`
- Android Emulator: `API_BASE_URL=http://10.0.2.2:3000/api`
- Physical device: `API_BASE_URL=http://<YOUR_COMPUTER_LAN_IP>:3000/api`

## Current Tech Requirements
- Flutter SDK: `>=3.38.0` (Dart `>=3.10.8 <4.0.0`)
- Node.js: `>=20.0.0`

For full prerequisites, iOS/macOS notes, and troubleshooting, see `SETUP.md`.
