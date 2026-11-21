import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/design_tokens.dart';

const List<String> kToolkitCurrencies = ['USD', 'EUR', 'GBP', 'AED', 'SAR'];

const List<String> kPtaSteps = [
  'Register the device with PTA before or during your stay. Rules cover both '
      'the handset and the SIM.',
  'Keep your passport and visa details ready for the registration process.',
  'Use the official PTA portal or visit an authorised mobile operator '
      'franchise. This app does not complete registration for you.',
  'Ask the operator for the current registration period and device conditions. '
      'Fixed time limits are not stated here because they change.',
];

class ForeignerToolkitScreen extends StatefulWidget {
  const ForeignerToolkitScreen({super.key});

  @override
  State<ForeignerToolkitScreen> createState() => _ForeignerToolkitScreenState();
}

class _ForeignerToolkitScreenState extends State<ForeignerToolkitScreen> {
  final _amountController = TextEditingController();
  final _rateController = TextEditingController();
  String _currency = kToolkitCurrencies.first;
  double? _result;

  @override
  void dispose() {
    _amountController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  void _convert() {
    final amount = double.tryParse(_amountController.text.trim());
    final rate = double.tryParse(_rateController.text.trim());
    if (amount == null || rate == null) {
      setState(() => _result = null);
      return;
    }
    setState(() => _result = amount * rate);
  }

  Future<void> _open(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open $url')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppTokens.surfaceDark : Colors.white;
    final borderColor = isDark ? AppTokens.borderDark : AppTokens.border;

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Foreign visitor toolkit',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
            Text(
              'PTA, currency and embassy guidance',
              style: TextStyle(fontSize: 11),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          _sectionTitle(context, 'Temporary mobile registration (PTA)'),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < kPtaSteps.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      '${i + 1}. ${kPtaSteps[i]}',
                      style: const TextStyle(fontSize: 12.5, height: 1.45),
                    ),
                  ),
                const SizedBox(height: 4),
                TextButton.icon(
                  onPressed: () => _open('https://www.pta.gov.pk'),
                  icon: const Icon(Icons.open_in_new_rounded, size: 16),
                  label: const Text('Open the official PTA website'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _sectionTitle(context, 'Currency converter'),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'No live exchange-rate feed is connected. Enter the rate from '
                  'your bank or exchange receipt to convert offline.',
                  style: TextStyle(fontSize: 12, height: 1.4),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _amountController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Amount',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    DropdownButton<String>(
                      value: _currency,
                      items: kToolkitCurrencies
                          .map((c) => DropdownMenuItem(
                                value: c,
                                child: Text(c),
                              ))
                          .toList(),
                      onChanged: (v) =>
                          setState(() => _currency = v ?? _currency),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _rateController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'PKR per 1 $_currency (from your receipt)',
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTokens.pakistanGreen,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _convert,
                      child: const Text('Convert'),
                    ),
                    const SizedBox(width: 12),
                    if (_result != null)
                      Text(
                        '≈ PKR ${_result!.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                  ],
                ),
                if (_result != null)
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      'Using the rate you entered. This is not a live or official '
                      'exchange rate.',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppTokens.textSecondary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _sectionTitle(context, 'Embassies and consulates'),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Embassy contact information is currently unavailable. This app '
                  'has not verified current addresses or emergency numbers, so it '
                  'does not list them. Use the official Ministry of Foreign Affairs '
                  'directory for Islamabad, Lahore and Karachi missions.',
                  style: TextStyle(fontSize: 12.5, height: 1.45),
                ),
                TextButton.icon(
                  onPressed: () => _open('https://mofa.gov.pk'),
                  icon: const Icon(Icons.open_in_new_rounded, size: 16),
                  label: const Text('Open the Ministry of Foreign Affairs site'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}
