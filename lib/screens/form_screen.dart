import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import '../controllers/container_controller.dart';
import '../models/container_model.dart';

/// ฟอร์มใช้ร่วมกันทั้ง "เพิ่มข้อมูล" (existing == null) และ "แก้ไข" (existing != null)
class ContainerForm extends StatefulWidget {
  final ContainerModel? existing;
  const ContainerForm({super.key, this.existing});
  @override
  State<ContainerForm> createState() => _ContainerFormState();
}

class _ContainerFormState extends State<ContainerForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _id, _product, _email, _temp, _hours;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _id = TextEditingController(text: e?.containerId ?? '');
    _product = TextEditingController(text: e?.productType ?? '');
    _email = TextEditingController(text: e?.qaEmail ?? '');
    _temp = TextEditingController(text: e?.upperTempLimit.toString() ?? '');
    _hours = TextEditingController(text: e?.remainingHours.toString() ?? '');
  }

  String? _numberValidator(String? v, String label) {
    if (v == null || v.trim().isEmpty) return 'กรุณากรอก$label';
    if (double.tryParse(v.trim()) == null) return '$labelต้องเป็นตัวเลขเท่านั้น';
    return null;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final c = ContainerModel(
      id: widget.existing?.id,
      containerId: _id.text.trim(),
      productType: _product.text.trim(),
      qaEmail: _email.text.trim(),
      upperTempLimit: double.parse(_temp.text.trim()),
      remainingHours: double.parse(_hours.text.trim()),
    );
    try {
      if (widget.existing == null) {
        await ContainerController.add(c);
        _formKey.currentState!.reset();
        for (final t in [_id, _product, _email, _temp, _hours]) {
          t.clear();
        }
      } else {
        await ContainerController.update(c);
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.existing == null ? 'บันทึกข้อมูลสำเร็จ' : 'แก้ไขข้อมูลสำเร็จ')),
      );
      if (widget.existing != null) Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('เกิดข้อผิดพลาด: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(children: [
          TextFormField(
            controller: _id,
            decoration: const InputDecoration(
                labelText: 'รหัสตู้สินค้า (Container Unit ID)', hintText: 'COLD-TH-9941', border: OutlineInputBorder()),
            validator: RequiredValidator(errorText: 'กรุณากรอกรหัสตู้สินค้า'),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _product,
            decoration: const InputDecoration(
                labelText: 'ประเภทสินค้า (Product Type)', hintText: 'mRNA Vaccine, Plasma', border: OutlineInputBorder()),
            validator: RequiredValidator(errorText: 'กรุณากรอกประเภทสินค้า'),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: 'อีเมลเจ้าหน้าที่ QA', border: OutlineInputBorder()),
            validator: MultiValidator([
              RequiredValidator(errorText: 'กรุณากรอกอีเมล'),
              EmailValidator(errorText: 'รูปแบบอีเมลไม่ถูกต้อง'),
            ]),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _temp,
            keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
            decoration: const InputDecoration(
                labelText: 'ขีดจำกัดอุณหภูมิสูงสุด (Upper Temp Limit °C)', border: OutlineInputBorder()),
            validator: (v) => _numberValidator(v, 'อุณหภูมิ'),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _hours,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
                labelText: 'ระยะเวลาขนส่งคงเหลือ (ชั่วโมง)', border: OutlineInputBorder()),
            validator: (v) {
              final err = _numberValidator(v, 'ชั่วโมง');
              if (err != null) return err;
              if (double.parse(v!.trim()) < 0) return 'ชั่วโมงต้องไม่ติดลบ';
              return null;
            },
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save),
              label: Text(widget.existing == null ? 'บันทึก' : 'อัปเดต'),
            ),
          ),
        ]),
      ),
    );
  }
}

/// หน้าแก้ไข (Admin เท่านั้น) — ห่อฟอร์มเดิมด้วย Scaffold
class EditScreen extends StatelessWidget {
  final ContainerModel item;
  const EditScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text('แก้ไข ${item.containerId}')),
        body: ContainerForm(existing: item),
      );
}
