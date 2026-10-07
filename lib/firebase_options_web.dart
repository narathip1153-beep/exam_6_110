import 'package:firebase_core/firebase_core.dart';

/// ค่าตั้งต้นสำหรับ Firebase บน Web
/// วิธีได้ค่า: Firebase Console -> Project settings -> Your apps -> เพิ่มแอปแบบ Web (</>)
/// แล้วคัดลอกค่าจาก firebaseConfig มาใส่ด้านล่าง (ใช้ Android อย่างเดียวไม่ต้องแก้ไฟล์นี้)
const webFirebaseOptions = FirebaseOptions(
  apiKey: 'YOUR_WEB_API_KEY',
  appId: 'YOUR_WEB_APP_ID',
  messagingSenderId: 'YOUR_SENDER_ID',
  projectId: 'exam-6-xxx',
  authDomain: 'exam-6-xxx.firebaseapp.com',
  storageBucket: 'exam-6-xxx.appspot.com',
);
