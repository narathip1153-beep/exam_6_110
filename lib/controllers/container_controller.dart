import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/container_model.dart';

class ContainerController {
  static final _col = FirebaseFirestore.instance.collection('containers');

  // CREATE
  static Future<void> add(ContainerModel c) async {
    await _col.add({...c.toMap(), 'createdAt': FieldValue.serverTimestamp()});
  }

  // READ (Real-time)
  static Stream<QuerySnapshot<Map<String, dynamic>>> stream() =>
      _col.orderBy('createdAt', descending: true).snapshots();

  // UPDATE
  static Future<void> update(ContainerModel c) async {
    await _col.doc(c.id).update(c.toMap());
  }

  // DELETE
  static Future<void> delete(String id) async {
    await _col.doc(id).delete();
  }
}
