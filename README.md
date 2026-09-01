# 🕌 Etmaan — اطمئن

**Etmaan** (اطمئن, *"Be at peace"*) is a comprehensive Islamic companion app built with Flutter. It brings together Quran reading, Azkar, Tasbeeh, Prayer Times, Qibla direction, smart local notifications, and daily statistics — all working offline-first on Android.

---

## ✨ Features

| Feature | Description |
|---|---|
| 📖 **Quran** | Full Quran PDF viewer with surah list, search, last-read tracking, and daily goal |
| 🤲 **Azkar** | Morning, Evening, Prayer, Home, Sleep, and Travel Azkar from local JSON |
| 📿 **Tasbeeh** | Digital Tasbeeh counter with 5 presets, targets, and auto-advance |
| 🕌 **Prayer Times** | GPS-based prayer times calculated locally using `adhan_dart` |
| 🧭 **Qibla** | Live compass pointing to the Qibla direction |
| 🔔 **Notifications** | Scheduled Quran verse, Hadith, Azkar, Friday, and Prayer notifications |
| 🔊 **Adhan** | Full Adhan audio playback on prayer notification (local raw resource) |
| 📊 **Statistics** | Daily and lifetime tracking for Tasbeeh, Quran pages, Hizb, and session time |
| 🌙 **Dark / Light Mode** | Full dark and light theme support, persisted across sessions |
| 📲 **Notification Center** | In-app history of today's Quran verse and Hadith notifications |
| ⚙️ **Settings** | Per-category notification toggles, theme switch, and lifetime stats summary |

---

## 📶 Offline-first

The following features work entirely without an internet connection:

- **Quran** — PDF and surah list are bundled as local assets
- **Azkar** — All six categories are local JSON files
- **Hadith & Verse** — Daily notification content is local JSON
- **Prayer calculations** — Computed locally with `adhan_dart` (astronomical formulas, no API)
- **Adhan audio** — Bundled as a local Android raw resource (`adhan.mp3`)
- **Notification scheduling** — Fully local via `flutter_local_notifications` + `timezone`
- **Statistics & persistence** — Stored locally in `SharedPreferences`

> **Note:** Reverse geocoding (translating GPS coordinates to a city/country name) requires an active internet connection. Prayer *calculations* remain fully offline regardless.

---

## 🔔 Notification System

Etmaan uses `flutter_local_notifications` with six dedicated Android channels:

| Channel | Purpose | Sound |
|---|---|---|
| `etmaan_quran` | Daily Quran verse reminders | Default |
| `etmaan_motivational` | Daily Hadith reminders | Silent |
| `etmaan_azkar` | Morning & Evening Azkar | Default |
| `etmaan_prayer` | Prayer time alerts | Default |
| `etmaan_prayer_adhan_v3` | Prayer Adhan (full audio) | `adhan.mp3` (alarm usage) |
| `etmaan_general` | General app notifications | Silent |

**Daily content schedule** (verse/hadith slots): 09:00 · 11:30 · 14:30 · 17:30 · 21:00

**Tap routing:** Verse/Hadith → Notification Center · Azkar → Azkar detail · Prayer → Prayer view

**Notification Center** — An in-app screen (`NotificationView`) shows today's delivered verse and Hadith notifications, sorted newest-first, with a daily reset.

> After installing a new APK, uninstall the old app first — Android caches notification channel settings.

---

## 🕌 Prayer Times

- **GPS location** via `geolocator`
- **Reverse geocoding** (city/country) via `geocoding` (Arabic locale)
- **Prayer time calculation** via `adhan_dart` — fully local, no external API
- **Five prayers scheduled**: Fajr, Dhuhr, Asr, Maghrib, Isha (Sunrise skipped)
- **Adhan audio** plays at prayer time via a dedicated `Importance.max` Android notification channel
- **Qibla direction** calculated from device GPS and displayed with a live `flutter_compass`
- **Timezone-aware scheduling** using `flutter_timezone` + `timezone`

---

## 📖 Quran

- **Full Quran PDF** rendered with `syncfusion_flutter_pdfviewer`
- **Surah list** (114 surahs) loaded from local Dart data — searchable by Arabic name, English name, or surah number
- **Last-read page** persisted in `SharedPreferences` and shown via a progress card
- **Daily reading goal** (10 pages/day) with progress indicator and statistics integration
- **Page tracking** updates Hizb count and Quran pages in daily statistics on each session

---

## 📊 Statistics

Statistics are tracked daily and aggregated as lifetime totals:

**Daily**
- Tasbeeh count
- Quran pages read
- Quran Hizb completed
- Session duration (seconds)

**Lifetime**
- Total Tasbeeh
- Total Quran pages
- Total Quran Hizb
- Active days
- Total session time

All statistics are stored locally and displayed in the Settings screen.

---

## 🏗 Architecture

The project follows a layered feature-first structure:

```
lib/
├── core/
│   ├── cache/           # CacheHelper singleton (SharedPreferences wrapper) + CacheKeys
│   ├── notifications/   # NotificationService, channels, scheduler, router, payload, content
│   ├── routing/         # Named route definitions
│   ├── statistics/      # StatisticsCubit, datasource, models (Daily + Lifetime)
│   └── theme/           # ThemeCubit, app colors, text styles
│
├── features/
│   ├── azkar/           # Azkar categories and detail screens
│   ├── home/            # Home feed (daily verse + hadith cards)
│   ├── notification/    # Notification Center (history UI + cubit)
│   ├── onboarding/      # First-run onboarding flow
│   ├── prayer/          # Prayer times, Qibla, compass, Adhan
│   ├── quran/           # Surah list, PDF viewer, search, daily goal
│   ├── setting/         # Settings, notification toggles, stats summary
│   └── tasbeeh/         # Counter, presets, monthly stats
│
├── etmaan.dart          # Root app widget & provider setup
├── main.dart            # Entry point, initialization
└── root_view.dart       # Bottom navigation shell
```

**Patterns used:**
- **Cubit / flutter_bloc** for all state management
- **Repository + DataSource** separation within each feature
- **Local JSON** for Azkar, Hadith, and Verse content
- **CacheHelper** as a typed `SharedPreferences` wrapper
- **Service classes** for `NotificationService`, `DailyNotificationScheduler`, `NotificationHistoryService`

---

## 🛠 Tech Stack

| Package | Version | Purpose |
|---|---|---|
| `flutter_bloc` | ^9.1.1 | State management (Cubit) |
| `shared_preferences` | ^2.5.5 | Local key-value persistence |
| `adhan_dart` | ^2.0.1 | Local prayer time calculation |
| `geolocator` | ^14.0.2 | GPS location |
| `geocoding` | ^5.0.0 | Reverse geocoding |
| `flutter_compass` | ^0.8.1 | Qibla compass |
| `flutter_local_notifications` | ^22.3.0 | Scheduled local notifications |
| `timezone` | ^0.11.1 | Timezone-aware scheduling |
| `flutter_timezone` | ^5.1.0 | Device timezone detection |
| `just_audio` | ^0.10.6 | Audio playback foundation |
| `syncfusion_flutter_pdfviewer` | ^33.2.13 | Quran PDF rendering |
| `flutter_screenutil` | ^5.9.3 | Responsive sizing |
| `flutter_svg` | ^2.2.3 | SVG asset rendering |
| `flutter_native_splash` | ^2.4.7 | Splash screen |
| `gap` | ^3.0.1 | Spacing utility |
| `smooth_page_indicator` | ^1.2.1 | Onboarding page dots |
| `equatable` | ^2.1.0 | Value equality |
| `dio` | ^5.11.0 | HTTP client |

---

## 🚀 Getting Started

**Requirements:** Flutter SDK ≥ 3.11.0 · Dart ≥ 3.11.0 · Android device/emulator (API 21+)

```bash
# Clone the repository
git clone https://github.com/your-username/etmaan.git
cd etmaan

# Install dependencies
flutter pub get

# Run on a connected device or emulator
flutter run
```

**Build a release APK:**

```bash
flutter build apk --release
```

> After installing a new APK on a device that had a previous version, **uninstall the old app first** to reset Android notification channel caches (especially required for the Adhan channel).

---

## 🧪 Tests

```bash
# Run all unit and widget tests
flutter test

# Static analysis
flutter analyze
```

The test suite covers Cubit logic (Quran, Tasbeeh, Statistics), model serialization, widget smoke tests, and prayer datasource utilities.

---

## 📄 License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.