import 'package:cloud_firestore/cloud_firestore.dart';

class ContainerModel {
  final String? id; // document ID
  final String containerId;
  final String productType;
  final String qaEmail;
  final double upperTempLimit;
  final double remainingHours;
  final String route;

  ContainerModel({
    this.id,
    required this.containerId,
    required this.productType,
    required this.qaEmail,
    required this.upperTempLimit,
    required this.remainingHours,
    this.route = '',
  });

  Map<String, dynamic> toMap() => {
        'containerId': containerId,
        'productType': productType,
        'qaEmail': qaEmail,
        'upperTempLimit': upperTempLimit,
        'remainingHours': remainingHours,
        'route': route,
      };

  factory ContainerModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data()!;
    return ContainerModel(
      id: doc.id,
      containerId: d['containerId'] ?? '',
      productType: d['productType'] ?? '',
      qaEmail: d['qaEmail'] ?? '',
      upperTempLimit: (d['upperTempLimit'] ?? 0).toDouble(),
      remainingHours: (d['remainingHours'] ?? 0).toDouble(),
      route: d['route'] ?? '',
    );
  }
}
