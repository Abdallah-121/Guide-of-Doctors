# دليل أطباء المخابر السنية (Flutter + Firebase)

تطبيق داخلي بسيط لإدارة دليل الأطباء والعيادات الخاصة بمخبر الأسنان، مع بحث سريع، عرض التفاصيل، تحديد الموقع، وإضافة بيانات جديدة.

## التقنيات والحزم

- `flutter`
- `firebase_core`
- `firebase_auth`
- `cloud_firestore`
- `flutter_bloc` (Cubit)
- `get_it`
- `equatable`
- `connectivity_plus`
- `geolocator`
- `flutter_map`
- `latlong2`
- `url_launcher`
- `go_router`

## البنية المعمارية

- Clean Architecture (Data / Domain / Presentation)
- Feature-first / Vertical slices
- فصل واضح بين:
  - `entities` و `usecases` في `domain`
  - `models` و `datasources` و `repositories impl` في `data`
  - `cubit` و `pages/widgets` في `presentation`

## هيكل المشروع

```text
lib/
  core/
  features/
    auth/
    home/
    doctors/
    clinics/
  app.dart
  main.dart
```

## خطوات الإعداد

1. تثبيت Flutter SDK.
2. تشغيل:
   ```bash
   flutter pub get
   ```
3. إعداد Firebase للمشروع (Android/iOS):
   - إنشاء مشروع Firebase.
   - تفعيل Authentication بنمط Email/Password.
   - إنشاء 4 حسابات يدويًا عبر Firebase Console.
   - تفعيل Cloud Firestore.
   - إضافة ملفات الضبط:
     - Android: `android/app/google-services.json`
     - iOS: `ios/Runner/GoogleService-Info.plist`
4. تأكد من إضافة الإعدادات الخاصة بـ Firebase في ملفات المنصات (Gradle/Xcode).
5. تشغيل التطبيق:
   ```bash
   flutter run
   ```

## المصادقة

- شاشة دخول فقط.
- لا يوجد Signup داخل التطبيق.
- لا يوجد Profile / Settings.

## Firestore Collections

### `doctors`
- `id`
- `fullName`
- `phoneNumber`
- `governorate`
- `address`
- `latitude`
- `longitude`
- `clinicId` (nullable)
- `createdAt`
- `updatedAt`

### `clinics`
- `id`
- `name`
- `governorate`
- `address`
- `latitude`
- `longitude`
- `doctorsCount`
- `createdAt`
- `updatedAt`

## Firestore Security Rules (اقتراح)

انسخ القواعد التالية في Firebase Console > Firestore Rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

## ملاحظات تشغيل

- التطبيق يدعم RTL واللغة العربية.
- الثيم Material 3 بطابع طبي (teal/blue).
- الخرائط عبر OpenStreetMap (`flutter_map`).
