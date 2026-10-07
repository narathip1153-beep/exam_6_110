# ColdTrack (exam_6_XXX) — ขั้นตอนติดตั้ง

1. ตั้งชื่อโปรเจกต์เป็น exam_6_XXX (XXX = เลข 3 ตัวท้ายรหัส นศ.) และแก้ `name:` ใน pubspec.yaml ให้ตรงกัน
   ในโฟลเดอร์นี้รัน `flutter create .` เพื่อสร้างโฟลเดอร์ android (ไฟล์ lib/ และ pubspec.yaml จะไม่ถูกทับ)
2. Firebase Console: สร้างโปรเจกต์ `exam-6-XXX` -> เพิ่มแอป Android (package = applicationId ใน android/app/build.gradle.kts)
   -> ดาวน์โหลด `google-services.json` ไปวางที่ `android/app/`
   -> Authentication: เปิด Email/Password แล้วเพิ่มผู้ใช้ admin@test.com และ operator@test.com
   -> Firestore Database: Create database ในโหมด **Test Mode**
3. Gradle
   - `android/settings.gradle.kts` ในบล็อก plugins เพิ่ม:
     id("com.google.gms.google-services") version "4.4.2" apply false
   - `android/app/build.gradle.kts` ในบล็อก plugins เพิ่ม: id("com.google.gms.google-services")
   - ตั้ง minSdk = 23 ใน defaultConfig
4. ชื่อแอป: `android/app/src/main/AndroidManifest.xml` แก้ android:label="ColdTrack"
5. `flutter pub get` -> `dart run flutter_launcher_icons` -> `flutter run`
6. สร้าง APK: `flutter build apk` (build/app/outputs/flutter-apk/app-release.apk)

บัญชีทดสอบ: ครั้งแรกที่ล็อกอิน ระบบจะสร้างเอกสารใน collection `users` (uid, name, email, role) ให้อัตโนมัติ
admin@test.com = admin, ที่เหลือ = operator


## รันบนเว็บ (Flutter Web)
1. `flutter create . --platforms=web,android`
2. Firebase Console -> Project settings -> Your apps -> Add app -> Web (</>) -> คัดลอก firebaseConfig
   ไปใส่ใน `lib/firebase_options_web.dart`
3. Authentication -> Settings -> Authorized domains: ต้องมี `localhost` (มีให้อยู่แล้วโดยปกติ)
4. รันทดสอบ: `flutter run -d chrome`
5. สร้างไฟล์เว็บ: `flutter build web` (ผลลัพธ์อยู่ใน build/web)
   ใช้ Firebase Hosting ได้: `firebase init hosting` (public = build/web) แล้ว `firebase deploy`

## การแก้ไขข้อมูล (Admin)
ปุ่มดินสอ (Edit) ในแท็บรายการ -> หน้าแก้ไขทุกช่อง (รวมชั่วโมงเดินทางและเส้นทาง) -> กด "อัปเดต"
Operator จะไม่เห็นปุ่ม Edit/Delete
