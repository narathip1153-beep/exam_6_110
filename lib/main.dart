import 'package:flutter/foundation.dart'; // เพิ่มสำหรับ kIsWeb
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'controllers/auth_controller.dart';
import 'models/user_model.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ColdTrackApp());
}

class ColdTrackApp extends StatelessWidget {
  const ColdTrackApp({super.key});

  // กำหนดฟังก์ชันเริ่มต้น Firebase ให้รองรับทั้ง Web และ Android
  Future<FirebaseApp> _initFirebase() async {
    if (kIsWeb) {
      return await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSy...", // ค่า Web API Key จาก Firebase Console
          appId: "1:xxx:web:xxx",
          messagingSenderId: "xxx",
          projectId: "exam-6-xxx",
        ),
      );
    }
    // สำหรับ Android จะอ่าน google-services.json อัตโนมัติ
    return await Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ColdTrack',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.cyan, useMaterial3: true),
      home: FutureBuilder(
        future: _initFirebase(),
        builder: (context, snap) {
          if (snap.hasError) {
            return Scaffold(body: Center(child: Text('Firebase error: ${snap.error}')));
          }
          if (snap.connectionState != ConnectionState.done) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          return const AuthGate();
        },
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthController.authChanges,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        final user = snap.data;
        if (user == null) return const LoginScreen();
        return FutureBuilder<UserModel>(
          future: AuthController.loadProfile(user),
          builder: (context, p) {
            if (!p.hasData) {
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            }
            return HomeScreen(user: p.data!);
          },
        );
      },
    );
  }
}