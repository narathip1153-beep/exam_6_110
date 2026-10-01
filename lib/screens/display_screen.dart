import 'package:flutter/material.dart';
import '../controllers/container_controller.dart';
import '../models/container_model.dart';
import '../models/user_model.dart';
import 'form_screen.dart';

class DisplayScreen extends StatelessWidget {
  final UserModel user;
  const DisplayScreen({super.key, required this.user});

  Future<void> _confirmDelete(BuildContext context, ContainerModel c) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('ยืนยันการลบ'),
        content: Text('ต้องการลบตู้ ${c.containerId} (ตรวจรับเข้าคลังสำเร็จ / ตัดถ่ายของเสีย) ใช่หรือไม่?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('ยกเลิก')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('ลบ')),
        ],
      ),
    );
    if (ok == true && user.isAdmin) {
      await ContainerController.delete(c.id!);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ลบข้อมูลแล้ว')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: ContainerController.stream(),
      builder: (context, snap) {
        if (snap.hasError) return Center(child: Text('เกิดข้อผิดพลาด: ${snap.error}'));
        if (!snap.hasData) return const Center(child: CircularProgressIndicator());
        final docs = snap.data!.docs;
        if (docs.isEmpty) return const Center(child: Text('ยังไม่มีตู้ขนส่งระหว่างทาง'));

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, i) {
            final c = ContainerModel.fromDoc(docs[i]);
            return ListTile(
              leading: CircleAvatar(
                radius: 26,
                child: Text('${c.upperTempLimit.toStringAsFixed(c.upperTempLimit % 1 == 0 ? 0 : 1)}°C',
                    style: const TextStyle(fontSize: 12)),
              ),
              title: Text(c.containerId),
              subtitle: Text('${c.productType}\nเหลือ ${c.remainingHours} ชั่วโมง'),
              isThreeLine: true,
              // Operator: ซ่อนปุ่ม Edit/Delete ทั้งหมด
              trailing: user.isAdmin
                  ? Row(mainAxisSize: MainAxisSize.min, children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.orange),
                        onPressed: () => Navigator.push(
                            context, MaterialPageRoute(builder: (_) => EditScreen(item: c))),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _confirmDelete(context, c),
                      ),
                    ])
                  : null,
            );
          },
        );
      },
    );
  }
}
