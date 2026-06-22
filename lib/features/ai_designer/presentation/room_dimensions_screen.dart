import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/models/room_dimensions.dart';
import 'ai_designer_providers.dart';

/// Manual room dimensions entry (meters).
class RoomDimensionsScreen extends ConsumerStatefulWidget {
  const RoomDimensionsScreen({super.key});

  @override
  ConsumerState<RoomDimensionsScreen> createState() =>
      _RoomDimensionsScreenState();
}

class _RoomDimensionsScreenState extends ConsumerState<RoomDimensionsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _length = TextEditingController();
  final _width = TextEditingController();
  final _height = TextEditingController(text: '2.8');

  @override
  void initState() {
    super.initState();
    final dims = ref.read(aiRequestProvider).dimensions;
    if (dims != null) {
      _length.text = dims.lengthM.toString();
      _width.text = dims.widthM.toString();
      _height.text = dims.heightM.toString();
    }
  }

  @override
  void dispose() {
    _length.dispose();
    _width.dispose();
    _height.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final dims = RoomDimensions(
      lengthM: double.parse(_length.text),
      widthM: double.parse(_width.text),
      heightM: double.parse(_height.text),
    );
    final req = ref.read(aiRequestProvider);
    ref.read(aiRequestProvider.notifier).state =
        req.copyWith(dimensions: dims);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('أبعاد الغرفة')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text('أدخل أبعاد الغرفة بالأمتار لمساعدة المصمم على توزيع القطع.',
                style: AppTextStyles.bodyMuted),
            const SizedBox(height: 24),
            _field(_length, 'الطول (م)', Icons.straighten),
            const SizedBox(height: 16),
            _field(_width, 'العرض (م)', Icons.straighten),
            const SizedBox(height: 16),
            _field(_height, 'الارتفاع (م)', Icons.height),
            const SizedBox(height: 24),
            _AreaPreview(
              lengthCtl: _length,
              widthCtl: _width,
            ),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: _save, child: const Text('حفظ الأبعاد')),
          ],
        ),
      ),
    );
  }

  Widget _field(TextEditingController c, String label, IconData icon) {
    return TextFormField(
      controller: c,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
      validator: (v) {
        final d = double.tryParse(v ?? '');
        if (d == null || d <= 0) return 'أدخل قيمة صحيحة';
        return null;
      },
      onChanged: (_) => setState(() {}),
    );
  }
}

class _AreaPreview extends StatelessWidget {
  const _AreaPreview({required this.lengthCtl, required this.widthCtl});
  final TextEditingController lengthCtl;
  final TextEditingController widthCtl;

  @override
  Widget build(BuildContext context) {
    final l = double.tryParse(lengthCtl.text);
    final w = double.tryParse(widthCtl.text);
    final area = (l != null && w != null) ? l * w : null;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.scaffold,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.crop_square, color: AppColors.primary),
          const SizedBox(width: 12),
          Text(
            area == null
                ? 'المساحة: —'
                : 'المساحة التقديرية: ${area.toStringAsFixed(1)} م²',
            style: AppTextStyles.subtitle,
          ),
        ],
      ),
    );
  }
}
