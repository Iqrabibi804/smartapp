/// Reference road advisories for major tourist corridors.
///
/// These entries are compiled from public seasonal-travel guidance. They are
/// NOT a live feed: no NHA, NHMP, PDMA or NDMA status API is connected. Every
/// entry therefore reports [RoadStatus.unavailable] and carries its source and
/// compilation date so the app never presents stale guidance as current.
enum RoadStatus { open, closed, restricted, landslideReported, weatherWarning, unavailable }

extension RoadStatusLabel on RoadStatus {
  String get label {
    switch (this) {
      case RoadStatus.open:
        return 'Open (reported)';
      case RoadStatus.closed:
        return 'Closed (reported)';
      case RoadStatus.restricted:
        return 'Restricted';
      case RoadStatus.landslideReported:
        return 'Landslide reported';
      case RoadStatus.weatherWarning:
        return 'Weather warning';
      case RoadStatus.unavailable:
        return 'Information unavailable';
    }
  }
}

class RoadAdvisory {
  final String id;
  final String corridor;
  final String segment;
  final RoadStatus status;
  final String seasonalGuidance;
  final String alternativeRoute;
  final String sourceAgency;
  final String sourceUrl;
  final String referenceDate;

  const RoadAdvisory({
    required this.id,
    required this.corridor,
    required this.segment,
    required this.status,
    required this.seasonalGuidance,
    required this.alternativeRoute,
    required this.sourceAgency,
    required this.sourceUrl,
    required this.referenceDate,
  });
}

/// All statuses are [RoadStatus.unavailable] by design until an authorised
/// official status feed exists. Do not change a status to Open/Closed from
/// unverified information.
const List<RoadAdvisory> kRoadAdvisories = [
  RoadAdvisory(
    id: 'kkh-n35',
    corridor: 'Karakoram Highway (N-35)',
    segment: 'Hasan Abdal – Gilgit – Khunjerab',
    status: RoadStatus.unavailable,
    seasonalGuidance:
        'Open year-round in principle, but landslides, rockfall and snow can close sections in Kohistan and Hunza with little warning. Carriageway width and surface condition vary by section.',
    alternativeRoute:
        'No comparable all-weather alternative. For landslide closures, wait for NHA clearance or ask at the nearest NHMP post before detouring.',
    sourceAgency: 'NHA / NHMP (reference only)',
    sourceUrl: 'https://nha.gov.pk',
    referenceDate: '2026-11-21',
  ),
  RoadAdvisory(
    id: 'babusar',
    corridor: 'Babusar Top Pass',
    segment: 'Naran – Babusar – Chilas',
    status: RoadStatus.unavailable,
    seasonalGuidance:
        'A high mountain pass (about 4,173 m). Historically impassable under snow and typically treated as a summer route only; exact opening and closing dates change every year with weather.',
    alternativeRoute:
        'The year-round route between Kaghan and Gilgit is the Karakoram Highway via Besham and Kohistan. Confirm both routes with NHA/NHMP before leaving.',
    sourceAgency: 'NHA / GB administration (reference only)',
    sourceUrl: 'https://nha.gov.pk',
    referenceDate: '2026-11-21',
  ),
  RoadAdvisory(
    id: 'lowari',
    corridor: 'Lowari Tunnel (N-45)',
    segment: 'Dir – Lowari Tunnel – Chitral',
    status: RoadStatus.unavailable,
    seasonalGuidance:
        'The tunnel reduces, but does not remove, winter isolation for Chitral. Approach roads on both sides can still close after heavy snow, and tunnel operating hours can change.',
    alternativeRoute:
        'The historical Lowari Pass road is weather-dependent and normally not a winter alternative. Ask local administration before relying on any detour.',
    sourceAgency: 'NHA / KP C&W (reference only)',
    sourceUrl: 'https://nha.gov.pk',
    referenceDate: '2026-11-21',
  ),
  RoadAdvisory(
    id: 'khunjerab',
    corridor: 'Khunjerab Pass (N-35)',
    segment: 'Sost – Khunjerab – Pakistan–China border',
    status: RoadStatus.unavailable,
    seasonalGuidance:
        'The highest paved international border crossing in the world. Snow and border formalities can close or restrict the pass; schedules are set by authorities and change seasonally.',
    alternativeRoute:
        'No alternative road crossing. Plan around confirmed opening information from official border authorities.',
    sourceAgency: 'NHA / border authorities (reference only)',
    sourceUrl: 'https://nha.gov.pk',
    referenceDate: '2026-11-21',
  ),
  RoadAdvisory(
    id: 'naran-kaghan',
    corridor: 'Naran – Kaghan (N-15)',
    segment: 'Balakot – Naran – Lake Saif-ul-Muluk track',
    status: RoadStatus.unavailable,
    seasonalGuidance:
        'The main valley road is prone to monsoon landslides and winter snow. The Lake Saif-ul-Muluk access track is rough and is normally served by local 4x4 jeeps rather than private cars.',
    alternativeRoute:
        'When the valley road is blocked, there is usually no quick detour; wait for clearance or postpone. Do not attempt unmapped side tracks.',
    sourceAgency: 'NHA / district administration (reference only)',
    sourceUrl: 'https://nha.gov.pk',
    referenceDate: '2026-11-21',
  ),
  RoadAdvisory(
    id: 'murree-expressway',
    corridor: 'Islamabad–Murree Expressway',
    segment: 'Islamabad – Murree – Nathia Gali',
    status: RoadStatus.unavailable,
    seasonalGuidance:
        'Busy leisure corridor. Fog, ice and snow cause frequent winter delays and occasional road closures; summer weekends bring heavy congestion.',
    alternativeRoute:
        'The old Murree Road via Rawalpindi is slower and also weather-affected. Check NHMP traffic updates before choosing a route.',
    sourceAgency: 'NHMP / NHA (reference only)',
    sourceUrl: 'https://nhmp.gov.pk',
    referenceDate: '2026-11-21',
  ),
  RoadAdvisory(
    id: 'skardu-road',
    corridor: 'Jaglot – Skardu Road (S-1)',
    segment: 'Jaglot – Astore turn-off – Skardu',
    status: RoadStatus.unavailable,
    seasonalGuidance:
        'Follows the Indus gorge with rockfall and landslide exposure. Sections can be single-lane, and winter snow affects the higher stretches.',
    alternativeRoute:
        'The alternative via Astore and Deosai is seasonal and not a dependable substitute in winter. Confirm conditions locally.',
    sourceAgency: 'NHA / GB administration (reference only)',
    sourceUrl: 'https://nha.gov.pk',
    referenceDate: '2026-11-21',
  ),
];
