import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/localization/app_language.dart';

class CnicVerificationScreen extends ConsumerStatefulWidget {
  const CnicVerificationScreen({super.key});

  @override
  ConsumerState<CnicVerificationScreen> createState() => _CnicVerificationScreenState();
}

class _CnicVerificationScreenState extends ConsumerState<CnicVerificationScreen> {
  final TextEditingController _cnicController = TextEditingController();

  @override
  void dispose() {
    _cnicController.dispose();
    super.dispose();
  }

  void _verifyCnic() {
    final cnic = _cnicController.text.trim();
    if (cnic.isEmpty || cnic.length < 11) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ Invalid CNIC (must be 11‑12 digits).'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    // Simulate verification success
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppStrings.tr('cnic_verify_success', ref.watch(languageProvider))),
        backgroundColor: const Color(0xFF059669),
      ),
    );
    // You can add real verification logic here.
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(languageProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.tr('cnic_verify_button', lang)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.tr('cnic_verify_button', lang),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _cnicController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'مثال: 12345-1234567-1',
                labelText: AppStrings.tr('cnic_verify_button', lang),
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.badge),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _verifyCnic,
                icon: const Icon(Icons.check),
                label: Text(AppStrings.tr('cnic_verify_button', lang)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
