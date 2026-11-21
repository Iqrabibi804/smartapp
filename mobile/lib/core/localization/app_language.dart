import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppLanguage { english, urdu, punjabi, chinese, arabic }

class LanguageNotifier extends StateNotifier<AppLanguage> {
  LanguageNotifier() : super(AppLanguage.english);

  void setLanguage(AppLanguage lang) => state = lang;
}

final languageProvider = StateNotifierProvider<LanguageNotifier, AppLanguage>((ref) {
  return LanguageNotifier();
});

class AppStrings {
  static String tr(String key, AppLanguage lang) {
    final Map<String, Map<AppLanguage, String>> translations = {
      'app_title': {
        AppLanguage.english: 'SmartMap Punjab',
        AppLanguage.urdu: 'سمارٹ میپ پنجاب',
        AppLanguage.punjabi: 'سمارٹ میپ پنجاب',
        AppLanguage.chinese: '旁遮普智能地图',
        AppLanguage.arabic: 'خريطة البنجاب الذكية',
      },
      'search_hint': {
        AppLanguage.english: 'Search cities, hospitals, cakes, restaurants...',
        AppLanguage.urdu: 'شہر، ہسپتال، بیکری اور کھانے تلاش کریں...',
        AppLanguage.punjabi: 'شہر، ہسپتال، کیک تے ہوٹل لبھو...',
        AppLanguage.chinese: '搜索城市、医院、蛋糕、餐馆...',
        AppLanguage.arabic: 'ابحث عن المدن والمستشفيات والمطاعم...',
      },
      'smart_assistant': {
        AppLanguage.english: 'Smart Travel Assistant',
        AppLanguage.urdu: 'سمارٹ سفری معاون',
        AppLanguage.punjabi: 'سمارٹ سفری مددگار',
        AppLanguage.chinese: '智能出行助手',
        AppLanguage.arabic: 'مساعد السفر الذكي',
      },
      'hospitals': {
        AppLanguage.english: 'Hospitals & Medical',
        AppLanguage.urdu: 'ہاسپٹلز و کلینک',
        AppLanguage.punjabi: 'ہسپتال تے علاج',
        AppLanguage.chinese: '医院与医疗',
        AppLanguage.arabic: 'المستشفيات والطب',
      },
      'route_planner': {
        AppLanguage.english: 'Plan Route & Trips',
        AppLanguage.urdu: 'سمارٹ روٹ پلانر',
        AppLanguage.punjabi: 'روٹ تے سفر پلان کرو',
        AppLanguage.chinese: '路线与行程规划',
        AppLanguage.arabic: 'تخطيط المسار والرحلات',
      },
      'bakeries': {
        AppLanguage.english: 'Bakeries & Cakes',
        AppLanguage.urdu: 'کیک، بیکریز و کھانا',
        AppLanguage.punjabi: 'کیک تے بیکریاں',
        AppLanguage.chinese: '面包糕点店',
        AppLanguage.arabic: 'المخابز والحلويات',
      },
      'tourist_sos': {
        AppLanguage.english: 'Tourist SOS & Safety',
        AppLanguage.urdu: 'ٹورسٹ پولیس و مدد',
        AppLanguage.punjabi: 'ٹورسٹ پولیس تے بچاؤ',
        AppLanguage.chinese: '游客紧急救援',
        AppLanguage.arabic: 'طوارئ السياح والأمان',
      },
      'live_rates': {
        AppLanguage.english: 'Live Anti-Scam Rates',
        AppLanguage.urdu: 'آج کا ریٹ (اینٹی اسکیم)',
        AppLanguage.punjabi: 'اج دا ریٹ',
        AppLanguage.chinese: '今日反欺诈实时价格',
        AppLanguage.arabic: 'الأسعار الحية لمنع الاحتيال',
      },
      'female_safety': {
        AppLanguage.english: 'Female & Family Safety Shield',
        AppLanguage.urdu: 'خواتین و فیملی سیفٹی آڈٹ',
        AppLanguage.punjabi: 'زنانیاں تے ٹبر دی حفاظت',
        AppLanguage.chinese: '女性与家庭安全认证',
        AppLanguage.arabic: 'أمان النساء والعائلات',
      },
      'local_vans': {
        AppLanguage.english: 'Local Vans & Transit Route',
        AppLanguage.urdu: 'عوامی وین و چنگچی روٹ',
        AppLanguage.punjabi: 'لوکل ویگن تے رکشہ روٹ',
        AppLanguage.chinese: '当地小巴与中转路线',
        AppLanguage.arabic: 'الحافلات المحلية والنقل',
      },
      'green_tourist': {
        AppLanguage.english: 'Green Tourist Cleanup Score',
        AppLanguage.urdu: 'گرین ٹورسٹ مہم و پوائنٹس',
        AppLanguage.punjabi: 'گرین ٹورسٹ انعام',
        AppLanguage.chinese: '环保游客积分奖励',
        AppLanguage.arabic: 'مبادرة السائح الأخضر',
      },
      'tab_home': {
        AppLanguage.english: 'Home',
        AppLanguage.urdu: 'ہوم',
        AppLanguage.punjabi: 'ہوم',
        AppLanguage.chinese: '首页',
        AppLanguage.arabic: 'الرئيسية',
      },
      'tab_map': {
        AppLanguage.english: 'Map',
        AppLanguage.urdu: 'نقشہ',
        AppLanguage.punjabi: 'نقشہ',
        AppLanguage.chinese: '地图',
        AppLanguage.arabic: 'الخريطة',
      },
      'tab_cities': {
        AppLanguage.english: 'Cities',
        AppLanguage.urdu: 'شہر',
        AppLanguage.punjabi: 'شہر',
        AppLanguage.chinese: '城市',
        AppLanguage.arabic: 'المدن',
      },
      'tab_saved': {
        AppLanguage.english: 'Saved',
        AppLanguage.urdu: 'محفوظ',
        AppLanguage.punjabi: 'محفوظ',
        AppLanguage.chinese: '收藏',
        AppLanguage.arabic: 'المحفوظات',
      },
      'tab_profile': {
        AppLanguage.english: 'Profile',
        AppLanguage.urdu: 'پروفائل',
        AppLanguage.punjabi: 'پروفائل',
        AppLanguage.chinese: '个人',
        AppLanguage.arabic: 'الملف',
      },
      'ai_guide': {
        AppLanguage.english: 'AI Guide',
        AppLanguage.urdu: 'اے آئی گائیڈ',
        AppLanguage.punjabi: 'اے آئی مددگار',
        AppLanguage.chinese: 'AI 导游',
        AppLanguage.arabic: 'دليل الذكاء الاصطناعي',
      },
      'pakistan_tools': {
        AppLanguage.english: 'Pakistan-First Tools',
        AppLanguage.urdu: 'پاکستان فرسٹ ٹولز',
        AppLanguage.punjabi: 'پاکستان ٹولز',
        AppLanguage.chinese: '巴基斯坦首创工具',
        AppLanguage.arabic: 'أدوات باكستان الحصرية',
      },
      'budget_calculator': {
        AppLanguage.english: 'Budget Calculator',
        AppLanguage.urdu: 'بجٹ کیلکولیٹر',
        AppLanguage.punjabi: 'بجٹ کیلکولیٹر',
        AppLanguage.chinese: '预算计算器',
        AppLanguage.arabic: 'حاسبة الميزانية',
      },
      'group_splitter': {
        AppLanguage.english: 'Group Bill Splitter',
        AppLanguage.urdu: 'گروپ بل تقسیم',
        AppLanguage.punjabi: 'دوستاں دا بل حساب',
        AppLanguage.chinese: '群组分账器',
        AppLanguage.arabic: 'تقسيم الفاتورة',
      },
      'anti_scam': {
        AppLanguage.english: 'Anti-Scam Prices',
        AppLanguage.urdu: 'اصلی بمقابلہ سیاحتی ریٹ',
        AppLanguage.punjabi: 'اصلی ریٹ',
        AppLanguage.chinese: '防欺诈真实价格',
        AppLanguage.arabic: 'الأسعار الحقيقية',
      },
      'offline_packs': {
        AppLanguage.english: 'Offline City Packs',
        AppLanguage.urdu: 'بغیر نیٹ سٹی پیک',
        AppLanguage.punjabi: 'بغیر نیٹ سٹی پیک',
        AppLanguage.chinese: '离线城市数据包',
        AppLanguage.arabic: 'حزم المدن دون إنترنت',
      },
      // New localisation keys for payment and alerts
      'offline_payment_hub': {
        AppLanguage.english: 'Offline Payment Hub 📶💳',
        AppLanguage.urdu: 'آف لائن ادائیگی ہب 📶💳',
        AppLanguage.punjabi: 'آف لائن ادائیگی ہب 📶💳',
        AppLanguage.chinese: '离线支付中心 📶💳',
        AppLanguage.arabic: 'محور الدفع دون اتصال 📶💳',
      },
      'offline_payment_subtitle': {
        AppLanguage.english: 'Pay offline with JazzCash & Easypaisa',
        AppLanguage.urdu: 'بغیر انٹرنیٹ جاز کیش و ایزی پیسہ سے ادائیگی',
        AppLanguage.punjabi: 'بغیر انٹرنیٹ جاز کیش و ایزی پیسہ سے ادائیگی',
        AppLanguage.chinese: '使用 JazzCash 和 Easypaisa 离线付款',
        AppLanguage.arabic: 'ادفع دون إنترنت باستخدام JazzCash & Easypaisa',
      },
      'tab_ussd': {
        AppLanguage.english: 'USSD Codes (Offline)',
        AppLanguage.urdu: 'USSD کوڈز (بغیر نیٹ)',
        AppLanguage.punjabi: 'USSD کوڈز (بغیر نیٹ)',
        AppLanguage.chinese: 'USSD 代码（离线）',
        AppLanguage.arabic: 'رموز USSD (دون اتصال)',
      },
      'tab_tid': {
        AppLanguage.english: 'Save TID Receipt',
        AppLanguage.urdu: 'TID رسید محفوظ کریں',
        AppLanguage.punjabi: 'TID رسید محفوظ کریں',
        AppLanguage.chinese: '保存 TID 收据',
        AppLanguage.arabic: 'احفظ إيصال TID',
      },
      'tab_otc': {
        AppLanguage.english: 'OTC Voucher',
        AppLanguage.urdu: 'OTC واؤچر',
        AppLanguage.punjabi: 'OTC واؤچر',
        AppLanguage.chinese: 'OTC 代金券',
        AppLanguage.arabic: 'قسيمة OTC',
      },
      'video_button_label': {
        AppLanguage.english: 'Watch Video',
        AppLanguage.urdu: 'ویڈیو دیکھیں',
        AppLanguage.punjabi: 'ਵੀਡੀਓ ਵੇਖੋ',
        AppLanguage.chinese: '观看视频',
        AppLanguage.arabic: 'مشاهدة الفيديو',
      },
      'cnic_verify_button': {
        AppLanguage.english: 'Verify CNIC',
        AppLanguage.urdu: 'CNIC کی تصدیق',
        AppLanguage.punjabi: 'CNIC ਦੀ ਪੁਸ਼ਟੀ',
        AppLanguage.chinese: '验证 CNIC',
        AppLanguage.arabic: 'تحقق من CNIC',
      },
      'cnic_verify_success': {
        AppLanguage.english: '✅ CNIC verified successfully!',
        AppLanguage.urdu: '✅ CNIC کی تصدیق ہو گئی!',
        AppLanguage.punjabi: '✅ CNIC ਦੀ ਪੁਸ਼ਟੀ ਹੋ ਗਈ!',
        AppLanguage.chinese: '✅ CNIC 验证成功！',
        AppLanguage.arabic: '✅ تم التحقق من CNIC بنجاح!',
      },
      'cnic_verify_failure': {
        AppLanguage.english: '❌ Invalid CNIC (must be 11‑12 digits).',
        AppLanguage.urdu: '❌ غیر معتبر CNIC (11‑12 ہندسوں کی ضرورت ہے).',
        AppLanguage.punjabi: '❌ ਗਲਤ CNIC (11‑12 ਅੰਕ ਹੋਣੇ ਚਾਹੀਦੇ ਹਨ).',
        AppLanguage.chinese: '❌ 无效的 CNIC（必须为 11‑12 位）.',
        AppLanguage.arabic: '❌ رقم CNIC غير صالحة (يجب أن تكون 11‑12 رقم).',
      },
      'offline_banner_text': {
        AppLanguage.english: 'Offline – showing saved data',
        AppLanguage.urdu: 'آف لائن – محفوظ شدہ ڈیٹا دکھائی جا رہا ہے',
        AppLanguage.punjabi: 'ਆਫਲਾਈਨ – ਸੇਵ ਕੀਤਾ ਡਾਟਾ ਦਿਖਾਇਆ ਜਾ ਰਿਹਾ ਹੈ',
        AppLanguage.chinese: '离线 – 正在显示已保存的数据',
        AppLanguage.arabic: 'بدون اتصال – عرض البيانات المحفوظة',
      },
      // New localisation keys for RoadInfrastructureAlertsScreen
      'live_alerts_appbar_title': {
        AppLanguage.english: 'Live Road & Landslide Alerts 🚧',
        AppLanguage.urdu: 'لائیو روڈ اور لینڈ سلائیڈ الرٹس 🚧',
        AppLanguage.punjabi: 'ਲਾਈਵ ਰੋਡ ਅਤੇ ਲੈਂਡਸਲਾਈਡ ਅਲਰਟਸ 🚧',
        AppLanguage.chinese: '实时道路和山体滑坡警报 🚧',
        AppLanguage.arabic: 'تنبيهات الطرق والانهيارات الحية 🚧',
      },
      'live_alerts_appbar_subtitle': {
        AppLanguage.english: 'Live conditions of northern routes and highways',
        AppLanguage.urdu: 'شمالی علاقہ جات و ہائی ویز کی لائیو صورتحال',
        AppLanguage.punjabi: 'ਉੱਤਰੀ ਰੂਟਾਂ ਅਤੇ ਹਾਈਵੇਜ਼ ਦੀ ਲਾਈਵ ਸਥਿਤੀ',
        AppLanguage.chinese: '北部道路和高速公路的实时状况',
        AppLanguage.arabic: 'الأحوال الحية لطرق وشبكات شمالية',
      },
      'tab_live_alerts': {
        AppLanguage.english: 'Live Alerts',
        AppLanguage.urdu: 'سڑک الرٹس (Live)',
        AppLanguage.punjabi: 'ਸੜਕ ਅਲਰਟਸ (Live)',
        AppLanguage.chinese: '实时警报',
        AppLanguage.arabic: 'إنذارات مباشرة',
      },
      'tab_signal_heatmap': {
        AppLanguage.english: 'Signal Heatmap',
        AppLanguage.urdu: 'سگنل ہیٹ میپ',
        AppLanguage.punjabi: 'ਸਿਗਨਲ ਹੀਟਮੈਪ',
        AppLanguage.chinese: '信号热图',
        AppLanguage.arabic: 'خريطة حرارة الإشارة',
      },
      'tab_mechanics': {
        AppLanguage.english: 'Mechanics & Towing',
        AppLanguage.urdu: 'پہاڑی مکینک و ٹوونگ',
        AppLanguage.punjabi: 'ਪਹਾੜੀ ਮਕੈਨਿਕਸ ਅਤੇ ਟੋਵਿੰਗ',
        AppLanguage.chinese: '机械与拖车',
        AppLanguage.arabic: 'الآليات والقاطرات',
      },
      'filter_all': {
        AppLanguage.english: 'All',
        AppLanguage.urdu: 'All',
        AppLanguage.punjabi: 'All',
        AppLanguage.chinese: 'All',
        AppLanguage.arabic: 'All',
      },
      'filter_landslide': {
        AppLanguage.english: 'Landslide',
        AppLanguage.urdu: 'Landslide',
        AppLanguage.punjabi: 'Landslide',
        AppLanguage.chinese: 'Landslide',
        AppLanguage.arabic: 'Landslide',
      },
      'filter_snow_blockade': {
        AppLanguage.english: 'Snow Blockade',
        AppLanguage.urdu: 'Snow Blockade',
        AppLanguage.punjabi: 'Snow Blockade',
        AppLanguage.chinese: 'Snow Blockade',
        AppLanguage.arabic: 'Snow Blockade',
      },
      'filter_4x4_jeep_only': {
        AppLanguage.english: '4x4 Jeep Only',
        AppLanguage.urdu: '4x4 Jeep Only',
        AppLanguage.punjabi: '4x4 Jeep Only',
        AppLanguage.chinese: '4x4 Jeep Only',
        AppLanguage.arabic: '4x4 Jeep Only',
      },
      'filter_atm_out_of_cash': {
        AppLanguage.english: 'ATM Out of Cash',
        AppLanguage.urdu: 'ATM Out of Cash',
        AppLanguage.punjabi: 'ATM Out of Cash',
        AppLanguage.chinese: 'ATM Out of Cash',
        AppLanguage.arabic: 'ATM Out of Cash',
      },
      'report_alert_dialog_title': {
        AppLanguage.english: 'Report Road Issue',
        AppLanguage.urdu: 'سڑک کی خرابی رپورٹ کریں',
        AppLanguage.punjabi: 'ਸੜਕ ਦੀ ਖਰਾਬੀ ਦੀ ਰਿਪੋਰਟ ਕਰੋ',
        AppLanguage.chinese: '报告道路问题',
        AppLanguage.arabic: 'الإبلاغ عن عطل في الطريق',
      },
      'report_alert_detail_label': {
        AppLanguage.english: 'Issue Detail (e.g., mudslide on road)',
        AppLanguage.urdu: 'مسئلے کی تفصیل (مثال: سڑک پر مٹی کا تودہ)',
        AppLanguage.punjabi: "ਮੁੱਦੇ ਦੀ ਵਿਸਥਾਰ (ਉਦਾਹਰਣ: ਸੜਕ 'ਤੇ ਮਿੱਟੀ ਦਾ ਟੋਡਾ)",
        AppLanguage.chinese: '问题细节（例如：道路泥石流）',
        AppLanguage.arabic: 'تفاصيل المشكلة (مثال: طين على الطريق)',
      },
      'report_alert_location_label': {
        AppLanguage.english: 'Location (Location / KM Marker)',
        AppLanguage.urdu: 'مقام (Location / KM Marker)',
        AppLanguage.punjabi: 'ਸਥਿਤੀ (Location / KM Marker)',
        AppLanguage.chinese: '位置（地点 / 公里标记）',
        AppLanguage.arabic: 'الموقع (Location / KM Marker)',
      },
      'report_alert_type_label': {
        AppLanguage.english: 'Alert Type',
        AppLanguage.urdu: 'Alert Type',
        AppLanguage.punjabi: 'Alert Type',
        AppLanguage.chinese: 'Alert Type',
        AppLanguage.arabic: 'Alert Type',
      },
      'report_alert_cancel': {
        AppLanguage.english: 'Cancel',
        AppLanguage.urdu: 'کینسل',
        AppLanguage.punjabi: 'ਕੈਂਸਲ',
        AppLanguage.chinese: '取消',
        AppLanguage.arabic: 'إلغاء',
      },
      'report_alert_post': {
        AppLanguage.english: 'Post Report',
        AppLanguage.urdu: 'رپورٹ پوسٹ کریں',
        AppLanguage.punjabi: 'ਰਿਪੋਰਟ ਪੋਸਟ ਕਰੋ',
        AppLanguage.chinese: '发布报告',
        AppLanguage.arabic: 'نشر التقرير',
      },
      // Offline payment additional keys
      'offline_payment_no_internet': {
        AppLanguage.english: 'Payments possible without internet or mobile data!',
        AppLanguage.urdu: 'انٹرنیٹ یا موبائل ڈیٹا کے بغیر ادائیگی ممکن ہے!',
        AppLanguage.punjabi: 'ਇੰਟਰਨੈੱਟ ਜਾਂ ਮੋਬਾਈਲ ਡਾਟਾ ਬਿਨਾ ਭੁਗਤਾਨ ਸੰਭਵ ਹੈ!',
        AppLanguage.chinese: '无需互联网或移动数据即可支付！',
        AppLanguage.arabic: 'الدفع متاح بدون إنترنت أو بيانات هاتف!',
      },
      'otc_voucher_header': {
        AppLanguage.english: 'OTC Voucher',
        AppLanguage.urdu: 'OTC واؤچر',
        AppLanguage.punjabi: 'OTC ਵਾਔਚਰ',
        AppLanguage.chinese: 'OTC 代金券',
        AppLanguage.arabic: 'قسيمة OTC',
      },
      'foreigners_guide_title': {
        AppLanguage.english: 'Foreign Tourists Guide',
        AppLanguage.urdu: 'بین الاقوامی سیاحوں کے لیے گائیڈ',
        AppLanguage.punjabi: 'ਵਿਦੇਸ਼ੀ ਸੈਲਾਨੀਆਂ ਲਈ ਗਾਈਡ',
        AppLanguage.chinese: '外国游客指南',
        AppLanguage.arabic: 'دليل السياح الأجانب',
      },
      'road_alert_verified': {
        AppLanguage.english: 'drivers have verified',
        AppLanguage.urdu: 'ڈرائیورز نے تصدیق کی',
        AppLanguage.punjabi: 'ڈرائیورز نے تصدیق کی',
        AppLanguage.chinese: '司机已验证',
        AppLanguage.arabic: 'السائقون قد تحققوا',
      },
    };

    return translations[key]?[lang] ?? translations[key]?[AppLanguage.english] ?? key;
  }
}
