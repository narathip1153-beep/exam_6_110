import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class AuthController {
  static final _auth = FirebaseAuth.instance;
  static final _users = FirebaseFirestore.instance.collection('users');

  static Stream<User?> get authChanges => _auth.authStateChanges();

  static Future<void> signIn(String email, String password) =>
      _auth.signInWithEmailAndPassword(email: email.trim(), password: password);

  static Future<void> signOut() => _auth.signOut();

  /// โหลดโปรไฟล์จาก collection users
  /// ถ้ายังไม่มีเอกสาร จะสร้างให้อัตโนมัติ (admin@test.com = admin, นอกนั้น = operator)
  static Future<UserModel> loadProfile(User u) async {
    final doc = await _users.doc(u.uid).get();
    if (doc.exists) return UserModel.fromMap(doc.data()!);

    final email = u.email ?? '';
    final profile = UserModel(
      uid: u.uid,
      name: email.split('@').first,
      email: email,
      role: email == 'admin@test.com' ? 'admin' : 'operator',
    );
    await _users.doc(u.uid).set(profile.toMap());
    return profile;
  }
}
