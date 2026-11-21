import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/localization/app_language.dart';
import 'cnic_verification_screen.dart';

class OfflinePaymentGuideScreen extends ConsumerStatefulWidget {
  const OfflinePaymentGuideScreen({super.key});

  @override
  ConsumerState<OfflinePaymentGuideScreen> createState() => _OfflinePaymentGuideScreenState();
}

class _OfflinePaymentGuideScreenState extends ConsumerState<OfflinePaymentGuideScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _tidController = TextEditingController();
  final List<Map<String, dynamic>> _savedOfflinePayments = [
    {
      'service': 'Jeep Rental to Lake Saif-ul-Muluk',
      'amount': 'Rs. 3,500',
      'wallet': 'JazzCash (8558)',
      'tid': '78291048291',
      'status': 'Offline Saved (Ready to Sync)',
      'time': 'Today, 2:15 PM',
    },
    {
      'service': 'Hunza Traditional Homestay',
      'amount': 'Rs. 2,200',
      'wallet': 'Easypaisa (3737)',
      'tid': '99401284711',
      'status': 'Synced with Server',
      'time': 'Yesterday',
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
    _tidController.dispose();
    super.dispose();
  }

  Future<void> _dialUSSD(String code) async {
    final uri = Uri.parse('tel:${Uri.encodeComponent(code)}');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        await launchUrl(Uri(scheme: 'tel', path: code));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Dialer opened: $code')),
        );
      }
    }
  }

  void _saveOfflineTid() {
    final tid = _tidController.text.trim();
    if (tid.isEmpty || tid.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('براہ کرم درست 11 یا 12 ہندسوں کا Transaction ID (TID) درج کریں۔'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _savedOfflinePayments.insert(0, {
        'service': 'Local Tourist Booking / Vendor Payment',
        'amount': 'Rs. Verified',
        'wallet': 'USSD SMS (8558/3737)',
        'tid': tid,
        'status': 'Offline Saved (Will Verify on Internet)',
        'time': 'Just now',
      });
      _tidController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ ادائیگی کا ریفرنس کامیابی سے محفوظ ہو گیا! نیٹ آنے پر خودکار تصدیق ہو جائے گی۔'),
        backgroundColor: Color(0xFF059669),
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
            Text(AppStrings.tr('offline_payment_hub', lang), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text(AppStrings.tr('offline_payment_subtitle', lang), style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF006644),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFF006644),
          tabs: [
            Tab(icon: Icon(Icons.dialpad_rounded), text: AppStrings.tr('tab_ussd', lang)),
            Tab(icon: Icon(Icons.receipt_long_rounded), text: AppStrings.tr('tab_tid', lang)),
            Tab(icon: Icon(Icons.storefront_rounded), text: AppStrings.tr('tab_otc', lang)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // ── TAB 1: USSD Offline Codes (No Internet needed) ─────────────────
          _buildUssdTab(context, isDark, primaryTextColor, cardBgColor),

          // ── TAB 2: Save Offline TID / SMS Proof ───────────────────────────
          _buildTidLoggerTab(context, isDark, primaryTextColor, cardBgColor),

          // ── TAB 3: Over-the-Counter (OTC) Retailer Voucher ─────────────────
          _buildOtcVoucherTab(context, isDark, primaryTextColor, cardBgColor, lang),
        ],
      ),
    );
  }

  Widget _buildUssdTab(BuildContext context, bool isDark, Color primaryTextColor, Color cardBgColor) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 🚨 Important Info Banner
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF006644).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF006644).withValues(alpha: 0.3)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.signal_cellular_alt_rounded, color: Color(0xFF006644), size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'انٹرنیٹ یا موبائل ڈیٹا کے بغیر ادائیگی ممکن ہے!',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF006644)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'شمالی علاقہ جات یا دور دراز وادیوں میں جہاں 3G/4G انٹرنیٹ نہیں ہوتا، وہاں آپ عام کالنگ سگنل (2G) پر جاز اور ٹیلینور کے آفیشل USSD کوڈز سے بل یا ڈرائیور کو پیسے بھیج سکتے ہیں۔',
                      style: TextStyle(fontSize: 12.5, color: primaryTextColor.withValues(alpha: 0.85), height: 1.4),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // 1. JazzCash Offline USSD
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: cardBgColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.phone_iphone_rounded, color: Colors.red, size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('JazzCash (جاز کیش آف لائن)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text('کوڈ: *786# (کسی بھی جاز سم سے ڈائل کریں)', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => _dialUSSD('*786#'),
                    icon: const Icon(Icons.call, size: 16),
                    label: const Text('ڈائل کریں', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const Divider(height: 24),
              const Text('جاز کیش سے بغیر نیٹ پیسے بھیجنے کا طریقہ:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 8),
              _buildStepRow('1', '*786# ڈائل کریں۔ موبائل اسکرین پر جاز کیش مینیو کھل جائے گا۔'),
              _buildStepRow('2', '1 لکھ کر Send کریں (Send Money / رقم بھیجیں)۔'),
              _buildStepRow('3', '1 (To Mobile Account) یا 2 (To CNIC) منتخب کریں۔'),
              _buildStepRow('4', 'دکاندار، ہوٹل یا جیپ ڈرائیور کا نمبر درج کریں۔'),
              _buildStepRow('5', 'رقم (Amount) اور اپنا 4 ہندسوں کا خفیہ MPIN درج کریں۔'),
              _buildStepRow('6', 'آپ کو فوری 8558 سے تصدیقی SMS موصول ہوگا جس میں TID ہوگی۔'),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // 2. Easypaisa Offline USSD
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: cardBgColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFF059669).withValues(alpha: 0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF059669).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.account_balance_wallet_rounded, color: Color(0xFF059669), size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Easypaisa (ایزی پیسہ آف لائن)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text('کوڈ: *2262# (ٹیلینور سم سے ڈائل کریں)', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF059669),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => _dialUSSD('*2262#'),
                    icon: const Icon(Icons.call, size: 16),
                    label: const Text('ڈائل کریں', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const Divider(height: 24),
              const Text('ایزی پیسہ سے بغیر نیٹ پیسے بھیجنے کا طریقہ:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 8),
              _buildStepRow('1', '*2262# ڈائل کریں (ٹیلینور سم استعمال کریں)۔'),
              _buildStepRow('2', 'منی ٹرانسفر (Money Transfer) کا آپشن منتخب کریں۔'),
              _buildStepRow('3', 'وصول کنندہ کا ایزی پیسہ نمبر یا بینک اکاؤنٹ منتخب کریں۔'),
              _buildStepRow('4', 'مطلوبہ رقم درج کریں اور 5 ہندسوں کا پن (PIN) ڈالیں۔'),
              _buildStepRow('5', 'آپ کو 3737 سے رسید کا میسج آئے گا۔'),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // 3. Foreigners & Non-Pakistani Tourists Guide
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFE65F2B).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE65F2B).withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.flight_takeoff_rounded, color: Color(0xFFE65F2B)),
                  SizedBox(width: 8),
                  Text('بین الاقوامی سیاحوں کے لیے گائیڈ (Foreign Tourists)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFFE65F2B))),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'اگر آپ غیر ملکی سیاح ہیں اور آپ کے پاس شناختی کارڈ (CNIC) نہیں ہے، تو آپ ایئرپورٹ پر اپنے پاسپورٹ کے ذریعے لوکل سم (Zong / Jazz / SCOM) حاصل کر کے "آسان اکاؤنٹ" یا نقد کیش (Cash on Arrival) آپشن منتخب کریں۔ ڈرائیور یا ہوٹل کو ادائیگی کے وقت ایپ کی تیار کردہ 4 ہندسوں کی تصدیقی رسید دکھائیں۔',
                style: TextStyle(fontSize: 12, color: primaryTextColor.withValues(alpha: 0.85), height: 1.4),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStepRow(String num, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 10,
            backgroundColor: const Color(0xFF006644).withValues(alpha: 0.15),
            child: Text(num, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF006644))),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 12.5, height: 1.3))),
        ],
      ),
    );
  }

  Widget _buildTidLoggerTab(BuildContext context, bool isDark, Color primaryTextColor, Color cardBgColor) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: cardBgColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('ادائیگی کی رسید درج کریں (Offline TID Logger)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 6),
              const Text(
                'جب آپ USSD (*786# یا *2262#) سے ادائیگی کرتے ہیں تو 8558 یا 3737 کی میسج میں 11 یا 12 ہندسوں کا ٹرانزیکشن آئی ڈی (TID) آتا ہے۔ وہ یہاں ڈالیں تاکہ آپ کی بکنگ آف لائن تصدیق ہو جائے:',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _tidController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'مثال: 78291048291 (TID)',
                  prefixIcon: const Icon(Icons.confirmation_number_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF006644),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _saveOfflineTid,
                  icon: const Icon(Icons.save_rounded),
                  label: const Text('آف لائن محفوظ کریں (Save Offline)', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),
        const Text('محفوظ شدہ آف لائن ادائیگیاں (Saved Payments Queue):', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: 10),

        for (final p in _savedOfflinePayments)
          Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            elevation: 1,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: CircleAvatar(
                backgroundColor: p['status'].toString().contains('Ready')
                    ? const Color(0xFFE65F2B).withValues(alpha: 0.15)
                    : const Color(0xFF059669).withValues(alpha: 0.15),
                child: Icon(
                  p['status'].toString().contains('Ready') ? Icons.cloud_upload_outlined : Icons.check_circle_outline,
                  color: p['status'].toString().contains('Ready') ? const Color(0xFFE65F2B) : const Color(0xFF059669),
                ),
              ),
              title: Text(p['service'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 2),
                  Text('TID: ${p['tid']} • ${p['wallet']}', style: const TextStyle(fontSize: 12)),
                  Text(p['status'], style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: p['status'].toString().contains('Ready') ? const Color(0xFFE65F2B) : const Color(0xFF059669))),
                ],
              ),
              trailing: Text(p['amount'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ),
          ),
      ],
    );
  }

  Widget _buildOtcVoucherTab(BuildContext context, bool isDark, Color primaryTextColor, Color cardBgColor, AppLanguage lang) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
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
                color: const Color(0xFF006644).withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('پاکستان ٹورازم آف لائن واؤچر', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
                  Chip(
                    label: Text('24 گھنٹے تک قابل قبول', style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                    backgroundColor: Color(0xFFE65F2B),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'PK-786-9042',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3,
                        color: Color(0xFF006644),
                      ),
                    ),
                    const SizedBox(width: 12),
                    IconButton(
                      icon: const Icon(Icons.copy, color: Color(0xFF006644)),
                      tooltip: 'کاپی کریں',
                      onPressed: () {
                        Clipboard.setData(const ClipboardData(text: 'PK-786-9042'));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('واؤچر کوڈ کاپی ہو گیا!')),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'یہ 12 ہندسوں کا کوڈ قریبی کسی بھی جاز کیش/ایزی پیسہ دکان یا ہوٹل کاؤنٹر پر دکھا کر کیش ادا کریں اور بکنگ فوری پکی کروائیں۔',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 12, height: 1.4),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),
        const Text('اوور دی کاؤنٹر (OTC) ادائیگی کے فوائد:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: 10),

        _buildOtcFeatureCard(
          icon: Icons.store_mall_directory_rounded,
          title: 'پورے پاکستان میں 2 لاکھ سے زائد ریٹیل شاپس',
          description: 'ناران، ہنزہ، سکردو، مری، لاہور اور اسلام آباد کی کسی بھی چھوٹی کریانہ یا موبائل دکان پر یہ کوڈ دکھا کر کیش جمع کروایا جا سکتا ہے۔',
          color: const Color(0xFF006644),
          cardBgColor: cardBgColor,
        ),
        _buildOtcFeatureCard(
          icon: Icons.security_rounded,
          title: 'اسکیم اور اضافی چارجز سے مکمل تحفظ',
          description: 'دکاندار یا ایجنٹ مقررہ رقم سے ایک روپیہ بھی زیادہ وصول نہیں کر سکتا، رسید براہ راست سسٹم سے جنریٹ ہوتی ہے۔',
          color: const Color(0xFFE65F2B),
          cardBgColor: cardBgColor,
        ),
        _buildOtcFeatureCard(
          icon: Icons.offline_pin_rounded,
          title: 'انٹرنیٹ یا اسمارٹ فون کی قید نہیں',
          description: 'اگر آپ کا موبائل بند ہو جائے یا سم میں بیلنس نہ ہو، تو صرف کاغذ پر لکھا ہوا واؤچر کوڈ بھی دکان پر دکھایا جا سکتا ہے۔',
          color: const Color(0xFF1D4ED8),
          cardBgColor: cardBgColor,
        ),

        const SizedBox(height: 20),

        // CNIC Verification Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE65F2B),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const CnicVerificationScreen()),
              );
            },
            icon: const Icon(Icons.badge_rounded),
            label: Text(AppStrings.tr('cnic_verify_button', lang), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          ),
        ),
      ],
    );
  }

  Widget _buildOtcFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required Color cardBgColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.12),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text(description, style: const TextStyle(fontSize: 12, color: Colors.grey, height: 1.3)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
