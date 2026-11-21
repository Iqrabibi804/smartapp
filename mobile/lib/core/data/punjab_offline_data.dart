import '../../features/categories/models/category_model.dart';
import '../../features/events/models/event_model.dart';
import '../../features/places/models/place_model.dart';

/// Comprehensive offline fallback data for Punjab places, categories, and events.
/// Enables 100% functionality on physical Android devices when APK is running
/// without an online backend server.
class PunjabOfflineData {
  PunjabOfflineData._();

  static final List<CategoryModel> categories = [
    CategoryModel(id: 'cat-tourist', name: 'Tourist Attractions', icon: 'photo_camera'),
    CategoryModel(id: 'cat-historical', name: 'Historical & Religious', icon: 'mosque'),
    CategoryModel(id: 'cat-hotels', name: 'Hotels', icon: 'hotel'),
    CategoryModel(id: 'cat-restaurants', name: 'Restaurants', icon: 'restaurant'),
    CategoryModel(id: 'cat-bakeries', name: 'Bakeries & Cakes', icon: 'cake'),
    CategoryModel(id: 'cat-hospitals', name: 'Hospitals & Medical', icon: 'local_hospital'),
    CategoryModel(id: 'cat-shopping', name: 'Shopping & Malls', icon: 'shopping_bag'),
    CategoryModel(id: 'cat-parks', name: 'Parks & Nature', icon: 'park'),
  ];

  static final List<PlaceModel> places = [
    // ── SAHIWAL ──
    PlaceModel(
      id: 'pl-sahiwal-butter',
      name: 'Sahiwal Desi Butter & Makhan Center',
      description: 'World-famous authentic Sahiwal Desi Makhan, pure buffalo dairy butter, fresh lassi, and traditional rural milk products direct from Harappa farms.',
      latitude: 30.6682,
      longitude: 73.1114,
      address: 'High Street, Near Old Bus Stand, Sahiwal, Punjab',
      rating: 4.9,
      reviewCount: 420,
      priceRange: 'low',
      verified: true,
      featured: true,
      phone: '+92 40 4221199',
      facilities: ['Pure Desi Makhan', 'Fresh Buffalo Milk', 'Takeaway', 'Home Delivery', 'Chilled Packing'],
      images: [
        'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=1000&q=80',
        'https://images.unsplash.com/photo-1528735602780-2552fd46c7af?auto=format&fit=crop&w=1000&q=80',
      ],
      categoryName: 'Restaurants',
    ),
    PlaceModel(
      id: 'pl-harappa-site',
      name: 'Harappa Archaeological Site & Museum',
      description: '5,000-year-old Indus Valley Civilization UNESCO heritage site with magnificent granary, cemetery, citadel, and archaeological museum.',
      latitude: 30.6300,
      longitude: 72.8650,
      address: 'Harappa Bypass Road, Sahiwal District, Punjab',
      rating: 4.8,
      reviewCount: 1540,
      priceRange: 'low',
      verified: true,
      featured: true,
      phone: '+92 40 9200155',
      facilities: ['Archaeological Museum', 'Guided Tours', 'Family Garden', 'Car Parking', 'Rest Area'],
      images: [
        'https://images.unsplash.com/photo-1564507592333-c60657eea523?auto=format&fit=crop&w=1000&q=80',
        'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?auto=format&fit=crop&w=1000&q=80',
      ],
      categoryName: 'Tourist Attractions',
    ),
    PlaceModel(
      id: 'pl-dhq-sahiwal',
      name: 'DHQ Teaching Hospital Sahiwal',
      description: 'Premier tertiary teaching healthcare institution in Sahiwal division offering 24/7 trauma emergency, cardiology, surgical ICU, and pediatric ward.',
      latitude: 30.6650,
      longitude: 73.1080,
      address: 'College Road, Civil Lines, Sahiwal, Punjab',
      rating: 4.4,
      reviewCount: 890,
      priceRange: 'low',
      verified: true,
      featured: true,
      phone: '+92 40 9200501',
      facilities: ['24/7 Emergency', 'Ambulance 1122', 'Trauma Centre', 'Blood Bank', 'Free Pharmacy'],
      images: [
        'https://images.unsplash.com/photo-1586773860418-d37222d8fce3?auto=format&fit=crop&w=1000&q=80',
      ],
      categoryName: 'Hospitals & Medical',
      paymentMethods: const ['Free Emergency', 'Sehat Sahulat Card', 'NBP / Cash'],
    ),
    PlaceModel(
      id: 'pl-gourmet-sahiwal',
      name: 'Gourmet Bakers & Sweets Sahiwal',
      description: 'Finest birthday cakes, traditional Pakistani sweets, fresh pastries, savories, and family snacks in Sahiwal.',
      latitude: 30.6720,
      longitude: 73.1150,
      address: 'Girls College Road, Sahiwal, Punjab',
      rating: 4.5,
      reviewCount: 650,
      priceRange: 'medium',
      verified: true,
      featured: false,
      phone: '+92 40 4220100',
      facilities: ['Fresh Birthday Cakes', 'Sweets & Halwa', 'Dine-In Area', 'Takeaway'],
      images: [
        'https://images.unsplash.com/photo-1578985545062-69928b1d9587?auto=format&fit=crop&w=1000&q=80',
      ],
      categoryName: 'Bakeries & Cakes',
    ),

    // ── LAHORE ──
    PlaceModel(
      id: 'pl-badshahi-mosque',
      name: 'Badshahi Mosque Lahore',
      description: 'Iconic 1673 Mughal masterpiece in red sandstone with majestic white marble domes overlooking the historic walled city of Lahore.',
      latitude: 31.5881,
      longitude: 74.3096,
      address: 'Walled City, Lahore, Punjab',
      rating: 4.9,
      reviewCount: 8400,
      priceRange: 'low',
      verified: true,
      featured: true,
      phone: '+92 42 99204000',
      facilities: ['Mughal Architecture', 'Wuzu Khana', 'Islamic Relics Gallery', 'Illuminated Night Views'],
      images: [
        'https://images.unsplash.com/photo-1589802829985-817e51171b92?auto=format&fit=crop&w=1000&q=80',
      ],
      categoryName: 'Historical & Religious',
    ),
    PlaceModel(
      id: 'pl-lahore-fort',
      name: 'Lahore Fort (Shahi Qila)',
      description: 'UNESCO World Heritage Mughal stronghold featuring Sheesh Mahal (Palace of Mirrors), Alamgiri Gate, and Diwan-e-Khas.',
      latitude: 31.5880,
      longitude: 74.3150,
      address: 'Fort Road, Walled City, Lahore, Punjab',
      rating: 4.8,
      reviewCount: 6200,
      priceRange: 'low',
      verified: true,
      featured: true,
      facilities: ['Sheesh Mahal', 'Royal Museum', 'Audio Tour', 'Historical Garden'],
      images: [
        'https://images.unsplash.com/photo-1589802829985-817e51171b92?auto=format&fit=crop&w=1000&q=80',
      ],
      categoryName: 'Tourist Attractions',
    ),
    PlaceModel(
      id: 'pl-mayo-hospital',
      name: 'Mayo Hospital Lahore',
      description: 'One of the largest tertiary hospitals in South Asia with comprehensive 24/7 emergency trauma, surgical, and pediatric care.',
      latitude: 31.5728,
      longitude: 74.3168,
      address: 'Hospital Road, Anarkali, Lahore, Punjab',
      rating: 4.4,
      reviewCount: 3100,
      priceRange: 'low',
      verified: true,
      featured: true,
      phone: '+92 42 99211100',
      facilities: ['24/7 Emergency', 'Ambulance 1122', 'Specialist Clinics', 'Trauma Centre', 'Free Pharmacy'],
      images: [
        'https://images.unsplash.com/photo-1586773860418-d37222d8fce3?auto=format&fit=crop&w=1000&q=80',
      ],
      categoryName: 'Hospitals & Medical',
      paymentMethods: const ['Free Emergency', 'Sehat Sahulat Card', 'NBP / Cash'],
    ),
    PlaceModel(
      id: 'pl-butt-karahi',
      name: 'Butt Karahi Food Street Lahore',
      description: 'Legendary Punjabi Desi Ghee Mutton Karahi cooked in fresh butter and secret aromatic spices, famous all across Pakistan.',
      latitude: 31.5772,
      longitude: 74.3125,
      address: 'Lakshmi Chowk, McLeod Road, Lahore, Punjab',
      rating: 4.8,
      reviewCount: 5200,
      priceRange: 'medium',
      verified: true,
      featured: true,
      phone: '+92 42 37248888',
      facilities: ['Desi Ghee Karahi', 'Outdoor Seating', 'AC Hall', 'Valet Parking'],
      images: [
        'https://images.unsplash.com/photo-1544025162-d76694265947?auto=format&fit=crop&w=1000&q=80',
      ],
      categoryName: 'Restaurants',
    ),
    PlaceModel(
      id: 'pl-layers-lahore',
      name: 'Layers Bakeshop Gulberg Lahore',
      description: 'Pakistan’s top trending dessert destination famous for Belgian Malt Cake, Lotus Biscoff cheesecake, and Nutella fudge.',
      latitude: 31.5180,
      longitude: 74.3520,
      address: 'M.M. Alam Road, Gulberg III, Lahore, Punjab',
      rating: 4.9,
      reviewCount: 4600,
      priceRange: 'medium',
      verified: true,
      featured: true,
      phone: '+92 42 111529377',
      facilities: ['Viral Cakes', 'Takeaway', 'Home Delivery', 'AC Boutique'],
      images: [
        'https://images.unsplash.com/photo-1578985545062-69928b1d9587?auto=format&fit=crop&w=1000&q=80',
      ],
      categoryName: 'Bakeries & Cakes',
    ),

    // ── ISLAMABAD ──
    PlaceModel(
      id: 'pl-faisal-mosque',
      name: 'Faisal Mosque Islamabad',
      description: 'World-famous iconic national mosque nestled at the foot of Margalla Hills with sleek contemporary architecture designed by Vedat Dalokay.',
      latitude: 33.7297,
      longitude: 73.0372,
      address: 'Shah Faisal Avenue, Sector E-8, Islamabad',
      rating: 4.9,
      reviewCount: 11200,
      priceRange: 'low',
      verified: true,
      featured: true,
      facilities: ['Margalla Mountain View', 'Vast Courtyard', 'Islamic Library', 'Ample Parking'],
      images: [
        'https://images.unsplash.com/photo-1605649487212-47bdab064df7?auto=format&fit=crop&w=1000&q=80',
      ],
      categoryName: 'Historical & Religious',
    ),
    PlaceModel(
      id: 'pl-monal-restaurant',
      name: 'The Monal Restaurant Margalla Hills',
      description: 'Hilltop fine-dining terrace situated at 3,900 feet with panoramic views of the entire capital city and exquisite Pakistani BBQ.',
      latitude: 33.7667,
      longitude: 73.0652,
      address: 'Pir Sohawa Road, Margalla Hills, Islamabad',
      rating: 4.9,
      reviewCount: 7800,
      priceRange: 'high',
      verified: true,
      featured: true,
      phone: '+92 51 5837204',
      facilities: ['Panoramic Capital View', 'Outdoor Seating', 'Live BBQ', 'Family Dining', 'Valet Parking'],
      images: [
        'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=1000&q=80',
      ],
      categoryName: 'Restaurants',
    ),
    PlaceModel(
      id: 'pl-shifa-hospital',
      name: 'Shifa International Hospital Islamabad',
      description: 'JCI-accredited premier private tertiary medical complex providing 24/7 cardiac ICU, organ transplants, and emergency response.',
      latitude: 33.6844,
      longitude: 73.0768,
      address: 'Pitras Bukhari Road, Sector H-8/4, Islamabad',
      rating: 4.8,
      reviewCount: 3120,
      priceRange: 'high',
      verified: true,
      featured: true,
      phone: '+92 51 8463000',
      facilities: ['24/7 Emergency', 'Heart Centre', 'Organ Transplant', 'Pharmacy', 'Private Rooms'],
      images: [
        'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?auto=format&fit=crop&w=1000&q=80',
      ],
      categoryName: 'Hospitals & Medical',
      paymentMethods: const ['Cash', 'Debit / Credit Card', 'Sehat Sahulat Card', 'Insurance Direct'],
    ),
    PlaceModel(
      id: 'pl-savour-islamabad',
      name: 'Savour Foods Blue Area Islamabad',
      description: 'Pakistan’s celebrated pulao house serving aromatic basmati pulao, shami kababs, crispy roasted chicken, and mint raita.',
      latitude: 33.7145,
      longitude: 73.0844,
      address: 'Fortune Plaza, Blue Area, Islamabad',
      rating: 4.7,
      reviewCount: 5600,
      priceRange: 'low',
      verified: true,
      featured: true,
      phone: '+92 51 2348255',
      facilities: ['Iconic Pulao', 'Fast Service', 'Family Seating', 'Takeaway'],
      images: [
        'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?auto=format&fit=crop&w=1000&q=80',
      ],
      categoryName: 'Restaurants',
    ),

    // ── RAWALPINDI ──
    PlaceModel(
      id: 'pl-holy-family-pindi',
      name: 'Holy Family Hospital Rawalpindi',
      description: 'Premier 1,000-bed government hospital with 24/7 emergency trauma, mother & child healthcare, and advanced surgical care.',
      latitude: 33.6268,
      longitude: 73.0721,
      address: 'Holy Family Road, Satellite Town, Rawalpindi, Punjab',
      rating: 4.3,
      reviewCount: 2400,
      priceRange: 'low',
      verified: true,
      featured: true,
      phone: '+92 51 9290321',
      facilities: ['24/7 Emergency', 'Pediatric ICU', 'Rescue 1122 Bay', 'Laboratory'],
      images: [
        'https://images.unsplash.com/photo-1586773860418-d37222d8fce3?auto=format&fit=crop&w=1000&q=80',
      ],
      categoryName: 'Hospitals & Medical',
      paymentMethods: const ['Free Emergency', 'Sehat Sahulat Card', 'NBP / Cash'],
    ),
    PlaceModel(
      id: 'pl-tehzeeb-bakers',
      name: 'Tehzeeb Bakers Saddar Rawalpindi',
      description: 'Historic heritage bakery renowned for signature Pineapple Cake, fresh chicken pizza, cheese patties, and dry fruit cookies.',
      latitude: 33.5970,
      longitude: 73.0520,
      address: 'Bank Road, Saddar Cantt, Rawalpindi, Punjab',
      rating: 4.8,
      reviewCount: 4800,
      priceRange: 'medium',
      verified: true,
      featured: true,
      phone: '+92 51 111112253',
      facilities: ['Pineapple Pastry', 'Fresh Italian Pizza', 'Gourmet Biscuits', 'Custom Cakes'],
      images: [
        'https://images.unsplash.com/photo-1578985545062-69928b1d9587?auto=format&fit=crop&w=1000&q=80',
      ],
      categoryName: 'Bakeries & Cakes',
    ),

    // ── FAISALABAD ──
    PlaceModel(
      id: 'pl-clock-tower-faisalabad',
      name: 'Clock Tower (Ghanta Ghar) Faisalabad',
      description: 'British-era architectural marvel built in the shape of the Union Jack connecting eight bustling bazaars in central Faisalabad.',
      latitude: 31.4187,
      longitude: 73.0791,
      address: 'Ghanta Ghar Chowk, Faisalabad, Punjab',
      rating: 4.7,
      reviewCount: 3900,
      priceRange: 'low',
      verified: true,
      featured: true,
      facilities: ['Historic Bazaars', 'Textile Shopping', 'Street Food', 'Walking Tours'],
      images: [
        'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?auto=format&fit=crop&w=1000&q=80',
      ],
      categoryName: 'Tourist Attractions',
    ),
    PlaceModel(
      id: 'pl-allied-hospital',
      name: 'Allied Hospital Faisalabad',
      description: 'Largest 1,500-bed government hospital in central Punjab providing 24/7 trauma emergency, burn centre, and cardiac ICU.',
      latitude: 31.4350,
      longitude: 73.0690,
      address: 'Jail Road, Faisalabad, Punjab',
      rating: 4.3,
      reviewCount: 2200,
      priceRange: 'low',
      verified: true,
      featured: true,
      phone: '+92 41 9210080',
      facilities: ['24/7 Emergency', 'Burn Centre', 'Cardiac ICU', 'Pathology Lab'],
      images: [
        'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?auto=format&fit=crop&w=1000&q=80',
      ],
      categoryName: 'Hospitals & Medical',
      paymentMethods: const ['Free Emergency', 'Sehat Sahulat Card', 'NBP / Cash'],
    ),

    // ── MULTAN ──
    PlaceModel(
      id: 'pl-rukn-e-alam',
      name: 'Tomb of Shah Rukn-e-Alam Multan',
      description: 'Magnificent 14th-century octagonal Sufi shrine crowned with an enormous dome and decorated with brilliant blue Kashigari tiles.',
      latitude: 30.1984,
      longitude: 71.4687,
      address: 'Qasim Fort, Multan, Punjab',
      rating: 4.9,
      reviewCount: 6100,
      priceRange: 'low',
      verified: true,
      featured: true,
      facilities: ['Blue Tile Architecture', 'Sufi Heritage', 'Fort Hilltop View', 'Handicraft Bazaars'],
      images: [
        'https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?auto=format&fit=crop&w=1000&q=80',
      ],
      categoryName: 'Historical & Religious',
    ),
    PlaceModel(
      id: 'pl-rewari-sohan-halwa',
      name: 'Rewari Sweets & Multani Sohan Halwa',
      description: 'Original Multani Sohan Halwa made with pure desi ghee, almond, walnut, and pistachio, renowned across the subcontinent.',
      latitude: 30.1950,
      longitude: 71.4720,
      address: 'Hussain Agahi Bazaar, Multan, Punjab',
      rating: 4.8,
      reviewCount: 3400,
      priceRange: 'medium',
      verified: true,
      featured: true,
      phone: '+92 61 4543210',
      facilities: ['Desi Ghee Sohan Halwa', 'Gift Packing', 'Shipping Available'],
      images: [
        'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=1000&q=80',
      ],
      categoryName: 'Bakeries & Cakes',
    ),

    // ── MURREE ──
    PlaceModel(
      id: 'pl-mall-road-murree',
      name: 'Mall Road Murree',
      description: 'Iconic pedestrian mountain boulevard lined with pine trees, hillside cafes, Kashmiri handicraft stalls, and cool breeze.',
      latitude: 33.9070,
      longitude: 73.3900,
      address: 'The Mall, Murree, Punjab',
      rating: 4.7,
      reviewCount: 9500,
      priceRange: 'medium',
      verified: true,
      featured: true,
      facilities: ['Mountain Vistas', 'Snow Carnival', 'Local Cafes', 'Handicrafts'],
      images: [
        'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=1000&q=80',
      ],
      categoryName: 'Tourist Attractions',
    ),
    PlaceModel(
      id: 'pl-patriata-chairlift',
      name: 'Patriata Chairlift & Cable Car',
      description: 'Thrilling two-stage chairlift and modern gondola cable car gliding over high pine canopy at New Murree’s highest ridge.',
      latitude: 33.8700,
      longitude: 73.4500,
      address: 'Patriata, New Murree, Punjab',
      rating: 4.8,
      reviewCount: 5100,
      priceRange: 'medium',
      verified: true,
      featured: true,
      facilities: ['Cable Car', 'Alpine Vistas', 'Horse Riding', 'Viewing Terraces'],
      images: [
        'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=1000&q=80',
      ],
      categoryName: 'Parks & Nature',
    ),

    // ── BAHAWALPUR ──
    PlaceModel(
      id: 'pl-derawar-fort',
      name: 'Derawar Fort & Cholistan Desert',
      description: 'Towering 9th-century desert fortress with 40 colossal bastions visible for miles across the golden Cholistan sands.',
      latitude: 28.7670,
      longitude: 71.3340,
      address: 'Cholistan Desert, Bahawalpur District, Punjab',
      rating: 4.8,
      reviewCount: 2900,
      priceRange: 'low',
      verified: true,
      featured: true,
      facilities: ['Desert Safari', 'Jeep Rally Track', 'Night Stargazing', 'Abbasi Royal Mosque'],
      images: [
        'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?auto=format&fit=crop&w=1000&q=80',
      ],
      categoryName: 'Tourist Attractions',
    ),
    PlaceModel(
      id: 'pl-noor-mahal',
      name: 'Noor Mahal Bahawalpur',
      description: 'Exquisite 1872 Italian neoclassical palace built by the Nawab of Bahawalpur with Corinthian pillars, crystal chandeliers, and lush lawns.',
      latitude: 29.3870,
      longitude: 71.6830,
      address: 'Noor Mahal Road, Bahawalpur, Punjab',
      rating: 4.9,
      reviewCount: 4200,
      priceRange: 'low',
      verified: true,
      featured: true,
      facilities: ['Night Light & Sound Show', 'Royal Artifacts', 'Coffee Shop', 'Lush Lawns'],
      images: [
        'https://images.unsplash.com/photo-1564507592333-c60657eea523?auto=format&fit=crop&w=1000&q=80',
      ],
      categoryName: 'Historical & Religious',
    ),

    // ── SHEIKHUPURA ──
    PlaceModel(
      id: 'pl-waris-shah',
      name: 'Waris Shah Shrine (Jandiala Sher Khan)',
      description: 'Sacred resting place of immortal Punjabi Sufi poet Syed Waris Shah, legendary author of Heer Ranjha. Revered cultural and literary landmark in Jandiala Sher Khan.',
      latitude: 31.8150,
      longitude: 73.9180,
      address: 'Jandiala Sher Khan, Sheikhupura District, Punjab',
      rating: 4.8,
      reviewCount: 3800,
      priceRange: 'free',
      verified: true,
      featured: true,
      phone: '+92 56 3781200',
      facilities: ['Sufi Poetry Sessions', 'Wuzu Khana', 'Langar Khana', 'Historical Well', 'Car Parking'],
      images: [
        'https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?auto=format&fit=crop&w=1000&q=80',
        'https://images.unsplash.com/photo-1589802829985-817e51171b92?auto=format&fit=crop&w=1000&q=80',
      ],
      categoryName: 'Historical & Religious',
      paymentMethods: const ['Free Entry', 'Cash (Donations)'],
      isFemaleSafe: true,
      isFamilyFriendly: true,
      localPrice: 0,
      touristPrice: 0,
      audioGuideUrdu: 'یہ مزار عظیم صوفی بزرگ شاعر سید وارث شاہ رحمتہ اللہ علیہ کا ہے جنہوں نے ہیر رانجھا لکھی۔',
    ),
    PlaceModel(
      id: 'pl-hiran-minar',
      name: 'Hiran Minar Water Pavilion & Forest',
      description: 'Iconic 110-foot Mughal tower and tranquil water pavilion built by Emperor Jahangir in memory of his beloved royal deer Mansraj.',
      latitude: 31.7450,
      longitude: 73.9530,
      address: 'Hiran Minar Road, Sheikhupura, Punjab',
      rating: 4.7,
      reviewCount: 5100,
      priceRange: 'low',
      verified: true,
      featured: true,
      facilities: ['Boating in Water Tank', 'Deer Sanctuary', 'Royal Pavilion', 'Picnic Garden'],
      images: [
        'https://images.unsplash.com/photo-1588668214407-6ea9a6d8c272?auto=format&fit=crop&w=1000&q=80',
      ],
      categoryName: 'Tourist Attractions',
      paymentMethods: const ['Cash', 'Easypaisa'],
      isFemaleSafe: true,
      isFamilyFriendly: true,
      localPrice: 50,
      touristPrice: 200,
    ),
    PlaceModel(
      id: 'pl-sheikhupura-fort',
      name: 'Sheikhupura Fort (Qila Sheikhupura)',
      description: 'Historical Mughal fortress constructed in 1607 during Emperor Jahangir’s reign, later reinforced by Maharaja Ranjit Singh.',
      latitude: 31.7130,
      longitude: 73.9850,
      address: 'Old City, Sheikhupura, Punjab',
      rating: 4.5,
      reviewCount: 1950,
      priceRange: 'low',
      verified: true,
      featured: false,
      facilities: ['Mughal Architecture', 'Historic Ramparts', 'Photography Zone'],
      images: [
        'https://images.unsplash.com/photo-1564507592333-c60657eea523?auto=format&fit=crop&w=1000&q=80',
      ],
      categoryName: 'Historical & Religious',
      paymentMethods: const ['Cash'],
      isFemaleSafe: true,
      isFamilyFriendly: true,
    ),
    PlaceModel(
      id: 'pl-dhq-sheikhupura',
      name: 'DHQ Hospital Sheikhupura',
      description: 'Leading 500-bed government tertiary hospital offering 24/7 emergency trauma care, pediatrics, ICU, and surgical wards in Sheikhupura.',
      latitude: 31.7160,
      longitude: 73.9780,
      address: 'Civil Lines Road, Sheikhupura, Punjab',
      rating: 4.3,
      reviewCount: 1100,
      priceRange: 'free',
      verified: true,
      featured: true,
      phone: '+92 56 9200215',
      facilities: ['24/7 Emergency', 'Ambulance 1122', 'Trauma Centre', 'Free Pharmacy'],
      images: [
        'https://images.unsplash.com/photo-1586773860418-d37222d8fce3?auto=format&fit=crop&w=1000&q=80',
      ],
      categoryName: 'Hospitals & Medical',
      paymentMethods: const ['Free Emergency', 'Sehat Sahulat Card', 'NBP / Cash'],
      isFemaleSafe: true,
      isFamilyFriendly: true,
    ),
  ];

  static final List<EventModel> events = [
    EventModel(
      id: 'ev-cholistan-rally',
      name: 'Cholistan Desert Jeep Rally 2026',
      description: 'Pakistan’s biggest motorsport championship featuring 400+ kilometers of desert speed racing, cultural music, and camel caravans at Derawar Fort.',
      latitude: 28.7670,
      longitude: 71.3340,
      address: 'Derawar Fort, Cholistan Desert, Bahawalpur',
      date: DateTime.now().add(const Duration(days: 14)),
      startTime: '08:00 AM',
      endTime: '08:00 PM',
      organizer: 'Tourism Development Corporation of Punjab (TDCP)',
      ticketInfo: 'Free Public Spectator Zones',
      image: 'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?auto=format&fit=crop&w=1000&q=80',
    ),
    EventModel(
      id: 'ev-lahore-spring',
      name: 'Lahore Spring Floral & Horse Show',
      description: 'Annual heritage festival showcasing Punjabi tent pegging, championship horse and cattle exhibitions, flower beds, and Sufi folk music.',
      latitude: 31.5450,
      longitude: 74.3400,
      address: 'Jilani Park (Race Course), Jail Road, Lahore',
      date: DateTime.now().add(const Duration(days: 21)),
      startTime: '09:00 AM',
      endTime: '10:00 PM',
      organizer: 'Parks and Horticulture Authority (PHA) Punjab',
      ticketInfo: 'Rs. 100 General Entry',
      image: 'https://images.unsplash.com/photo-1589802829985-817e51171b92?auto=format&fit=crop&w=1000&q=80',
    ),
    EventModel(
      id: 'ev-harappa-mela',
      name: 'Harappa Archeological & Heritage Mela',
      description: 'Celebration of the 5,000-year Indus Valley heritage with folk puppet theatre, pottery workshops, traditional lassi & butter stalls, and scholar tours.',
      latitude: 30.6300,
      longitude: 72.8650,
      address: 'Archaeological Complex, Harappa, Sahiwal',
      date: DateTime.now().add(const Duration(days: 28)),
      startTime: '10:00 AM',
      endTime: '06:00 PM',
      organizer: 'Punjab Directorate of Archaeology & TDCP',
      ticketInfo: 'Free Entry',
      image: 'https://images.unsplash.com/photo-1564507592333-c60657eea523?auto=format&fit=crop&w=1000&q=80',
    ),
  ];

  /// Filter places in-memory with intelligent keyword, city, and category matching
  static List<PlaceModel> filterPlaces({
    String? query,
    String? categoryId,
    String? categoryName,
    String? city,
    double? minRating,
    String? sort,
  }) {
    return places.where((place) {
      if (city != null && city.isNotEmpty && city.toLowerCase() != 'all cities') {
        final matchesCity = place.address.toLowerCase().contains(city.toLowerCase()) ||
            place.name.toLowerCase().contains(city.toLowerCase()) ||
            place.description.toLowerCase().contains(city.toLowerCase());
        if (!matchesCity) return false;
      }

      if (categoryName != null && categoryName.isNotEmpty) {
        final normCat = categoryName.toLowerCase().trim();
        final matchesCat = place.categoryName?.toLowerCase().contains(normCat) == true ||
            normCat.contains(place.categoryName?.toLowerCase() ?? '') ||
            (normCat.contains('hospital') && (place.categoryName?.contains('Hospital') == true || place.name.contains('Hospital'))) ||
            (normCat.contains('cake') && (place.categoryName?.contains('Bake') == true || place.name.contains('Baker'))) ||
            (normCat.contains('food') && (place.categoryName?.contains('Restaur') == true));
        if (!matchesCat) return false;
      }

      if (query != null && query.trim().isNotEmpty) {
        final q = query.toLowerCase().trim();
        final cleanWords = q.replaceAll(RegExp(r'[(),.-]'), ' ').split(RegExp(r'\s+')).where((w) => w.length > 2).toList();
        final matchesQ = place.name.toLowerCase().contains(q) ||
            place.description.toLowerCase().contains(q) ||
            place.address.toLowerCase().contains(q) ||
            (place.categoryName?.toLowerCase().contains(q) ?? false) ||
            place.facilities.any((f) => f.toLowerCase().contains(q)) ||
            (cleanWords.isNotEmpty && cleanWords.any((w) => place.name.toLowerCase().contains(w) || place.address.toLowerCase().contains(w)));
        if (!matchesQ) return false;
      }

      if (minRating != null && place.rating < minRating) {
        return false;
      }

      return true;
    }).toList();
  }
}
