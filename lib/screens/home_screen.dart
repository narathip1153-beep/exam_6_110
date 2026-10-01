import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import '../models/user_model.dart';
import 'display_screen.dart';
import 'form_screen.dart';

class HomeScreen extends StatelessWidget {
  final UserModel user;
  const HomeScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('ColdTrack (${user.role.toUpperCase()})'),
          actions: [
            IconButton(
              tooltip: 'Sign Out',
              icon: const Icon(Icons.logout),
              onPressed: AuthController.signOut,
            ),
          ],
          bottom: const TabBar(tabs: [
            Tab(icon: Icon(Icons.add_box), text: 'ลงทะเบียนตู้'),
            Tab(icon: Icon(Icons.list_alt), text: 'รายการตู้ขนส่ง'),
          ]),
        ),
        body: TabBarView(children: [
          const ContainerForm(),
          DisplayScreen(user: user),
        ]),
      ),
    );
  }
}
