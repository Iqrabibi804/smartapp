import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/offline/offline_cache.dart';
import '../../../core/theme/design_tokens.dart';

const String _passKey = 'digital_tourist_pass_v1';

class DigitalTouristPassScreen extends StatefulWidget {
  const DigitalTouristPassScreen({super.key});

  @override
  State<DigitalTouristPassScreen> createState() =>
      _DigitalTouristPassScreenState();
}

class _DigitalTouristPassScreenState extends State<DigitalTouristPassScreen> {
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  String? _bloodGroup;
  bool _consent = false;
  bool _loaded = false;

  Map<String, dynamic>? _pass;

  static const List<String> _bloodGroups = [
    'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-',
  ];

  @override
  void initState() {
    super.initState();
    _restore();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  Future<void> _restore() async {
    final saved = OfflineCache.instance.read(_passKey);
    if (saved is Map) {
      _pass = Map<String, dynamic>.from(saved);
    }
    if (mounted) setState(() => _loaded = true);
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    final contact = _contactController.text.trim();
    if (name.isEmpty || contact.isEmpty || !_consent) return;
    final rand = math.Random().nextInt(9999).toString().padLeft(4, '0');
    final id =
        'SMP-${DateTime.now().millisecondsSinceEpoch.toRadixString(36).toUpperCase()}-$rand';
    final pass = <String, dynamic>{
      'id': id,
      'name': name,
      'emergencyContact': contact,
      if (_bloodGroup != null) 'bloodGroup': _bloodGroup,
      'issuedAt': DateTime.now().toIso8601String(),
    };
    await OfflineCache.instance.put(
      _passKey,
      pass,
      ttl: const Duration(days: 3650),
    );
    if (!mounted) return;
    setState(() => _pass = pass);
  }

  Future<void> _delete() async {
    await OfflineCache.instance.put(
      _passKey,
      <String, dynamic>{},
      ttl: const Duration(days: 1),
    );
    if (!mounted) return;
    setState(() => _pass = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Digital tourist pass',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
            Text(
              'App-generated — not a government credential',
              style: TextStyle(fontSize: 11),
            ),
          ],
        ),
      ),
      body: !_loaded
          ? const Center(child: CircularProgressIndicator())
          : _pass == null
              ? _buildForm(context)
              : _buildPass(context),
    );
  }

  Widget _buildForm(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppTokens.surfaceDark : Colors.white;
    final borderColor = isDark ? AppTokens.borderDark : AppTokens.border;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTokens.warning.withValues(alpha: isDark ? 0.18 : 0.10),
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppTokens.warning.withValues(alpha: 0.35)),
          ),
          child: const Text(
            'This pass is created by the app for your own convenience. It is not '
            'issued or recognised by any government authority and does not replace '
            'a visa, permit, CNIC or passport.',
            style: TextStyle(fontSize: 12.5, height: 1.45),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Display name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _contactController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Emergency contact phone',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _bloodGroup,
                decoration: const InputDecoration(
                  labelText: 'Blood group (optional)',
                  border: OutlineInputBorder(),
                ),
                items: _bloodGroups
                    .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                    .toList(),
                onChanged: (v) => setState(() => _bloodGroup = v),
              ),
              const SizedBox(height: 8),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                value: _consent,
                onChanged: (v) => setState(() => _consent = v ?? false),
                title: const Text(
                  'I understand this is an app-generated ID, stored only on this '
                  'device, and not an official document.',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTokens.pakistanGreen,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _save,
                  child: const Text('Create pass on this device'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPass(BuildContext context) {
    final pass = _pass!;
    final issuedAt = DateTime.tryParse(pass['issuedAt']?.toString() ?? '');
    final validUntil =
        issuedAt == null ? null : DateTime(issuedAt.year + 1, issuedAt.month, issuedAt.day);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppTokens.pakistanGreen, AppTokens.pakistanGreenDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppRadius.xl),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'APP-GENERATED TOURIST ID',
                style: TextStyle(
                  color: AppTokens.heritageGold,
                  fontSize: 11,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                pass['name']?.toString() ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                pass['id']?.toString() ?? '',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  letterSpacing: 0.6,
                ),
              ),
              const SizedBox(height: 16),
              _passRow('Emergency contact', pass['emergencyContact']?.toString() ?? ''),
              if (pass['bloodGroup'] != null)
                _passRow('Blood group', pass['bloodGroup'].toString()),
              if (validUntil != null)
                _passRow(
                  'Display valid until',
                  '${validUntil.day}/${validUntil.month}/${validUntil.year}',
                ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          'Not a government credential. This ID is stored on this device only, '
          'is not submitted to any authority and is not a permit. A QR code is '
          'not included in this build.',
          style: TextStyle(fontSize: 11.5, height: 1.4),
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: _delete,
          icon: const Icon(Icons.delete_outline_rounded),
          label: const Text('Delete pass from this device'),
        ),
      ],
    );
  }

  Widget _passRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
