import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/services/api_client.dart';
import '../services/trips_service.dart';
import 'trip_details_screen.dart';
import 'my_trips_screen.dart';

class TripPlannerScreen extends ConsumerStatefulWidget {
  const TripPlannerScreen({super.key});

  @override
  ConsumerState<TripPlannerScreen> createState() => _TripPlannerScreenState();
}

class _TripPlannerScreenState extends ConsumerState<TripPlannerScreen> {
  String _origin = 'Lahore';
  String _destination = 'Islamabad';
  final TextEditingController _customDestinationController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController(text: '25000');

  int _days = 2;
  int _travelers = 2;
  String _travelMode = 'car'; // 'car', 'bus', 'train'
  final Set<String> _selectedInterests = {'food', 'history', 'nature'};
  bool _generating = false;

  static const _popularCities = [
    'Lahore',
    'Islamabad',
    'Rawalpindi',
    'Murree',
    'Multan',
    'Faisalabad',
    'Bahawalpur',
    'Taxila',
    'Sialkot',
  ];

  static const _popularRoutes = [
    (
      'Lahore ➔ Islamabad / Murree',
      'Lahore',
      'Islamabad',
      '375 km (4h 15m via M-2 Motorway)',
      'Scenic Salt Range, Bhera sweets, Monal dinner',
    ),
    (
      'Lahore ➔ Multan / Bahawalpur',
      'Lahore',
      'Multan',
      '340 km (3h 50m via M-3 Motorway)',
      'Shah Rukn-e-Alam Shrine, Sohan Halwa, Derawar Fort',
    ),
    (
      'Rawalpindi ➔ Taxila & Abbottabad',
      'Rawalpindi',
      'Taxila',
      '45 km (50m via N-35 GT Road)',
      'UNESCO World Heritage Buddhist ruins, Taxila Museum',
    ),
    (
      'Faisalabad ➔ Lahore Heritage',
      'Faisalabad',
      'Lahore',
      '180 km (2h 15m via M-4/M-2)',
      'Badshahi Mosque, Shahi Qila, Anarkali Shopping',
    ),
  ];

  static const _interestOptions = [
    ('food', 'Famous Food & Dining', 'لذیذ کھانا اور فوڈ سٹریٹ', Icons.restaurant_menu),
    ('history', 'Historical Forts & Shrines', 'تاریخی قلعے اور مزارات', Icons.account_balance),
    ('nature', 'Parks, Lakes & Nature', 'پہاڑ، پارکس اور جھیلیں', Icons.landscape),
    ('shopping', 'Traditional Bazaars', 'شاپنگ اور روایتی مارکیٹ', Icons.shopping_bag),
    ('religious', 'Spiritual & Mosques', 'مقدس مساجد اور روحانی مقامات', Icons.mosque),
  ];

  @override
  void initState() {
    super.initState();
    _customDestinationController.text = _destination;
  }

  @override
  void dispose() {
    _customDestinationController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  Future<void> _makeCall(String number) async {
    final uri = Uri.parse('tel:$number');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    } catch (_) {}
  }

  Map<String, dynamic> _getRouteEstimates() {
    final orig = _origin.toLowerCase();
    final dest = _destination.toLowerCase();

    if ((orig.contains('lahore') && dest.contains('islamabad')) ||
        (orig.contains('islamabad') && dest.contains('lahore'))) {
      return {
        'route': 'M-2 Motorway (6 Lanes Superhighway)',
        'distance': '375 km',
        'time': '4 hrs 15 mins',
        'fuelEst': 'Rs. 9,500 - 12,000 (Petrol / Toll Rs. 1,100)',
        'busEst': 'Rs. 2,200 - 2,800 / seat (Daewoo / Faisal Movers)',
        'trainEst': 'Rs. 3,200 (Green Line AC Business)',
        'stops': [
          ('Sukheke Service Area (KM 85)', 'Petrol, McDonald\'s, Restrooms, Mosque'),
          ('Bhera Service Area (KM 220)', 'Famous Bhera Sweets, KFC, Family Dining'),
          ('Kallar Kahar Viewpoint (KM 290)', 'Salt Range Scenic Valley & Peacock Lake'),
        ],
      };
    } else if ((orig.contains('lahore') && dest.contains('multan')) ||
        (orig.contains('multan') && dest.contains('lahore'))) {
      return {
        'route': 'M-3 Motorway (Lahore - Abdul Hakeem)',
        'distance': '340 km',
        'time': '3 hrs 50 mins',
        'fuelEst': 'Rs. 8,500 - 10,500 (Toll Rs. 950)',
        'busEst': 'Rs. 1,900 - 2,400 / seat',
        'trainEst': 'Rs. 2,800 (Musa Pak Express)',
        'stops': [
          ('Samundri Interchange (KM 110)', 'Fuel & Snacks Rest Area'),
          ('Abdul Hakeem Junction (KM 230)', 'Dhaba Tea & Highway Service'),
          ('Multan Cantt Entrance', 'City Guide & Hotel Connection'),
        ],
      };
    } else {
      return {
        'route': 'Punjab Highway & Motorway Link',
        'distance': 'Approx 150 - 300 km',
        'time': '2 to 3.5 hrs',
        'fuelEst': 'Rs. 5,000 - 8,000',
        'busEst': 'Rs. 1,200 - 1,800 / seat',
        'trainEst': 'Rs. 1,500 - 2,200',
        'stops': [
          ('Highway Rest Area', 'Clean Washrooms & Refreshments'),
          ('Midway Toll Plaza', 'Motorway Police Help Desk'),
        ],
      };
    }
  }

  Future<void> _generateTrip() async {
    final destination = _destination.trim().isNotEmpty
        ? _destination.trim()
        : _customDestinationController.text.trim();

    if (destination.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select or enter your destination.')),
      );
      return;
    }

    setState(() => _generating = true);
    try {
      final trip = await ref.read(tripsServiceProvider).create(
        destination: destination,
        days: _days,
        travelers: _travelers,
        budget: double.tryParse(_budgetController.text) ?? 25000,
        interests: _selectedInterests.toList(),
      );

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => TripDetailsScreen(trip: trip)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(friendlyErrorMessage(e))),
      );
    } finally {
      if (mounted) setState(() => _generating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final routeInfo = _getRouteEstimates();
    final stops = routeInfo['stops'] as List<(String, String)>;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Smart Route & Trip Planner', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text('روٹ پلانر اور محفوظ سفر گائیڈ', style: TextStyle(fontSize: 11, color: Color(0xFF34D399))),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.white),
            tooltip: 'My Trips (محفوظ ٹرپس)',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const MyTripsScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        children: [
          // ── 1. Layman Visual Guide / Benefit Card ──
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF065F46), Color(0xFF047857)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF047857).withValues(alpha: 0.3),
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
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.map_outlined, color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'یہ پلانر آپ کے سفر کو کیسے آسان بنائے گا؟',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          Text(
                            'Smart Route Guide for Tourists & Travelers',
                            style: TextStyle(color: Colors.white70, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(color: Colors.white24, height: 1),
                const SizedBox(height: 12),
                _buildLaymanBenefit(
                  icon: Icons.directions_car_filled_outlined,
                  urdu: 'راستہ اور فاصلہ: کتنا ٹائم اور پیٹرول خرچ ہوگا',
                  eng: 'Exact highway route, time, tolls and fuel estimate',
                ),
                const SizedBox(height: 8),
                _buildLaymanBenefit(
                  icon: Icons.local_gas_station_outlined,
                  urdu: 'راستے کے بہترین ریسٹ ایریاز اور فیملی ہوٹلز',
                  eng: 'Best highway rest stops, clean washrooms & dining',
                ),
                const SizedBox(height: 8),
                _buildLaymanBenefit(
                  icon: Icons.security_outlined,
                  urdu: 'موٹروے پولیس ہیلپ لائن 130 کی فوری سہولت',
                  eng: 'Direct 1-tap call to Motorway Police 130 & Rescue 1122',
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ── 2. Popular 1-Tap Preset Routes ──
          const Row(
            children: [
              Icon(Icons.flash_on, color: Color(0xFFD97706), size: 18),
              SizedBox(width: 6),
              Text(
                'Popular Route Presets (مقبول ترین روٹس)',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 94,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _popularRoutes.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, i) {
                final r = _popularRoutes[i];
                final isSelected = _origin == r.$2 && _destination == r.$3;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _origin = r.$2;
                      _destination = r.$3;
                      _customDestinationController.text = r.$3;
                    });
                  },
                  child: Container(
                    width: 250,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFECFDF5) : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected ? const Color(0xFF059669) : const Color(0xFFE2E8F0),
                        width: isSelected ? 1.8 : 1.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Icon(
                              isSelected ? Icons.check_circle : Icons.alt_route,
                              size: 16,
                              color: isSelected ? const Color(0xFF059669) : const Color(0xFF64748B),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                r.$1,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: isSelected ? const Color(0xFF065F46) : const Color(0xFF1E293B),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          r.$4,
                          style: const TextStyle(fontSize: 10, color: Color(0xFF059669), fontWeight: FontWeight.w600),
                          maxLines: 1,
                        ),
                        Text(
                          r.$5,
                          style: const TextStyle(fontSize: 9, color: Color(0xFF64748B)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          // ── 3. Origin & Destination Selector Card ──
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select Journey Locations (کہاں سے کہاں جانا ہے)',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A)),
                ),
                const SizedBox(height: 14),

                // From (Origin)
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF059669).withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.my_location, color: Color(0xFF059669), size: 18),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Starting City (کہاں سے شروع کریں گے)',
                              style: TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                          DropdownButton<String>(
                            isExpanded: true,
                            value: _origin,
                            underline: const SizedBox(),
                            icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF059669)),
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A), fontSize: 15),
                            items: _popularCities.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => _origin = val);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const Divider(height: 20, color: Color(0xFFF1F5F9)),

                // To (Destination)
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDC2626).withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.location_on, color: Color(0xFFDC2626), size: 18),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Destination City (منزل مقصود)',
                              style: TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                          DropdownButton<String>(
                            isExpanded: true,
                            value: _popularCities.contains(_destination) ? _destination : _popularCities.first,
                            underline: const SizedBox(),
                            icon: const Icon(Icons.arrow_drop_down, color: Color(0xFFDC2626)),
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A), fontSize: 15),
                            items: _popularCities.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() {
                                  _destination = val;
                                  _customDestinationController.text = val;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── 4. Mode of Transport (سواری کا انتخاب) ──
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Mode of Transport (سواری کا انتخاب)',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A)),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _buildTransportChip(
                      id: 'car',
                      label: 'Personal Car / Cab',
                      urdu: 'کار / ٹیکسی',
                      icon: Icons.directions_car,
                    ),
                    const SizedBox(width: 8),
                    _buildTransportChip(
                      id: 'bus',
                      label: 'Luxury Bus',
                      urdu: 'ڈائیوو / فیصل موورز',
                      icon: Icons.directions_bus,
                    ),
                    const SizedBox(width: 8),
                    _buildTransportChip(
                      id: 'train',
                      label: 'Express Train',
                      urdu: 'گرین لائن ٹرین',
                      icon: Icons.train,
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── 5. Live Highway Route & Rest Stop Card ──
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(Icons.alt_route, color: Color(0xFF34D399), size: 18),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Route: ${routeInfo['route']}',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${routeInfo['distance']} • ${routeInfo['time']}',
                        style: const TextStyle(color: Color(0xFF34D399), fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(color: Colors.white12, height: 1),
                const SizedBox(height: 10),

                // Cost summary according to selected mode
                Row(
                  children: [
                    const Icon(Icons.payments_outlined, color: Color(0xFFFBBF24), size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _travelMode == 'car'
                            ? 'Estimated Fuel & Toll: ${routeInfo['fuelEst']}'
                            : _travelMode == 'bus'
                                ? 'Estimated Bus Fare: ${routeInfo['busEst']}'
                                : 'Estimated Train Fare: ${routeInfo['trainEst']}',
                        style: const TextStyle(color: Color(0xFFFDE68A), fontSize: 11, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                const Text(
                  'Recommended Rest Stops (راستے میں آرام کی بہترین جگہیں):',
                  style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...stops.map((s) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.place, color: Color(0xFF34D399), size: 14),
                          const SizedBox(width: 6),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                text: '${s.$1}: ',
                                style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                children: [
                                  TextSpan(
                                    text: s.$2,
                                    style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),

                const SizedBox(height: 10),
                const Divider(color: Colors.white12, height: 1),
                const SizedBox(height: 8),

                // Motorway Police Helpline button
                Row(
                  children: [
                    const Expanded(
                      child: Row(
                        children: [
                          Icon(Icons.shield_outlined, color: Color(0xFFF87171), size: 16),
                          SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Highway Emergency Help (ایمرجنسی)',
                              style: TextStyle(color: Colors.white, fontSize: 11),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    ElevatedButton.icon(
                      onPressed: () => _makeCall('130'),
                      icon: const Icon(Icons.call, size: 13),
                      label: const Text('Call 130 (موٹروے پولیس)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFDC2626),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── 🚧 FEATURE 3: Offline + Live Road Status & Landslide by Locals ──
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF2F2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF87171).withValues(alpha: 0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFFDC2626),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 18),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'لائیو روڈ اسٹیٹس و لینڈ سلائیڈنگ الرٹ',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF991B1B)),
                          ),
                          Text(
                            'Waze-style offline road status marked by local drivers',
                            style: TextStyle(fontSize: 11, color: Color(0xFFB91C1C)),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text('All Clear 🟢', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'اگر سگنل غائب بھی ہوں، یہ ڈیٹا آپ کے موبائل میں محفوظ رہتا ہے: "کلر کہار سالٹ رینج روڈ کھلی ہے • مری مال روڈ پر برف باری کے دوران سنو چینز لازمی ہیں"',
                  style: TextStyle(fontSize: 12, color: Color(0xFF7F1D1D), height: 1.4),
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFDC2626),
                    side: const BorderSide(color: Color(0xFFDC2626)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    minimumSize: const Size(double.infinity, 36),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('شکریہ! آپ کی روڈ اسٹیٹس رپورٹ مقامی مسافروں کو بھیج دی گئی ہے۔'),
                        backgroundColor: Color(0xFF0F172A),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add_location_alt_outlined, size: 16),
                  label: const Text('1-Click: راستے کی بندش یا لینڈ سلائیڈ رپورٹ کریں', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── 🚐 FEATURE 5: Local Vans Ka Route (Connect Remote Heritage) ──
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF16A34A).withValues(alpha: 0.4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFF16A34A),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.airport_shuttle, color: Colors.white, size: 18),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'لوکل ویگن و چنگچی روٹس گائیڈ',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF166534)),
                          ),
                          Text(
                            'No direct bus? Here are step-by-step local van connections',
                            style: TextStyle(fontSize: 11, color: Color(0xFF15803D)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _vanHop('لاہور ➔ کلر کہار:', 'سٹی بس / کوسٹر اڈہ (کرایہ: Rs. 600 - 800)'),
                      const Divider(height: 10),
                      _vanHop('کلر کہار ➔ کٹاس راج مندر:', 'لوکل چنگچی رکشہ اڈہ (کرایہ: Rs. 100 - 150)'),
                      const Divider(height: 10),
                      _vanHop('راولپنڈی ➔ روہتاس فورٹ:', 'دینا چوک وین (Rs. 250) + دینہ سے قلعہ بولان (Rs. 80)'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── 6. Days, Travelers & Budget ──
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Trip Duration & Companions (دن اور مسافر)',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A))),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Days
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Days (کتنے دن)', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            IconButton.filledTonal(
                              onPressed: _days > 1 ? () => setState(() => _days--) : null,
                              icon: const Icon(Icons.remove, size: 16),
                              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text('$_days ${_days == 1 ? 'Day' : 'Days'}',
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                            ),
                            IconButton.filledTonal(
                              onPressed: _days < 10 ? () => setState(() => _days++) : null,
                              icon: const Icon(Icons.add, size: 16),
                              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Travelers
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Travelers (مسافر)', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            IconButton.filledTonal(
                              onPressed: _travelers > 1 ? () => setState(() => _travelers--) : null,
                              icon: const Icon(Icons.remove, size: 16),
                              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text('$_travelers Person',
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                            ),
                            IconButton.filledTonal(
                              onPressed: () => setState(() => _travelers++),
                              icon: const Icon(Icons.add, size: 16),
                              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 14),
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                const SizedBox(height: 12),

                // Budget
                const Text('Estimated Budget (کل متوقع بجٹ - PKR)',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                const SizedBox(height: 6),
                TextField(
                  controller: _budgetController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixText: 'Rs. ',
                    hintText: 'e.g. 25000',
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── 7. Interests Selector (آپ کو کیا پسند ہے) ──
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'What would you like to explore? (آپ کی ترجیحات)',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A)),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _interestOptions.map((opt) {
                    final isSelected = _selectedInterests.contains(opt.$1);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            if (_selectedInterests.length > 1) _selectedInterests.remove(opt.$1);
                          } else {
                            _selectedInterests.add(opt.$1);
                          }
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF059669) : const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? const Color(0xFF059669) : const Color(0xFFCBD5E1),
                            width: isSelected ? 1.5 : 1.0,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(opt.$4, size: 16, color: isSelected ? Colors.white : const Color(0xFF475569)),
                            const SizedBox(width: 6),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  opt.$2,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                    color: isSelected ? Colors.white : const Color(0xFF1E293B),
                                  ),
                                ),
                                Text(
                                  opt.$3,
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: isSelected ? Colors.white70 : const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ── 8. Big Action Button ──
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: _generating ? null : _generateTrip,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF059669),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 4,
                shadowColor: const Color(0xFF059669).withValues(alpha: 0.4),
              ),
              child: _generating
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        ),
                        SizedBox(width: 12),
                        Text('Designing Your Route Plan...', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      ],
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.auto_awesome, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Generate Smart Route & Itinerary ✨',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 8),
          const Center(
            child: Text(
              'مکمل سمارٹ روٹ، ٹورسٹ سپاٹس اور ہوٹلز کی لسٹ خودکار تیار ہوگی',
              style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildLaymanBenefit({required IconData icon, required String urdu, required String eng}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF6EE7B7), size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(urdu, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
              Text(eng, style: const TextStyle(color: Colors.white70, fontSize: 10)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTransportChip({
    required String id,
    required String label,
    required String urdu,
    required IconData icon,
  }) {
    final isSelected = _travelMode == id;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _travelMode = id),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? const Color(0xFF0F172A) : const Color(0xFFCBD5E1),
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          child: Column(
            children: [
              Icon(icon, size: 20, color: isSelected ? const Color(0xFF34D399) : const Color(0xFF64748B)),
              const SizedBox(height: 4),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  color: isSelected ? Colors.white : const Color(0xFF1E293B),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                urdu,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 8,
                  color: isSelected ? Colors.white70 : const Color(0xFF64748B),
                ),
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _vanHop(String hop, String detail) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.arrow_right_alt, color: Color(0xFF16A34A), size: 16),
        const SizedBox(width: 4),
        Expanded(
          child: RichText(
            text: TextSpan(
              text: '$hop ',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF166534)),
              children: [
                TextSpan(
                  text: detail,
                  style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black87),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
