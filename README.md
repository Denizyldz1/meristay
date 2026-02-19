# 🏨 MeriStay — Hotel Reservation App

> 🇹🇷 [Türkçe](#türkçe) | 🇬🇧 [English](#english)

---

## Türkçe

### Hakkında

MeriStay, Flutter ekosisteminde **Clean Architecture**, **Riverpod** ve **test odaklı geliştirme** pratiklerini üretim kalitesinde bir araya getiren portfolyo projesidir. Merit Technology'deki kurumsal Flutter geliştirme deneyiminden ilham alınarak hazırlanmıştır.

### Özellikler

- 🔐 Token tabanlı kimlik doğrulama (Login / Logout)
- 🏨 Otel listeleme ve detay ekranı
- 📅 Rezervasyon — tarih seçimi, misafir sayısı, fiyat hesaplama
- 🌍 Türkçe / İngilizce dil desteği
- 🔄 Token tabanlı route yönetimi (go_router)

### Mimari

Clean Architecture + Feature-first klasör yapısı:

```
lib/
├── core/                 # Network, router, localization
├── features/
│   └── [feature]/
│       ├── data/         # API implementasyonu
│       ├── domain/       # Pure Dart — entity ve abstract repository
│       └── presentation/ # Riverpod provider, ekran, widget
└── shared/               # Ortak bileşenler
```

**Temel Prensip:** `domain` katmanı hiçbir Flutter veya Dio bağımlılığı içermez. İş mantığı framework bağımsız kalır, test yazmak kolaylaşır.

### Teknolojiler

| Kategori | Teknoloji |
|---|---|
| Framework | Flutter 3.x |
| State Management | Riverpod 3.x |
| Navigation | go_router |
| HTTP | Dio + Auth Interceptor |
| Test | flutter_test + mocktail |

### Testler

Her katman için birim testleri yazılmıştır. Mock repository pattern ile gerçek API'den bağımsız test edilebilirlik sağlanmıştır. Gerçek API testleri `skip` ile beklemede, hazır olunca aktive edilecek.

```bash
flutter test             # Tüm testler
flutter test --coverage  # Coverage raporu
```

### Kurulum

```bash
git clone https://github.com/yourusername/meristay.git
cd meristay
flutter pub get
flutter test
flutter run
```

**Test girişi:** `test@meristay.com` / `123456`

---

## English

### About

MeriStay is a portfolio Flutter application demonstrating **Clean Architecture**, **Riverpod state management**, and **unit testing** at production quality. Inspired by real-world enterprise Flutter development experience at Merit Technology.

### Features

- 🔐 Token-based authentication (Login / Logout)
- 🏨 Hotel listing and detail screen
- 📅 Reservation — date picker, guest count, price calculation
- 🌍 Turkish / English language support
- 🔄 Token-based route guarding (go_router)

### Architecture

Clean Architecture with a feature-first folder structure:

```
lib/
├── core/                 # Network, router, localization
├── features/
│   └── [feature]/
│       ├── data/         # API implementation
│       ├── domain/       # Pure Dart — entities & abstract repositories
│       └── presentation/ # Riverpod providers, screens, widgets
└── shared/               # Shared components
```

**Core Rule:** The `domain` layer has zero Flutter or Dio dependencies — pure Dart only. Business logic stays framework-agnostic and testing stays clean.

### Tech Stack

| Category | Technology |
|---|---|
| Framework | Flutter 3.x |
| State Management | Riverpod 3.x |
| Navigation | go_router |
| HTTP | Dio + Auth Interceptor |
| Testing | flutter_test + mocktail |

### Testing

Unit tests written at every layer. Mock repository pattern ensures tests run independently from any real API. Real API integration tests are marked with `skip` and activated when the backend is ready.

```bash
flutter test             # Run all tests
flutter test --coverage  # Generate coverage report
```

### Getting Started

```bash
git clone https://github.com/yourusername/meristay.git
cd meristay
flutter pub get
flutter test
flutter run
```

**Test credentials:** `test@meristay.com` / `123456`

---

## Key Design Decisions

**Riverpod over BLoC** — Less boilerplate without code generation. `NotifierProvider` maps naturally to the ViewModel pattern, making migration from Provider + GetIt straightforward.

**Abstract repositories** — Swapping mock data for a real API requires changes in only one file (`*_repository_impl.dart`). The Notifier, UI, and tests remain untouched.

**Sealed state classes** — Every possible screen state is explicit. The Dart compiler enforces handling all cases in switch expressions — no forgotten error states.

---

*Built by [Deniz](https://github.com/Denizyldz1) — Flutter Developer @ Merit Technology*