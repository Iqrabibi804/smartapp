import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class BudgetCalculatorScreen extends StatefulWidget {
  final String? initialCity;
  const BudgetCalculatorScreen({super.key, this.initialCity});

  @override
  State<BudgetCalculatorScreen> createState() => _BudgetCalculatorScreenState();
}

class _BudgetCalculatorScreenState extends State<BudgetCalculatorScreen> {
  String _selectedCity = 'Murree';
  double _budget = 25000;
  int _days = 3;
  int _travelers = 3;
  String _travelStyle = 'Budget'; // Budget, Family, Comfort

  final List<String> _cities = [
    'Murree',
    'Lahore',
    'Naran & Kaghan',
    'Swat & Kalam',
    'Haripur & Khanpur',
    'Islamabad',
    'Multan & Bahawalpur',
    'Sahiwal',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialCity != null && _cities.contains(widget.initialCity)) {
      _selectedCity = widget.initialCity!;
    }
  }

  // Cost calculation based on Pakistani real-world tourist rates
  Map<String, dynamic> _calculatePlan() {
    // Base costs per day
    final hotelCostPerNight = (_travelStyle == 'Budget' ? 2500 : _travelStyle == 'Family' ? 4500 : 8000);
    final roomsNeeded = (_travelers / 3).ceil();
    final totalHotel = hotelCostPerNight * roomsNeeded * (_days > 1 ? _days - 1 : 1);

    final foodPerPersonDay = (_travelStyle == 'Budget' ? 700 : _travelStyle == 'Family' ? 1200 : 2000);
    final totalFood = foodPerPersonDay * _travelers * _days;

    final transportEstimate = (_travelStyle == 'Budget' ? 1200 : _travelStyle == 'Family' ? 2200 : 4000) * _days;

    final activitiesPerPerson = (_travelStyle == 'Budget' ? 300 : _travelStyle == 'Family' ? 600 : 1200);
    final totalActivities = activitiesPerPerson * _travelers * _days;

    final estimatedTotal = totalHotel + totalFood + transportEstimate + totalActivities;
    final remainingEmergency = (_budget - estimatedTotal).round();
    final perPersonCost = (estimatedTotal / _travelers).round();

    return {
      'totalHotel': totalHotel,
      'totalFood': totalFood,
      'transport': transportEstimate,
      'activities': totalActivities,
      'estimatedTotal': estimatedTotal,
      'remaining': remainingEmergency,
      'perPerson': perPersonCost,
      'isOverBudget': remainingEmergency < 0,
    };
  }

  List<Map<String, String>> _getDayPlan(String city, int days) {
    if (city == 'Murree') {
      return [
        {
          'day': 'Day 1: Arrival & Mall Road Vibes',
          'plan': 'مین مال روڈ پر واک، شام کی کڑک چائے (Rs. 80)، لوکل ہوٹل چیک ان، رات چکن کڑاہی ڈنر',
          'budget_tip': 'مال روڈ کے اندر اندر دکانوں سے ہوٹل لینے کے بجائے 200 میٹر پیچھے ہوٹل لیں، 50% سستا ملے گا۔',
        },
        if (days >= 2)
          {
            'day': 'Day 2: Patriata Chairlift & Bhurban',
            'plan': 'صبح نیو مری اور پتریاٹہ چیئر لفٹ، پکنک لنچ، شام کو بھوربن ویو پوائنٹ',
            'budget_tip': 'چیئر لفٹ کا سرکاری ٹکٹ کاؤنٹر سے لیں، باہر کے ایجنٹ کو اضافی کمیشن نہ دیں۔',
          },
        if (days >= 3)
          {
            'day': 'Day 3: Nathia Gali & Pipeline Track',
            'plan': 'نتھیا گلی پائپ لائن ٹریک کی پرسکون سیر، مشہور مکھنی تکہ اور واپسی',
            'budget_tip': 'لوکل ویگن لاری اڈے سے نتھیا گلی جائے گی، پرائیویٹ ٹیکسی کے 4000 دینے کی ضرورت نہیں۔',
          },
      ];
    } else if (city == 'Lahore') {
      return [
        {
          'day': 'Day 1: Shahi Qila & Old City Food',
          'plan': 'شاہی قلعہ، بادشاہی مسجد، وزیر خان مسجد، رات کو فورٹ روڈ فوڈ اسٹریٹ پر ڈنر',
          'budget_tip': 'شاہی قلعہ کے لیے اورنج لائن ٹرین یا میٹرو بس لیں (Rs. 30 ٹکٹ)، سستی اور ایئر کنڈیشنڈ۔',
        },
        if (days >= 2)
          {
            'day': 'Day 2: Wagah Border & Anarkali Bazar',
            'plan': 'شام کو واہگہ بارڈر پریڈ (مفت داخلہ)، رات انارکلی بازار سے چاٹ اور فالودہ',
            'budget_tip': 'واہگہ بارڈر کے لیے دوپہر 3 بجے نکلیں تاکہ اگلی نشستیں مفت مل سکیں۔',
          },
        if (days >= 3)
          {
            'day': 'Day 3: Shalimar Gardens & Packages Mall',
            'plan': 'شالیمار باغ میں تاریخی سیر، شاپنگ اور تاریخی گوالمنڈی ناشتہ',
            'budget_tip': 'حلوہ پوری ناشتہ گوالمنڈی یا پرانی انارکلی سے کریں (Rs. 150 فی پلیٹ)۔',
          },
      ];
    } else {
      return [
        {
          'day': 'Day 1: City Highlights & Local Bazar',
          'plan': 'شہر کے مرکزی تاریخی مقامات کی سیر، لوکل بازار کی مشہور سوغات اور روایتی کھابے',
          'budget_tip': 'کھانے کے لیے ہائی وے کے بڑے ریسٹورنٹ کے بجائے لوکل مشہور ڈھابہ منتخب کریں۔',
        },
        if (days >= 2)
          {
            'day': 'Day 2: Sightseeing & Nature Walk',
            'plan': 'قریبی جھیل، پہاڑی یا ڈیم ویو، فوٹو گرافی اور شام کی چائے',
            'budget_tip': 'مقامی چنگچی یا ویگن لیں تاکہ فی کس کرایہ کم سے کم رہے۔',
          },
        if (days >= 3)
          {
            'day': 'Day 3: Souvenirs & Safe Return',
            'plan': 'مقامی ہینڈی کرافٹس کی خریداری اور سفر کی واپسی',
            'budget_tip': 'سوغات خریدتے وقت ریٹ کارڈ چیک کریں اور 2 سے 3 دکانوں کا موازنہ کریں۔',
          },
      ];
    }
  }

  void _shareOnWhatsApp(Map<String, dynamic> calc) async {
    final text = '''
🇵🇰 *SmartMap Punjab - بجٹ ٹرپ پلان* 🇵🇰
📍 *منزل:* $_selectedCity
🗓️ *مدت:* $_days دن | 👥 *افراد:* $_travelers لوگ
💰 *کل بجٹ:* Rs. ${_budget.toStringAsFixed(0)}
────────────────────
🏨 *رہائش (ہوٹل):* Rs. ${calc['totalHotel']}
🍲 *کھانا پینا:* Rs. ${calc['totalFood']}
🚐 *ٹرانسپورٹ و فیول:* Rs. ${calc['transport']}
🎟️ *تفریح و ٹکٹیں:* Rs. ${calc['activities']}
────────────────────
💵 *فی کس خرچہ:* Rs. ${calc['perPerson']}
🛡️ *ایمرجنسی فنڈ بچت:* Rs. ${calc['remaining']}
${calc['isOverBudget'] ? '⚠️ بجٹ تھوڑا کم ہے، ہوٹل یا دنوں میں تھوڑی بچت کریں۔' : '✅ بجٹ بالکل پرفیکٹ اور محفوظ ہے!'}

📲 تیار کردہ: SmartMap Punjab (Pakistan's 1st Offline Tourist App)
''';

    final uri = Uri.parse('whatsapp://send?text=${Uri.encodeComponent(text)}');
    final fallbackUri = Uri.parse('https://wa.me/?text=${Uri.encodeComponent(text)}');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else if (await canLaunchUrl(fallbackUri)) {
      await launchUrl(fallbackUri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('WhatsApp install nahi hai!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final calc = _calculatePlan();
    final dayPlans = _getDayPlan(_selectedCity, _days);

    return Scaffold(
      appBar: AppBar(
        title: const Text('بجٹ کیلکولیٹر (Budget Planner)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          IconButton(
            tooltip: 'Share Plan on WhatsApp',
            icon: const Icon(Icons.share, color: Color(0xFF22C55E)),
            onPressed: () => _shareOnWhatsApp(calc),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top Header Banner ──
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.calculate, color: Color(0xFF10B981), size: 28),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'روپے ڈالیں — پورا ٹرپ بنائیں',
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Enter your budget in PKR & get an honest day-by-day plan with hotel & food costs',
                          style: TextStyle(color: Colors.white70, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Inputs Form ──
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Destination City
                  const Text('1. کہاں جانا ہے؟ (Destination City)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: _selectedCity,
                        dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                        items: _cities.map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontWeight: FontWeight.w600)))).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedCity = val);
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 2. Total Budget Slider
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('2. آپ کا کل بجٹ (Total Budget):', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      Text(
                        'Rs. ${_budget.toStringAsFixed(0)}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF059669)),
                      ),
                    ],
                  ),
                  Slider(
                    value: _budget,
                    min: 5000,
                    max: 150000,
                    divisions: 29,
                    activeColor: const Color(0xFF059669),
                    onChanged: (val) => setState(() => _budget = val),
                  ),

                  // 3. Days & Travelers Row
                  Row(
                    children: [
                      // Days
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('دن (Days)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                IconButton.outlined(
                                  icon: const Icon(Icons.remove, size: 16),
                                  onPressed: _days > 1 ? () => setState(() => _days--) : null,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Text('$_days دن', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                ),
                                IconButton.outlined(
                                  icon: const Icon(Icons.add, size: 16),
                                  onPressed: _days < 7 ? () => setState(() => _days++) : null,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Travelers
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('افراد (Travelers)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                IconButton.outlined(
                                  icon: const Icon(Icons.remove, size: 16),
                                  onPressed: _travelers > 1 ? () => setState(() => _travelers--) : null,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Text('$_travelers لوگ', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                ),
                                IconButton.outlined(
                                  icon: const Icon(Icons.add, size: 16),
                                  onPressed: _travelers < 12 ? () => setState(() => _travelers++) : null,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // 4. Travel Style Chips
                  const Text('4. ٹرپ کا انداز (Travel Style):', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildStyleChip('بچت / طالب علم', 'Budget', Icons.savings_outlined),
                      const SizedBox(width: 8),
                      _buildStyleChip('فیملی فرینڈلی', 'Family', Icons.family_restroom),
                      const SizedBox(width: 8),
                      _buildStyleChip('پُرآسائش', 'Comfort', Icons.hotel_class),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Budget Breakdown Card ──
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: calc['isOverBudget'] ? const Color(0xFFFEF2F2) : const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: calc['isOverBudget'] ? const Color(0xFFF87171) : const Color(0xFF22C55E),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            calc['isOverBudget'] ? Icons.warning_amber_rounded : Icons.check_circle_rounded,
                            color: calc['isOverBudget'] ? const Color(0xFFDC2626) : const Color(0xFF16A34A),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            calc['isOverBudget'] ? 'بجٹ تھوڑا کم ہے!' : 'زبردست! بجٹ مکمل محفوظ ہے',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: calc['isOverBudget'] ? const Color(0xFF991B1B) : const Color(0xFF166534),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F172A),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Rs. ${calc['perPerson']} / کس',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  _buildCostRow('🏨 ہوٹل کا خرچہ (${_days > 1 ? _days - 1 : 1} راتیں):', 'Rs. ${calc['totalHotel']}'),
                  _buildCostRow('🍲 کھانا پینا ($_days دن، $_travelers لوگ):', 'Rs. ${calc['totalFood']}'),
                  _buildCostRow('🚐 لوکل ٹرانسپورٹ و فیول شیئر:', 'Rs. ${calc['transport']}'),
                  _buildCostRow('🎟️ سیر و تفریح اور ٹکٹیں:', 'Rs. ${calc['activities']}'),
                  const Divider(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('باقی بچ جانے والا ایمرجنسی فنڈ:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      Text(
                        'Rs. ${calc['remaining']}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: calc['isOverBudget'] ? Colors.red : const Color(0xFF059669),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Day-by-Day Realistic Itinerary ──
            const Text(
              '🗓️ آپ کا روزانہ کا پرفیکٹ پلان (Day-by-Day Plan)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            for (final day in dayPlans) ...[
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFF059669),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            day['day']!,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(day['plan']!, style: const TextStyle(fontSize: 13, height: 1.4)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFBEB),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFFDE68A)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.lightbulb_outline, size: 16, color: Color(0xFFD97706)),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'بچت ٹپ: ${day['budget_tip']!}',
                              style: const TextStyle(fontSize: 11, color: Color(0xFF92400E), fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 12),

            // ── Share on WhatsApp Button ──
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF22C55E),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () => _shareOnWhatsApp(calc),
                icon: const Icon(Icons.chat, size: 20),
                label: const Text(
                  'دوستوں کو واٹس ایپ پر بجٹ پلان بھیجیں',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStyleChip(String label, String value, IconData icon) {
    final selected = _travelStyle == value;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _travelStyle = value),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF059669) : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: selected ? const Color(0xFF059669) : const Color(0xFFCBD5E1)),
          ),
          child: Column(
            children: [
              Icon(icon, size: 18, color: selected ? Colors.white : const Color(0xFF475569)),
              const SizedBox(height: 3),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: selected ? Colors.white : const Color(0xFF1E293B),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCostRow(String title, String amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 12, color: Color(0xFF475569))),
          Text(amount, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
        ],
      ),
    );
  }
}
