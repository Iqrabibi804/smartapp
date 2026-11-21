import 'package:flutter/material.dart';

import '../../../core/theme/design_tokens.dart';

class CultureTip {
  const CultureTip(this.title, this.body);
  final String title;
  final String body;
}

const List<CultureTip> kCultureTips = [
  CultureTip(
    'Greetings',
    'A relaxed "Assalam-o-Alaikum" (peace be upon you) is a respectful '
        'greeting in most settings. "Shukriya" means thank you.',
  ),
  CultureTip(
    'Places of worship',
    'Remove shoes before entering mosques and many shrines. Dress modestly, '
        'and avoid walking in front of someone who is praying.',
  ),
  CultureTip(
    'Photography',
    'Ask before photographing people, especially women and children. Some '
        'sites restrict photography — follow posted signs and staff guidance.',
  ),
  CultureTip(
    'Hospitality',
    'Offers of tea or food are common hospitality. Accepting, even briefly, '
        'is appreciated; declining politely is also fine.',
  ),
  CultureTip(
    'Ramadan',
    'During Ramadan many people fast from dawn to sunset. Avoid eating, '
        'drinking or smoking in public during daylight hours.',
  ),
  CultureTip(
    'Bargaining',
    'Bargaining is normal in traditional markets but not in fixed-price shops '
        'or supermarkets. Agree a price before a service starts.',
  ),
  CultureTip(
    'Dress and behaviour',
    'Modest clothing (shoulders and knees covered) is comfortable and '
        'respectful in most public places, particularly outside major cities.',
  ),
  CultureTip(
    'Prayer times',
    'Shops may close briefly around Friday prayers and at other prayer times. '
        'Plan shopping and fuel stops around them.',
  ),
];

const List<MapEntry<String, String>> kUsefulPhrases = [
  MapEntry('Assalam-o-Alaikum', 'Peace be upon you (greeting)'),
  MapEntry('Shukriya', 'Thank you'),
  MapEntry('Kitne ka hai?', 'How much is this?'),
  MapEntry('Yeh kahan hai?', 'Where is this?'),
  MapEntry('Mujhe madad chahiye', 'I need help'),
  MapEntry('Pani', 'Water'),
  MapEntry('Hospital kahan hai?', 'Where is the hospital?'),
];

class CultureCompanionScreen extends StatelessWidget {
  const CultureCompanionScreen({super.key});

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
              'Local culture companion',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
            Text(
              'General guidance — customs vary',
              style: TextStyle(fontSize: 11),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTokens.pakistanGreen.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(
                color: AppTokens.pakistanGreen.withValues(alpha: 0.2),
              ),
            ),
            child: const Text(
              'Compiled from widely published traveller guidance. Customs vary '
              'between communities and families — when unsure, ask politely or '
              'follow the people around you.',
              style: TextStyle(fontSize: 12, height: 1.45),
            ),
          ),
          const SizedBox(height: 16),
          for (final tip in kCultureTips) ...[
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
                  Text(
                    tip.title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tip.body,
                    style: const TextStyle(fontSize: 12.5, height: 1.45),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
          const SizedBox(height: 8),
          Text(
            'Useful phrases',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              children: [
                for (final phrase in kUsefulPhrases)
                  ListTile(
                    dense: true,
                    title: Text(
                      phrase.key,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      phrase.value,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
