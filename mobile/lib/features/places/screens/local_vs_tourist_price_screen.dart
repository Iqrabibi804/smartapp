import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';

class PriceComparisonItem {
  final String itemName;
  final String category;
  final int localPrice;
  final int touristPrice;
  final String unit;
  final String tipUrdu;

  PriceComparisonItem({
    required this.itemName,
    required this.category,
    required this.localPrice,
    required this.touristPrice,
    required this.unit,
    required this.tipUrdu,
  });
}

class LocalVsTouristPriceScreen extends StatefulWidget {
  const LocalVsTouristPriceScreen({super.key});

  @override
  State<LocalVsTouristPriceScreen> createState() => _LocalVsTouristPriceScreenState();
}

class _LocalVsTouristPriceScreenState extends State<LocalVsTouristPriceScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCity = 'Murree (مری مال روڈ)';

  // Meter emulator states
  String _selectedVehicle = 'Auto Rickshaw (آٹو رکشہ)';
  double _distanceKm = 8.0;

  final Map<String, List<PriceComparisonItem>> _cityRates = {
    'Murree (مری مال روڈ)': [
      PriceComparisonItem(
        itemName: 'کڑک دودھ پتی چائے',
        category: 'Food',
        localPrice: 80,
        touristPrice: 220,
        unit: 'فی کپ',
        tipUrdu: 'مال روڈ کے سامنے والے کیفے کے بجائے اندر گلی کے روایتی ڈھابے پر جائیں۔',
      ),
      PriceComparisonItem(
        itemName: 'ہوٹل کا مناسب کمرا (Standard Room)',
        category: 'Hotel',
        localPrice: 2800,
        touristPrice: 7500,
        unit: 'فی رات',
        tipUrdu: 'مال روڈ پر کھڑے ایجنٹ سے ہرگز نہ لیں، وہ 35% کمیشن لیتے ہیں۔ خود 200 میٹر پیچھے چیک کریں۔',
      ),
      PriceComparisonItem(
        itemName: 'چکن کڑاہی (دیسی ذائقہ)',
        category: 'Food',
        localPrice: 1600,
        touristPrice: 3200,
        unit: '1 کلو',
        tipUrdu: 'آرڈر سے پہلے وزن اور مکمل بل کا ریٹ پکا کر لیں۔',
      ),
      PriceComparisonItem(
        itemName: 'پتریاٹہ لوکل ٹیکسی سواری',
        category: 'Transport',
        localPrice: 1200,
        touristPrice: 3500,
        unit: 'ایک طرف',
        tipUrdu: 'لاری اڈہ سے لوکل کیری ڈبہ یا ہائی ایس لیں، صرف 150 روپے فی سواری لگے گی۔',
      ),
      PriceComparisonItem(
        itemName: 'پانی کی بڑی بوتل (1.5L)',
        category: 'Food',
        localPrice: 90,
        touristPrice: 180,
        unit: 'فی بوتل',
        tipUrdu: 'سرکاری پرنٹ شدہ MRP چیک کریں، اضافی قیمت مانگنے پر منع کر دیں۔',
      ),
      PriceComparisonItem(
        itemName: 'گھڑ سواری (Horse Ride)',
        category: 'Activity',
        localPrice: 400,
        touristPrice: 1500,
        unit: '1 چکر',
        tipUrdu: 'پہلے سے چکر اور وقت طے کریں۔ ریٹ 400 سے زیادہ نہ دیں۔',
      ),
    ],
    'Haripur & Khanpur Dam (خانپور ڈیم)': [
      PriceComparisonItem(
        itemName: 'ڈیم پر اسپیڈ بوٹ سواری',
        category: 'Activity',
        localPrice: 400,
        touristPrice: 1200,
        unit: 'فی سواری',
        tipUrdu: 'سرکاری واٹر اسپورٹس کاؤنٹر سے لائف جیکٹ سمیت سرکاری پرچی لیں۔',
      ),
      PriceComparisonItem(
        itemName: 'ہری پور کے مشہور چپل کباب',
        category: 'Food',
        localPrice: 180,
        touristPrice: 350,
        unit: 'فی عدد',
        tipUrdu: 'مین جی ٹی روڈ کے مستند دیسی کباب ہاؤسز سے لیں۔',
      ),
      PriceComparisonItem(
        itemName: 'پلاسٹک چیئر / چارپائی کرایہ پانی کے پاس',
        category: 'Activity',
        localPrice: 150,
        touristPrice: 500,
        unit: 'فی گھنٹہ',
        tipUrdu: 'بیٹھنے سے پہلے کرایہ طے کریں، زیادہ تر ریستوران کھانے کے ساتھ مفت دیتے ہیں۔',
      ),
      PriceComparisonItem(
        itemName: 'ڈیم سے ہری پور شہر رکشہ',
        category: 'Transport',
        localPrice: 300,
        touristPrice: 800,
        unit: 'مکمل رکشہ',
        tipUrdu: 'لوکل چنگچی رکشہ لیں، صرف 50 روپے فی سواری لگتے ہیں۔',
      ),
    ],
    'Lahore (شاہی قلعہ و انارکلی)': [
      PriceComparisonItem(
        itemName: 'بادشاہی مسجد تا قلعہ گائیڈ',
        category: 'Activity',
        localPrice: 500,
        touristPrice: 2000,
        unit: 'مکمل ٹور',
        tipUrdu: 'صرف TDCP کے بیج والے سرکاری گائیڈز کی خدمات لیں۔',
      ),
      PriceComparisonItem(
        itemName: 'مستند حلوہ پوری ناشتہ',
        category: 'Food',
        localPrice: 140,
        touristPrice: 300,
        unit: '2 پوری + چنے',
        tipUrdu: 'پرانی انارکلی یا گوالمنڈی سے عام دکان سے لیں۔',
      ),
      PriceComparisonItem(
        itemName: 'قلعہ روڈ فوڈ اسٹریٹ ٹیبل چارجز',
        category: 'Food',
        localPrice: 0,
        touristPrice: 1000,
        unit: 'فی ٹیبل',
        tipUrdu: 'روف ٹاپ کے نام پر بیٹھنے کا الگ خرچہ دینے سے انکار کریں، کھانا منگوانے پر یہ مفت ہوتا ہے۔',
      ),
      PriceComparisonItem(
        itemName: 'روایتی کھسہ و شال',
        category: 'Shopping',
        localPrice: 1200,
        touristPrice: 3500,
        unit: 'فی جوڑا',
        tipUrdu: 'پہلی بتائی گئی قیمت کے 50% سے بارگیننگ شروع کریں۔',
      ),
    ],
    'Naran & Kaghan (سیف الملوک روٹ)': [
      PriceComparisonItem(
        itemName: 'جھیل سیف الملوک 4x4 جیپ',
        category: 'Transport',
        localPrice: 4000,
        touristPrice: 9000,
        unit: 'ریٹرن جیپ',
        tipUrdu: 'جیپ یونین کے سرکاری اڈے سے فکس پرچی کٹوائیں، ہوٹل والوں کی بیچولیا جیپ نہ لیں۔',
      ),
      PriceComparisonItem(
        itemName: 'دریائے کنہار کی تازہ ٹراؤٹ مچھلی',
        category: 'Food',
        localPrice: 1800,
        touristPrice: 4200,
        unit: '1 کلو تلائی شدہ',
        tipUrdu: 'مچھلی کا وزن اپنے سامنے لائیو کنڈے پر کروائیں، کچھ ہوٹل برف کا وزن شامل کرتے ہیں۔',
      ),
      PriceComparisonItem(
        itemName: 'دیسی چکن سوپ (کنہار کنارے)',
        category: 'Food',
        localPrice: 120,
        touristPrice: 350,
        unit: 'فی پیالی',
        tipUrdu: 'دریا کنارے بنے عارضی ٹینٹ دگنا ریٹ مانگتے ہیں، پہلے ریٹ پوچھیں۔',
      ),
      PriceComparisonItem(
        itemName: 'لکڑی کی چھڑی (ٹریکنگ اسٹک)',
        category: 'Shopping',
        localPrice: 150,
        touristPrice: 500,
        unit: 'فی اسٹک',
        tipUrdu: 'بازار کے شروع سے لیں۔ ٹریک پوائنٹ پر قیمت تین گنا ہو جاتی ہے۔',
      ),
    ],
    'Hunza & Gilgit (ہنزہ و قراقرم)': [
      PriceComparisonItem(
        itemName: 'عطا آباد جھیل بوٹ سواری',
        category: 'Activity',
        localPrice: 500,
        touristPrice: 1800,
        unit: 'فی سواری',
        tipUrdu: 'سرکاری بوٹ ایسوسی ایشن کاؤنٹر سے لائف جیکٹ والی ٹکٹ لیں۔',
      ),
      PriceComparisonItem(
        itemName: 'ہنزہ مشہور خوبانی کیک (Apricot Cake)',
        category: 'Food',
        localPrice: 220,
        touristPrice: 550,
        unit: 'فی سلائس',
        tipUrdu: 'کریم آباد کے تاریخی کیفے سے تازہ تیار شدہ لیں۔',
      ),
      PriceComparisonItem(
        itemName: 'ہنزہ دیسی یاک برگر (Yak Burger)',
        category: 'Food',
        localPrice: 650,
        touristPrice: 1400,
        unit: 'مکمل برگر',
        tipUrdu: 'روایتی لوکل ذائقہ اور خالص پروٹین۔',
      ),
    ],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _callHelpline(String number) async {
    final uri = Uri.parse('tel:$number');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  // Calculate fare based on vehicle and distance
  Map<String, int> _calculateFare() {
    int baseFare = 80;
    int perKm = 35;
    if (_selectedVehicle.contains('Qingqi')) {
      baseFare = 40;
      perKm = 20;
    } else if (_selectedVehicle.contains('Mini Cab')) {
      baseFare = 150;
      perKm = 55;
    } else if (_selectedVehicle.contains('4x4')) {
      baseFare = 1500;
      perKm = 170; // Mountain terrain fuel & clutch factor
    }

    final minFare = (baseFare + (_distanceKm * perKm * 0.9)).round();
    final maxFare = (baseFare + (_distanceKm * perKm * 1.15)).round();
    return {'min': minFare, 'max': maxFare};
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark ? Colors.white : AppColors.textPrimary;
    final cardBgColor = isDark ? const Color(0xFF1E293B) : Colors.white;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : AppColors.background,
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Anti-Gouging Fair Rates ⚖️', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
            Text('سیاحتی لوٹ مار سے بچاؤ اور ٹیکسی میٹر ایمولیٹر', style: TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Report Overcharging (1421)',
            icon: const Icon(Icons.support_agent, color: Color(0xFFDC2626)),
            onPressed: () => _callHelpline('1421'),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFFDC2626),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFFDC2626),
          tabs: const [
            Tab(icon: Icon(Icons.price_check_rounded), text: 'اصلی بمقابلہ سیاحتی ریٹ'),
            Tab(icon: Icon(Icons.local_taxi_rounded), text: 'ٹیکسی و جیپ میٹر'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // ── TAB 1: Real vs Tourist Prices ─────────────────────────────────
          _buildPriceIndexTab(context, isDark, primaryTextColor, cardBgColor),

          // ── TAB 2: Taxi / Rickshaw / 4x4 Jeep Meter Emulator ──────────────
          _buildMeterEmulatorTab(context, isDark, primaryTextColor, cardBgColor),
        ],
      ),
    );
  }

  Widget _buildPriceIndexTab(BuildContext context, bool isDark, Color primaryTextColor, Color cardBgColor) {
    final items = _cityRates[_selectedCity] ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Header Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF7F1D1D), Color(0xFF991B1B)],
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
                    color: Colors.white.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.price_check, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'سیاحتی لوٹ مار سے بچاؤ (Anti-Scam Guide)',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'See honest local rates vs tourist overcharging so you never pay extra in Pakistan',
                        style: TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // City Selector Chips
          const Text('مقام منتخب کریں (Select Tourist Spot):', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _cityRates.keys.map((c) {
                final isSelected = _selectedCity == c;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(c.split('(').first.trim()),
                    selected: isSelected,
                    selectedColor: const Color(0xFFDC2626),
                    backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                    side: BorderSide(color: isSelected ? const Color(0xFFDC2626) : Colors.black12),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : (isDark ? Colors.white70 : const Color(0xFF1E293B)),
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                      fontSize: 12,
                    ),
                    onSelected: (val) {
                      if (val) setState(() => _selectedCity = c);
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 16),

          for (final item in items) ...[
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: cardBgColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(item.itemName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDC2626).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(item.category, style: const TextStyle(color: Color(0xFFDC2626), fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      // Honest Local Price
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0FDF4),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFF86EFAC)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.check_circle, color: Color(0xFF16A34A), size: 14),
                                  SizedBox(width: 4),
                                  Text('اصلی / لوکل ریٹ', style: TextStyle(color: Color(0xFF15803D), fontSize: 10, fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Rs. ${item.localPrice}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF15803D)),
                              ),
                              Text(item.unit, style: const TextStyle(fontSize: 10, color: Color(0xFF15803D))),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Tourist Overcharging Price
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF2F2),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFFCA5A5)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.warning, color: Color(0xFFDC2626), size: 14),
                                  SizedBox(width: 4),
                                  Text('سیاحتی اوورچارجنگ', style: TextStyle(color: Color(0xFF991B1B), fontSize: 10, fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Rs. ${item.touristPrice}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color(0xFFDC2626),
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              Text(item.unit, style: const TextStyle(fontSize: 10, color: Color(0xFFB91C1C))),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Urdu Local Advice
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFBEB),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.lightbulb_outline, size: 14, color: Color(0xFFD97706)),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            '💡 مشورہ: ${item.tipUrdu}',
                            style: const TextStyle(fontSize: 11, color: Color(0xFF92400E), height: 1.3),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 10),

          // Helpline Report Card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
            ),
            child: Column(
              children: [
                const Text(
                  '⚠️ اگر کوئی دکاندار یا ہوٹل ناجائز ریٹ طلب کرے:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                const Text(
                  'پنجاب حکومت کے پرائس کنٹرول مجسٹریٹ یا ٹورازم ہیلپ لائن پر فری کال کریں',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF059669),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () => _callHelpline('1421'),
                        icon: const Icon(Icons.call, size: 16),
                        label: const Text('ٹورازم ہیلپ 1421', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF7C3AED),
                          side: const BorderSide(color: Color(0xFF7C3AED)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () => _callHelpline('1787'),
                        icon: const Icon(Icons.phone_in_talk, size: 16),
                        label: const Text('سٹیزن پورٹل 1787', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildMeterEmulatorTab(BuildContext context, bool isDark, Color primaryTextColor, Color cardBgColor) {
    final fare = _calculateFare();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Intro Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF006644).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF006644).withValues(alpha: 0.3)),
          ),
          child: const Row(
            children: [
              Icon(Icons.speed_rounded, color: Color(0xFF006644), size: 28),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ٹیکسی و جیپ فیئر میٹر ایمولیٹر (Fair Meter)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF006644))),
                    SizedBox(height: 2),
                    Text(
                      'گاڑی منتخب کریں اور فاصلہ ڈالیں۔ ایپ آپ کو سرکاری و مناسب ریٹ نکال کر دے گی جو آپ ڈرائیور کو دکھا سکتے ہیں۔',
                      style: TextStyle(fontSize: 11.5, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Vehicle Picker
        const Text('سواری کی قسم منتخب کریں (Select Vehicle):', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: _selectedVehicle,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
          items: [
            'Auto Rickshaw (آٹو رکشہ)',
            'Qingqi (چنگچی 6 سیٹر)',
            'Mini Cab (سوزوکی آلٹو / کیب)',
            '4x4 Mountain Jeep (پہاڑی جیپ ناران/ہنزہ/سکردو)',
          ].map((v) => DropdownMenuItem(value: v, child: Text(v, style: const TextStyle(fontSize: 13)))).toList(),
          onChanged: (val) {
            if (val != null) setState(() => _selectedVehicle = val);
          },
        ),

        const SizedBox(height: 16),

        // Popular Quick Routes
        const Text('مقبول روٹس یا کسٹم فاصلہ (Quick Routes):', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildRouteChip('Naran to Saif-ul-Muluk (10 KM)', 10.0, '4x4 Mountain Jeep (پہاڑی جیپ ناران/ہنزہ/سکردو)'),
              _buildRouteChip('Murree Mall Road to Bhurban (14 KM)', 14.0, 'Mini Cab (سوزوکی آلٹو / کیب)'),
              _buildRouteChip('Pindi Station to Islamabad Blue Area (18 KM)', 18.0, 'Auto Rickshaw (آٹو رکشہ)'),
              _buildRouteChip('Lahore Station to Shahi Qila (5 KM)', 5.0, 'Auto Rickshaw (آٹو رکشہ)'),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Distance Slider
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('فاصلہ (Distance):', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            Text('${_distanceKm.toStringAsFixed(1)} KM', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF006644))),
          ],
        ),
        Slider(
          value: _distanceKm,
          min: 1.0,
          max: 60.0,
          divisions: 59,
          activeColor: const Color(0xFF006644),
          onChanged: (val) => setState(() => _distanceKm = val),
        ),

        const SizedBox(height: 14),

        // 🌟 DRIVER BARGAINING CARD (ڈرائیور کو دکھانے والا کارڈ)
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF006644), Color(0xFF004D33)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF006644).withValues(alpha: 0.35),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.handshake_rounded, color: Colors.amber, size: 20),
                      SizedBox(width: 6),
                      Text('ڈرائیور کو دکھانے والا اسکرین کارڈ', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Chip(
                    label: Text('سرکاری و لوکل ریٹ', style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                    backgroundColor: Color(0xFFE65F2B),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                'Rs. ${fare['min']} - ${fare['max']}',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              const Text('منصفانہ کرایہ کی رینج (Fair Price Range)', style: TextStyle(color: Colors.white70, fontSize: 12)),
              const Divider(color: Colors.white24, height: 24),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'محترم ڈرائیور صاحب!\nایپ کے GPS اور ٹریفک قوانین کے مطابق ${_distanceKm.toStringAsFixed(0)} کلومیٹر کا منصفانہ ریٹ Rs. ${fare['min']} سے ${fare['max']} بنتا ہے۔ مہربانی فرما کر جائز کرایہ لیں۔',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.5, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildRouteChip(String title, double km, String vehicle) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        label: Text(title, style: const TextStyle(fontSize: 11)),
        backgroundColor: const Color(0xFF006644).withValues(alpha: 0.08),
        onPressed: () {
          setState(() {
            _distanceKm = km;
            _selectedVehicle = vehicle;
          });
        },
      ),
    );
  }
}
