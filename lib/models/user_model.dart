class UserModel {
  final String uid;
  final String name;
  final String email;
  final String role; // 'admin' หรือ 'operator'

  UserModel({required this.uid, required this.name, required this.email, required this.role});

  // ไม่สนตัวพิมพ์เล็ก/ใหญ่ และตัดช่องว่าง เช่น "Admin", "admin " ก็ถือเป็น admin
  bool get isAdmin => role.trim().toLowerCase() == 'admin';

  Map<String, dynamic> toMap() => {'uid': uid, 'name': name, 'email': email, 'role': role};

  factory UserModel.fromMap(Map<String, dynamic> m) => UserModel(
        uid: m['uid'] ?? '',
        name: m['name'] ?? '',
        email: m['email'] ?? '',
        role: m['role'] ?? 'operator',
      );
}
