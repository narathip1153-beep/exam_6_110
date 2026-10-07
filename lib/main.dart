import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'firebase_options_web.dart';
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ColdTrack',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.cyan, useMaterial3: true),
      home: FutureBuilder(
        // Web ต้องใช้ options (ไม่มี google-services.json) / Android ใช้ google-services.json
        future: kIsWeb
            ? Firebase.initializeApp(options: webFirebaseOptions)
            : Firebase.initializeApp(),
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

/// ตรวจสถานะล็อกอิน: ยังไม่ล็อกอิน -> Login / ล็อกอินแล้ว -> โหลด role แล้วเข้า Home
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
