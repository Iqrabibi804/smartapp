import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/localization/app_language.dart';
class RoadAlert {
  final String id;
  final String title;
  final String urduTitle;
  final String location;
  final String route;
  final String severity; // High, Medium, Info
  final String alertType; // Landslide, Snow, 4x4 Jeep Only, Fuel Dry, ATM Out of Cash, No Cellular
  final String description;
  final String timeAgo;
  int verifiedCount;
  bool isCleared;

  RoadAlert({
    required this.id,
    required this.title,
    required this.urduTitle,
    required this.location,
    required this.route,
    required this.severity,
    required this.alertType,
    required this.description,
    required this.timeAgo,
    required this.verifiedCount,
    this.isCleared = false,
  });
}

class RoadInfrastructureAlertsScreen extends ConsumerStatefulWidget {
  const RoadInfrastructureAlertsScreen({super.key});

  @override
  ConsumerState<RoadInfrastructureAlertsScreen> createState() => _RoadInfrastructureAlertsScreenState();
}

class _RoadInfrastructureAlertsScreenState extends ConsumerState<RoadInfrastructureAlertsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'All';

  final List<RoadAlert> _alerts = [
    RoadAlert(
      id: '1',
      title: 'Babusar Top Pass Closed (Heavy Snowfall)',
      urduTitle: 'بابوسر ٹاپ بھاری برف باری کی وجہ سے بند',
      location: 'Babusar Pass (4,173m)',
      route: 'Naran - Chilas Highway',
      severity: 'Critical Blockage',
      alertType: 'Snow Blockade',
      description: 'شدید برف باری کے بعد راستہ ہر قسم کی ٹریفک کے لیے بند ہے۔ گلگت جانے والی گاڑیاں شاہراہ قراقرم (براستہ بشام، کوہستان) استعمال کریں۔',
      timeAgo: '18 mins ago',
      verifiedCount: 38,
    ),
    RoadAlert(
      id: '2',
      title: 'KKH Kohistan Mudslide Cleared (1-Way)',
      urduTitle: 'شاہراہ قراقرم کوہستان میں لینڈ سلائیڈنگ، یکطرفہ ٹریفک بحال',
      location: 'Dassu / Komila',
      route: 'Karakoram Highway (N-35)',
      severity: 'Caution',
      alertType: 'Landslide',
      description: 'FWO اور این ایچ اے کی بھاری مشینری نے ملبہ ہٹا کر یکطرفہ ٹریفک بحال کر دی ہے۔ محتاط ڈرائیونگ کریں۔',
      timeAgo: '42 mins ago',
      verifiedCount: 24,
    ),
    RoadAlert(
      id: '3',
      title: 'Lake Saif-ul-Muluk: 4x4 Jeep Required',
      urduTitle: 'سیف الملوک ٹریک: عام گاڑیوں کا داخلہ ممنوع، صرف 4x4 جیپ',
      location: 'Naran to Lake Saif-ul-Muluk',
      route: 'Mountain Jeep Track',
      severity: 'Caution',
      alertType: '4x4 Jeep Only',
      description: 'پھسلن اور پتھریلے ٹریک کی وجہ سے عام کاروں کے جانے پر پابندی ہے۔ صرف مقامی تجربہ کار جیپ ڈرائیورز کی خدمات لیں۔',
      timeAgo: '2 hours ago',
      verifiedCount: 52,
    ),
    RoadAlert(
      id: '4',
      title: 'Hunza Karimabad ATM Cash Depleted',
      urduTitle: 'کریم آباد ہنزہ کے 2 اے ٹی ایمز میں کیش ختم',
      location: 'Karimabad Main Bazaar, Hunza',
      route: 'Central Hunza',
      severity: 'Info',
      alertType: 'ATM Out of Cash',
      description: 'حبیب بینک اور این بی پی کے اے ٹی ایمز میں کیش ختم ہو چکا ہے۔ سیاح علی آباد یا گلگت کینٹ سے کیش حاصل کر کے آئیں۔',
      timeAgo: '3 hours ago',
      verifiedCount: 19,
    ),
    RoadAlert(
      id: '5',
      title: 'Murree Expressway (M-2/Murree Hill Entry)',
      urduTitle: 'مری ایکسپریس وے پر دھند و پھسلن الرٹ',
      location: '17 Meel to Jhika Gali',
      route: 'Islamabad - Murree Expressway',
      severity: 'Moderate',
      alertType: 'Fog / Mist',
      description: 'شام کے وقت جھیکا گلی پر شدید دھند ہے، فوگ لائٹس کا استعمال لازمی کریں۔',
      timeAgo: '4 hours ago',
      verifiedCount: 15,
    ),
  ];

  final List<Map<String, dynamic>> _connectivityHeatmap = [
    {
      'region': 'Hunza & Nagar Valleys',
      'scom': 'SCOM 4G (High Speed - Best Coverage)',
      'zong': 'Zong 4G (Strong in Aliabad/Karimabad)',
      'telenor': 'Telenor 2G/Voice Only',
      'notes': 'Passu اور خنجراب کے قریب صرف SCOM سگنل کام کرتے ہیں۔',
    },
    {
      'region': 'Naran & Kaghan Valley',
      'scom': 'No SCOM coverage',
      'zong': 'Zong 4G (Excellent in Naran Bazaar)',
      'telenor': 'Telenor 4G / Jazz 4G (Good)',
      'notes': 'جلکھڈ اور لولو سر جھیل کے درمیان تمام سگنل مکمل غائب ہو جاتے ہیں (Dead Zone)۔',
    },
    {
      'region': 'Skardu & Deosai Plains',
      'scom': 'SCOM 4G (Standard across Skardu town)',
      'zong': 'Zong 4G (Limited to Airport / City)',
      'telenor': 'No coverage in Deosai',
      'notes': 'دیوسائی نیشنل پارک میں زیرو موبائل نیٹ ورک ہے۔ آف لائن جی پی ایس لازمی ڈاؤن لوڈ رکھیں۔',
    },
    {
      'region': 'Swat Valley & Kalam',
      'scom': 'No SCOM',
      'zong': 'Zong 4G (Very Fast)',
      'telenor': 'Telenor 4G / Jazz 4G (Stable)',
      'notes': 'مہوڈنڈ جھیل پر صرف جیپ ڈرائیورز کا وائرلیس ریڈیو کام کرتا ہے۔',
    },
  ];

  final List<Map<String, dynamic>> _emergencyMechanics = [
    {
      'name': 'Ustad Ghulam (4x4 Jeep Recovery Winch)',
      'region': 'Naran / Kaghan Valley',
      'phone': '03129845112',
      'service': '24/7 پہاڑی ٹوونگ اور 4x4 ریکوری',
      'verified': true,
    },
    {
      'name': 'Karakoram Highway Mountain Rescue',
      'region': 'Chilas / Kohistan Checkpoint',
      'phone': '03554129900',
      'service': 'ڈیزل پمپ خرابی، بریک فیل اور ایمرجنسی کھینچنا',
      'verified': true,
    },
    {
      'name': 'Skardu Road Alpine Towing & Mechanics',
      'region': 'Jaglot - Skardu Strategic Road',
      'phone': '03469018442',
      'service': 'پتھریلے ٹریک پر ٹائر برسٹ اور کلاچ پلیٹ تبدیل',
      'verified': true,
    },
    {
      'name': 'Tourist Police Emergency Assistance',
      'region': 'Punjab & Northern Tourist Helpline',
      'phone': '1421',
      'service': 'سرکاری ٹورسٹ پولیس اور ریسکیو 1122 تعاون',
      'verified': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _callMechanic(String phone) async {
    final uri = Uri.parse('tel:$phone');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    } catch (_) {}
  }

  void _showReportDialog() {
    final lang = ref.read(languageProvider);
    final titleController = TextEditingController();
    final locationController = TextEditingController();
    String selectedType = 'لینڈ سلائیڈنگ (Landslide)';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.add_location_alt_rounded, color: Color(0xFFE65F2B)),
            const SizedBox(width: 8),
            Text(AppStrings.tr('report_alert_dialog_title', lang), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: AppStrings.tr('report_alert_detail_label', lang),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: locationController,
                decoration: InputDecoration(
                  labelText: AppStrings.tr('report_alert_location_label', lang),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: selectedType,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                items: [
                  'لینڈ سلائیڈنگ (Landslide)',
                  'برف باری / سڑک بند (Snow Block)',
                  'صرف 4x4 جیپ (4x4 Jeep Only)',
                  'اے ٹی ایم میں کیش ختم (ATM Dry)',
                  'پٹرول پمپ بند (Petrol Dry)',
                  'نیٹ ورک سگنل بند (No Network)',
                ].map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(fontSize: 12)))).toList(),
                onChanged: (val) => selectedType = val ?? selectedType,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(AppStrings.tr('report_alert_cancel', lang)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF006644),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                setState(() {
                  _alerts.insert(
                    0,
                    RoadAlert(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      title: titleController.text,
                      urduTitle: titleController.text,
                      location: locationController.text.isEmpty ? 'Karakoram Range' : locationController.text,
                      route: 'Community Reported',
                      severity: 'Crowdsourced Alert',
                      alertType: selectedType,
                      description: 'ساتھی سیاح نے ابھی رپورٹ درج کی ہے۔ ٹریفک کنٹرولر تصدیق کر رہے ہیں۔',
                      timeAgo: 'Just now',
                      verifiedCount: 1,
                    ),
                  );
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('✅ آپ کی رپورٹ کمیونٹی میپ پر شامل کر دی گئی ہے۔ شکریہ!'),
                    backgroundColor: Color(0xFF059669),
                  ),
                );
              }
            },
            child: Text(AppStrings.tr('report_alert_post', lang)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark ? Colors.white : AppColors.textPrimary;
    final cardBgColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final lang = ref.watch(languageProvider);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppStrings.tr('live_alerts_appbar_title', lang), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
            Text(AppStrings.tr('live_alerts_appbar_subtitle', lang), style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFFE65F2B),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFFE65F2B),
          tabs: [
            Tab(icon: const Icon(Icons.warning_amber_rounded), text: AppStrings.tr('tab_live_alerts', lang)),
            Tab(icon: const Icon(Icons.signal_cellular_alt), text: AppStrings.tr('tab_signal_heatmap', lang)),
            Tab(icon: const Icon(Icons.build_rounded), text: AppStrings.tr('tab_mechanics', lang)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showReportDialog,
        backgroundColor: const Color(0xFFE65F2B),
        icon: const Icon(Icons.add_location_alt_rounded, color: Colors.white),
        label: Text(AppStrings.tr('report_alert_post', lang), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // ── TAB 1: Live Road Alerts ───────────────────────────────────────
          _buildRoadAlertsTab(context, isDark, primaryTextColor, cardBgColor, lang),

          // ── TAB 2: Cellular Connectivity Heatmap ─────────────────────────
          _buildConnectivityTab(context, isDark, primaryTextColor, cardBgColor),

          // ── TAB 3: Rural Mechanics & Towing Rescue ───────────────────────
          _buildMechanicsTab(context, isDark, primaryTextColor, cardBgColor),
        ],
      ),
    );
  }

  Widget _buildRoadAlertsTab(BuildContext context, bool isDark, Color primaryTextColor, Color cardBgColor, AppLanguage lang) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      children: [
        // Live Telemetry Banner
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF7F1D1D), Color(0xFF991B1B)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.red.withValues(alpha: 0.25),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.radar_rounded, color: Colors.white, size: 30),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('کرائوڈ سورسڈ لائیو مانیٹرنگ فعال ہے', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 2),
                    Text(
                      'این ایچ اے، ریسکیو 1122 اور 450+ لوکل ڈرائیورز راستوں کی لائیو رپورٹنگ کر رہے ہیں۔',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 11.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Video Button
        Center(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF006644),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () async {
              final uri = Uri.parse('https://example.com/video');
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
            icon: const Icon(Icons.play_circle_filled, size: 18),
            label: Text(AppStrings.tr('video_button_label', lang), style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),

        const SizedBox(height: 16),

        // Filter Pills
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [AppStrings.tr('filter_all', lang), AppStrings.tr('filter_landslide', lang), AppStrings.tr('filter_snow_blockade', lang), AppStrings.tr('filter_4x4_jeep_only', lang), AppStrings.tr('filter_atm_out_of_cash', lang)].map((f) {
              final isSel = _selectedFilter == f;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(f, style: TextStyle(fontSize: 12, fontWeight: isSel ? FontWeight.bold : FontWeight.normal)),
                  selected: isSel,
                  selectedColor: const Color(0xFF006644),
                  labelStyle: TextStyle(color: isSel ? Colors.white : primaryTextColor),
                  onSelected: (val) => setState(() => _selectedFilter = f),
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 14),

        // List of Alerts
        for (final a in _alerts)
          if (_selectedFilter == 'All' || a.alertType == _selectedFilter)
            Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardBgColor,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: a.severity.contains('Critical')
                      ? const Color(0xFFDC2626).withValues(alpha: 0.4)
                      : a.severity.contains('Caution')
                          ? const Color(0xFFE65F2B).withValues(alpha: 0.3)
                          : Colors.grey.withValues(alpha: 0.2),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: a.severity.contains('Critical')
                              ? const Color(0xFFDC2626).withValues(alpha: 0.12)
                              : const Color(0xFFE65F2B).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          a.severity,
                          style: TextStyle(
                            color: a.severity.contains('Critical') ? const Color(0xFFDC2626) : const Color(0xFFE65F2B),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.access_time_rounded, size: 13, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(a.timeAgo, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(a.urduTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 4),
                  Text(a.title, style: TextStyle(fontSize: 12, color: primaryTextColor.withValues(alpha: 0.7))),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 14, color: Color(0xFF006644)),
                      const SizedBox(width: 4),
                      Text('${a.location} • ${a.route}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF006644))),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(a.description, style: TextStyle(fontSize: 12.5, color: primaryTextColor.withValues(alpha: 0.85), height: 1.4)),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.verified, size: 16, color: Color(0xFF059669)),
                          const SizedBox(width: 6),
                          Text('${a.verifiedCount} ڈرائیورز نے تصدیق کی', style: const TextStyle(fontSize: 11.5, color: Color(0xFF059669), fontWeight: FontWeight.bold)),
                        ],
                      ),
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          backgroundColor: const Color(0xFF006644).withValues(alpha: 0.08),
                        ),
                        onPressed: () {
                          setState(() => a.verifiedCount++);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('شکریہ! آپ نے اس الرٹ کی تصدیق کر دی ہے۔')),
                          );
                        },
                        icon: const Icon(Icons.thumb_up_alt_outlined, size: 14, color: Color(0xFF006644)),
                        label: const Text('میں نے دیکھا (Confirm)', style: TextStyle(fontSize: 11, color: Color(0xFF006644), fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
      ],
    );
  }

  Widget _buildConnectivityTab(BuildContext context, bool isDark, Color primaryTextColor, Color cardBgColor) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1D4ED8).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF1D4ED8).withValues(alpha: 0.3)),
          ),
          child: const Row(
            children: [
              Icon(Icons.wifi_tethering_rounded, color: Color(0xFF1D4ED8), size: 28),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('سیلولر سگنل ہیٹ میپ (Cellular Coverage Guide)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1D4ED8))),
                    SizedBox(height: 2),
                    Text(
                      'شمالی علاقوں میں کونسی سم چلتی ہے اور کہاں انٹرنیٹ مکمل غائب ہوتا ہے، تاکہ آپ کا رابطہ فیملی سے نہ ٹوٹے۔',
                      style: TextStyle(fontSize: 11.5, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        for (final item in _connectivityHeatmap)
          Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardBgColor,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item['region'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const Icon(Icons.network_check_rounded, color: Color(0xFF059669)),
                  ],
                ),
                const Divider(height: 20),
                _buildNetworkRow('🟢 SCOM (گلگت بلتستان)', item['scom'], const Color(0xFF059669)),
                _buildNetworkRow('🟣 Zong 4G', item['zong'], const Color(0xFF7C3AED)),
                _buildNetworkRow('🔵 Telenor / Jazz', item['telenor'], const Color(0xFF2563EB)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, size: 16, color: Colors.amber),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(item['notes'], style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildNetworkRow(String network, String status, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(network, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: color)),
          ),
          Expanded(child: Text(status, style: const TextStyle(fontSize: 12))),
        ],
      ),
    );
  }

  Widget _buildMechanicsTab(BuildContext context, bool isDark, Color primaryTextColor, Color cardBgColor) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF006644).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF006644).withValues(alpha: 0.3)),
          ),
          child: const Row(
            children: [
              Icon(Icons.handyman_rounded, color: Color(0xFF006644), size: 28),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('پہاڑی مکینک اور 4x4 ایمرجنسی ٹوونگ نیٹ ورک', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF006644))),
                    SizedBox(height: 2),
                    Text(
                      'خطرناک گھاٹیوں میں گاڑی بند ہونے یا بریک فیل ہونے پر فوری امداد کے لیے تصدیق شدہ مکینکس۔',
                      style: TextStyle(fontSize: 11.5, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        for (final m in _emergencyMechanics)
          Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(m['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFF059669).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text('Verified Mechanic 🛡️', style: TextStyle(color: Color(0xFF059669), fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(m['region'], style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(m['service'], style: const TextStyle(fontSize: 12.5)),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('ہیلپ لائن / فون: ${m['phone']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF006644),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () => _callMechanic(m['phone']),
                        icon: const Icon(Icons.call, size: 16),
                        label: const Text('کال کریں (Call)', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
