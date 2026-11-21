class CityInfo {
  final String id;
  final String name;
  final String urduName;
  final String tagline;
  final String summary;
  final String coverImage;
  final List<String> galleryImages;
  final List<String> knownFor;
  final String bestTimeToVisit;
  final String weatherNote;
  final List<String> signatureDishes;
  final CabServices cabServices;

  const CityInfo({
    required this.id,
    required this.name,
    required this.urduName,
    required this.tagline,
    required this.summary,
    required this.coverImage,
    required this.galleryImages,
    required this.knownFor,
    required this.bestTimeToVisit,
    required this.weatherNote,
    required this.signatureDishes,
    required this.cabServices,
  });
}

class CabServices {
  final bool hasIndrive;
  final bool hasCareem;
  final bool hasYango;
  final String localCabHelpline;
  final String notes;

  const CabServices({
    this.hasIndrive = true,
    this.hasCareem = true,
    this.hasYango = true,
    this.localCabHelpline = '',
    this.notes = 'Ride-hailing apps available 24/7',
  });
}

class PunjabCitiesData {
  static const List<CityInfo> cities = [
    CityInfo(
      id: 'islamabad',
      name: 'Islamabad',
      urduName: 'اسلام آباد',
      tagline: 'The Scenic Modern Capital',
      summary:
          'Nestled at the foothills of the lush Margalla Hills, Islamabad is Pakistan’s serene, master-planned capital. Renowned for wide boulevards, tranquil hiking trails, iconic modernist architecture, and world-class hilltop dining.',
      coverImage:
          'https://images.unsplash.com/photo-1605649487212-47bdab064df7?auto=format&fit=crop&w=1200&q=80',
      galleryImages: [
        'https://images.unsplash.com/photo-1605649487212-47bdab064df7?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1584551246679-0daf3d275d0f?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=800&q=80',
      ],
      knownFor: [
        'Faisal Mosque',
        'Margalla Hills Trails 3 & 5',
        'Monal Mountain Dining',
        'Daman-e-Koh Viewpoint',
        'Saidpur Heritage Village',
      ],
      bestTimeToVisit: 'October to April (Pleasant & Cool)',
      weatherNote: 'Mild winters, green monsoons, scenic hill breezes',
      signatureDishes: [
        'Monal Live Mutton Chops',
        'Savour Crispy Pulao',
        'Kabul Afghan Kebabs',
        'Layers Lotus Biscoff Cake',
      ],
      cabServices: CabServices(
        hasIndrive: true,
        hasCareem: true,
        hasYango: true,
        localCabHelpline: '051-111-222-333',
        notes: 'InDrive, Careem & Yango arrive in 3-5 mins anywhere in Islamabad.',
      ),
    ),
    CityInfo(
      id: 'lahore',
      name: 'Lahore',
      urduName: 'لاہور',
      tagline: 'The Cultural & Culinary Heart',
      summary:
          '"Whoever hasn’t seen Lahore hasn’t been born!" Lahore is Punjab’s historic crown, home to UNESCO World Heritage Mughal architecture, bustling 24/7 food streets, exquisite gardens, and legendary Punjabi hospitality.',
      coverImage:
          'https://images.unsplash.com/photo-1589802829985-817e51171b92?auto=format&fit=crop&w=1200&q=80',
      galleryImages: [
        'https://images.unsplash.com/photo-1589802829985-817e51171b92?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1622547748225-3fc4abd2cca0?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?auto=format&fit=crop&w=800&q=80',
      ],
      knownFor: [
        'Badshahi Mosque',
        'Lahore Fort & Sheesh Mahal',
        'Fort Road Food Street',
        'Shalimar Gardens',
        'Wazir Khan Mosque',
        'Anarkali & Liberty Bazaars',
      ],
      bestTimeToVisit: 'November to March (Festive season & pleasant weather)',
      weatherNote: 'Crisp pleasant winters; lively festive evenings',
      signatureDishes: [
        'Desi Ghee Butt Karahi',
        'Bundu Khan Seekh Kebabs',
        'Phajja Siri Paye',
        'Jalal Sons Chocolate Fudge Cake',
      ],
      cabServices: CabServices(
        hasIndrive: true,
        hasCareem: true,
        hasYango: true,
        localCabHelpline: '042-111-222-111',
        notes: 'InDrive, Yango & Careem are abundant. Metro Bus & Orange Line Train are also available.',
      ),
    ),
    CityInfo(
      id: 'murree',
      name: 'Murree Hills',
      urduName: 'مری',
      tagline: 'The Queen of Hills & Snow',
      summary:
          'Perched at an elevation of 7,500 feet in the Pir Panjal range, Murree is Pakistan’s premier mountain resort. Famous for pine-covered ridges, winter snowfalls, chairlifts at Patriata, and the iconic Mall Road.',
      coverImage:
          'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=1200&q=80',
      galleryImages: [
        'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=800&q=80',
      ],
      knownFor: [
        'Mall Road Strolls',
        'Patriata (New Murree) Cable Car',
        'Bhurban Luxury Resorts',
        'Pindi Point & Kashmir Point',
        'Ayubia National Park Pipeline Track',
      ],
      bestTimeToVisit: 'December to February (Snowfall) & May to August (Cool summer escape)',
      weatherNote: 'Cool summers (18°C) and snowy winters (-3°C)',
      signatureDishes: [
        'Hot Kashmiri Chai & Roasted Corn',
        'Patriata Fried Trout',
        'Hilltop Desi Karahi',
        'Fresh Fruit Tarts',
      ],
      cabServices: CabServices(
        hasIndrive: true,
        hasCareem: false,
        hasYango: false,
        localCabHelpline: '051-341-0022 (Tourist Police Cab)',
        notes: 'InDrive operates from Islamabad to Murree. Local jeeps and 4x4 cabs are stationed along Mall Road.',
      ),
    ),
    CityInfo(
      id: 'rawalpindi',
      name: 'Rawalpindi',
      urduName: 'راولپنڈی',
      tagline: 'Historic Bazaars & Military Heritage',
      summary:
          'The historic sister city to Islamabad, Rawalpindi boasts centuries of heritage, British cantonment architecture, vibrant spice markets at Raja Bazaar, and world-class street food traditions.',
      coverImage:
          'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?auto=format&fit=crop&w=1200&q=80',
      galleryImages: [
        'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?auto=format&fit=crop&w=800&q=80',
      ],
      knownFor: [
        'Ayub National Park',
        'Historic Raja Bazaar',
        'Rawalpindi Cantt Saddar',
        'Rawal Lake Promenade',
        'Army Heritage Museum',
      ],
      bestTimeToVisit: 'October to April',
      weatherNote: 'Brisk pleasant autumns and mild winters',
      signatureDishes: [
        'Original Savour Pulao',
        'Tehzeeb Pineapple Cream Cake',
        'Mei Kong Szechuan Chinese',
        'Cheezious Crown Crust Pizza',
      ],
      cabServices: CabServices(
        hasIndrive: true,
        hasCareem: true,
        hasYango: true,
        localCabHelpline: '051-111-222-333',
        notes: 'Instant cab and bike services on InDrive, Careem & Yango.',
      ),
    ),
    CityInfo(
      id: 'chakwal',
      name: 'Chakwal & Kallar Kahar',
      urduName: 'چکوال اور کلر کہار',
      tagline: 'Ancient Sacred Temples & Blue Lakes',
      summary:
          'Rich in archaeological wonder and natural beauty, Chakwal district features the sacred Hindu Katas Raj Temples dating back millennia, the saltwater Kallar Kahar Lake with peacocks, and lush orchards.',
      coverImage:
          'https://images.unsplash.com/photo-1548013146-72479768bada?auto=format&fit=crop&w=1200&q=80',
      galleryImages: [
        'https://images.unsplash.com/photo-1548013146-72479768bada?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=800&q=80',
      ],
      knownFor: [
        'Katas Raj Historic Temples',
        'Kallar Kahar Lake & Boating Pier',
        'Bagh-e-Safa (Mughal Emperor Babur Orchard)',
        'Neela Wahn Natural Spring Waterfalls',
        'Chakwal Pehlwan Rewari',
      ],
      bestTimeToVisit: 'October to March (Ideal for temple walking and lake visits)',
      weatherNote: 'Pleasant spring and cool winter season',
      signatureDishes: [
        'Chakwal Desi Pehlwan Rewari',
        'Kallar Kahar Fried River Fish',
        'Royal Tonite Mutton Handi',
        'Gourmet Fresh Cream Cakes',
      ],
      cabServices: CabServices(
        hasIndrive: false,
        hasCareem: false,
        hasYango: false,
        localCabHelpline: '0543-551122 (Chakwal Tourist Transport)',
        notes: 'Local rental cars, tourist hiaces, and rickshaws available near Ayub Chowk and Motorway M-2 interchange.',
      ),
    ),
    CityInfo(
      id: 'attock',
      name: 'Attock',
      urduName: 'اٹک',
      tagline: 'Where the Indus Meets the Kabul River',
      summary:
          'A dramatic gateway between Punjab and Khyber Pakhtunkhwa, Attock is situated at the mighty confluence of the Indus and Kabul rivers. Renowned for Akbar the Great’s Attock Fort and scenic riverside dining.',
      coverImage:
          'https://images.unsplash.com/photo-1544025162-d76694265947?auto=format&fit=crop&w=1200&q=80',
      galleryImages: [
        'https://images.unsplash.com/photo-1544025162-d76694265947?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=800&q=80',
      ],
      knownFor: [
        'Attock Khurd Confluence of Rivers',
        'Akbar’s Historical Attock Fort',
        'Old Victorian Railway Iron Bridge',
        'Indus Dolphin Sightings',
        'Riverside Fresh Fish Pavilions',
      ],
      bestTimeToVisit: 'November to March',
      weatherNote: 'Fresh breezes along the riverbanks, crisp autumns',
      signatureDishes: [
        'Fresh Indus River Mahseer Fish',
        'Mezban Shinwari Karahi',
        'Traditional Afghani Naan',
        'Gourmet Civil Bazar Cakes',
      ],
      cabServices: CabServices(
        hasIndrive: true,
        hasCareem: false,
        hasYango: false,
        localCabHelpline: '057-2611456 (Attock Taxi Union)',
        notes: 'InDrive operates within city limits. Local taxis connect directly to GT Road and Motorway M-1.',
      ),
    ),
  ];

  static CityInfo getById(String id) {
    return cities.firstWhere(
      (c) => c.id.toLowerCase() == id.toLowerCase(),
      orElse: () => cities.first,
    );
  }
}
