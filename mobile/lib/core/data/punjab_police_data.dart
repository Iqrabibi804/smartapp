/// Police directory snapshot from the user-supplied workbook (research dated 23 Nov 2026).
/// Islamabad: 27 stations across 5 zones. Lahore: 84 stations and 10 police posts.
/// Source: INCPak directories, updated March 2026. This is not an official or live feed.

String? _optional(String value) => value.isEmpty ? null : value;

class PoliceDirectoryEntry {
  const PoliceDirectoryEntry({
    required this.city,
    required this.name,
    required this.type,
    this.zone,
    this.division,
    this.divisionPhone,
    this.circle,
    this.phone,
    this.supervisorPhone,
    this.location,
    this.areas,
  });

  final String city;
  final String name;
  final String type;
  final String? zone;
  final String? division;
  final String? divisionPhone;
  final String? circle;
  final String? phone;
  final String? supervisorPhone;
  final String? location;
  final String? areas;

  String get source => city == 'Islamabad'
      ? 'INCPak Islamabad directory · updated Mar 2026'
      : 'INCPak Lahore directory · updated Mar 2026';

  factory PoliceDirectoryEntry.fromRow(String row) {
    final c = row.split('|');
    return PoliceDirectoryEntry(
      city: c[0],
      zone: _optional(c[1]),
      division: _optional(c[2]),
      divisionPhone: _optional(c[3]),
      circle: _optional(c[4]),
      name: c[5],
      type: c[6],
      phone: _optional(c[7]),
      supervisorPhone: _optional(c[8]),
      location: _optional(c[9]),
      areas: _optional(c[10]),
    );
  }
}

class PoliceAreaCoverage {
  const PoliceAreaCoverage({
    required this.area,
    required this.station,
    required this.zone,
    this.phone,
  });

  final String area;
  final String station;
  final String zone;
  final String? phone;

  factory PoliceAreaCoverage.fromRow(String row) {
    final c = row.split('|');
    return PoliceAreaCoverage(
      area: c[0],
      station: c[1],
      zone: c[2],
      phone: _optional(c[3]),
    );
  }
}

const String _policeRows = r'''
Islamabad|City Zone||||Aabpara|Police Station|051-9204830||Aabpara (Melody, near Poly Clinic)|G-6, G-7, Shakar Parrian, Sports Complex
Islamabad|City Zone||||Karachi Company|Police Station|051-9334091||G-9 Markaz|G-8, G-9
Islamabad|City Zone||||Kohsar|Police Station|051-9102499||F-7 Markaz|F-6, F-7, E-7, Blue Area, Saidpur
Islamabad|City Zone||||Margalla|Police Station|051-9261510||F-8 Markaz|F-8, F-9, E-8, E-9, Faisal Mosque
Islamabad|City Zone||||Secretariat|Police Station|051-9209132||G-5 Markaz|F-5, G-5, Bari Imam, QAU, Lake View
Islamabad|City Zone||||Women PS|Police Station|051-9252517||G-7 Markaz|Whole Islamabad (women's police station)
Islamabad|Saddar Zone||||Golra Sharif|Police Station|051-9267099||Golra Sharif Village|D-12, G-13, G-14, G-15, Golra Village
Islamabad|Saddar Zone||||Ramna|Police Station|051-9330189||G-11|G-10, G-11, G-12, Dhoke Kashmirian
Islamabad|Saddar Zone||||Sangjani|Police Station||||Tarnol, Sangjani, Sectors C-15 to D-17
Islamabad|Saddar Zone||||Shalimar|Police Station|051-9266885||F-10/2|F-10, F-11, D-10, D-11, E-11
Islamabad|Saddar Zone||||Sumbal|Police Station|||G-13 Markaz|F-12 to F-14, G-12 to G-14
Islamabad|Saddar Zone||||Tarnol|Police Station|051-2295122||GT Road|B-17, E-16, G-16, Tarnol
Islamabad|Industrial Area Zone||||Industrial Area I-9|Police Station|051-9258877||Industrial Area I-9|I-8, I-9, H-8, H-9, Faizabad
Islamabad|Industrial Area Zone||||Noon|Police Station|||I-16 Markaz|I-14 to I-16, Noon Village
Islamabad|Industrial Area Zone||||Sabzi Mandi|Police Station|051-9334840||Sector I-10|I-10, I-11, Sabzi Mandi, H-10
Islamabad|Industrial Area Zone||||Shams Colony|Police Station|051-9334499|||H-11 to H-13, Shams Colony, IJP Road
Islamabad|Rural Zone||||Bani Gala|Police Station|051-9255339||Park Road, Shehzad Town|Bani Gala, Kuri, Bahria Enclave
Islamabad|Rural Zone||||Bhara Kahu|Police Station|051-2230029||Simli Road|Bhara Kahu, Mandla, Sangjali
Islamabad|Rural Zone||||Nilore|Police Station|||Nilore|Nilore, Tumair, Sihali
Islamabad|Rural Zone||||Phulgran|Police Station||||Atthal, Phulgran, PTV Colony (Dawn 2022 also: Bobri, Chattar, Sakreela, Mera Begwal, Shahpur)
Islamabad|Rural Zone||||Shahzad Town|Police Station|051-9247444||Shahzad Town|Shahzad Town, Rawat, Tarlai
Islamabad|Soan Zone||||Humak|Police Station|||DHA Phase II, T-Chowk|Humak, DHA-2, Zaraj, Niazian
Islamabad|Soan Zone||||Khanna|Police Station|051-4473600||Khanna Pul, Expressway|Khanna, Shakrial, Sohan, Barma Town
Islamabad|Soan Zone||||Kirpa|Police Station||||Kirpa, Gulberg, Pindori, Sihala
Islamabad|Soan Zone||||Koral|Police Station|051-9252517||Koral Chowk|Koral, Ghauri Town, Pind Daian
Islamabad|Soan Zone||||Lohi Bher|Police Station|051-5710906||CBR Town|Bahria Town, Lohi Bher, Media Town
Islamabad|Soan Zone||||Sihala|Police Station|051-4491334||Kahuta Road, Kak Pull|Sihala, DHA Phases, Morgah
Lahore||Cantt Division|042-99220615|Defence Area Circle|Defence Area (A)|Police Station|042-35727470|042-35728462||
Lahore||Cantt Division|042-99220615|Defence Area Circle|Defence Area (B)|Police Station|042-35892014|042-35728462||
Lahore||Cantt Division|042-99220615|Defence Area Circle|Defence Area (C)|Police Station|0308-7773255|042-35728462||
Lahore||Cantt Division|042-99220615|Defence Area Circle|Factory Area|Police Station|042-35810498|042-35728462||
Lahore||Cantt Division|042-99220615|Sarwar Road Circle|Sarwar Road|Police Station|042-99220611|042-99220577||
Lahore||Cantt Division|042-99220615|Sarwar Road Circle|Police Post Air Port|Police Post|042-99240426|042-99220577||
Lahore||Cantt Division|042-99220615|Sarwar Road Circle|South Cantt|Police Station|042-99220616|042-99220577||
Lahore||Cantt Division|042-99220615|North Cantt Circle|North Cantt|Police Station|042-99220602, 042-99221040|042-99220148||
Lahore||Cantt Division|042-99220615|North Cantt Circle|Police Post Guldisht Town|Police Post|042-36117936|042-99220148||
Lahore||Cantt Division|042-99220615|North Cantt Circle|Mustafa Abad|Police Station|042-99239682|042-99220148||
Lahore||Cantt Division|042-99220615|North Cantt Circle|Ghazi Abad|Police Station|042-36636439|042-99220148||
Lahore||Cantt Division|042-99220615|Barki Circle|Barki|Police Station|042-36560200|042-36561153||
Lahore||Cantt Division|042-99220615|Barki Circle|Hair|Police Station|042-35600522|042-36561153||
Lahore||Cantt Division|042-99220615|Barki Circle|Hadiara|Police Station|042-36560308|042-36561153||
Lahore||Cantt Division|042-99220615|Barki Circle|Police Post Minhala|Police Post|042-36591200|042-36561153||
Lahore||Cantt Division|042-99220615|Baghbanpura Circle|Baghbanpura|Police Station|042-36816919|042-99239577||
Lahore||Cantt Division|042-99220615|Baghbanpura Circle|Harbance Pura|Police Station|042-36544501|042-99239577||
Lahore||Cantt Division|042-99220615|Manawan Circle|Manawan|Police Station|042-36523137|042-36523136||
Lahore||Cantt Division|042-99220615|Manawan Circle|Bata Pur|Police Station|042-36581161|042-36523136||
Lahore||Cantt Division|042-99220615|Manawan Circle|Police Post Wahga|Police Post|042-99239415|042-36523136||
Lahore||City Division|042-99213433|Islampura Circle|Islampura|Police Station|042-37156796|042-99211988||
Lahore||City Division|042-99213433|Islampura Circle|New Anarkali|Police Station|042-99239623|042-99211988||
Lahore||City Division|042-99213433|Lower Mall Circle|Lower Mall|Police Station|042-99213479|042-99213481||
Lahore||City Division|042-99213433|Lower Mall Circle|Data Darbar|Police Station|042-37116558|042-99213481||
Lahore||City Division|042-99213433|Lower Mall Circle|Bhatti Gate|Police Station|042-37662793|042-99213481||
Lahore||City Division|042-99213433|Tibbi City Circle|Tibbi City|Police Station|042-37662768|042-37662768||
Lahore||City Division|042-99213433|Tibbi City Circle|Masti Gate|Police Station|042-99239651|042-37662768||
Lahore||City Division|042-99213433|Tibbi City Circle|Yakki Gate|Police Station|042-99239624|042-37662768||
Lahore||City Division|042-99213433|Rang Mehal Circle|Rang Mehal|Police Station|042-37661022|042-37668355||
Lahore||City Division|042-99213433|Rang Mehal Circle|Lohari Gate|Police Station|042-99239656|042-37668355||
Lahore||City Division|042-99213433|Naulakha Circle|Naulakha|Police Station|042-37630016|042-37662965||
Lahore||City Division|042-99213433|Naulakha Circle|Akbari Gate|Police Station|042-37636703|042-37662965||
Lahore||City Division|042-99213433|Gowalmandi Circle|Gowalmandi|Police Station|042-99239626|042-37235010||
Lahore||City Division|042-99213433|Gowalmandi Circle|Mochi Gate|Police Station|042-37653473|042-37235010||
Lahore||City Division|042-99213433|Shahdara Circle|Shahdara|Police Station|042-37920365|042-37929344||
Lahore||City Division|042-99213433|Shahdara Circle|Shahdara Town|Police Station|042-37944141|042-37929344||
Lahore||City Division|042-99213433|Shafiq Abad Circle|Shafiq Abad|Police Station|042-99239686|042-99239686||
Lahore||City Division|042-99213433|Shafiq Abad Circle|Ravi Road|Police Station|042-99239628|042-99239686||
Lahore||City Division|042-99213433|Badamibagh Circle|Badamibagh|Police Station|042-37281500|042-99239646||
Lahore||City Division|042-99213433|Badamibagh Circle|Lorry Adda|Police Station|042-99239629|042-99239646||
Lahore||City Division|042-99213433|Missri Shah Circle|Missri Shah|Police Station|042-36278444|042-37612988||
Lahore||City Division|042-99213433|Missri Shah Circle|Shadbagh|Police Station|042-37281045|042-37612988||
Lahore||Civil Lines Division|042-99200780|Race Course Circle|Race Course|Police Station|042-99200300|042-99200780||
Lahore||Civil Lines Division|042-99200780|Race Course Circle|Civil Lines|Police Station|042-99200561|042-99200780||
Lahore||Civil Lines Division|042-99200780|Qila Gujjar Singh Circle|Qila Gujjar Singh|Police Station|042-99201909|042-99201300||
Lahore||Civil Lines Division|042-99200780|Qila Gujjar Singh Circle|Garhi Shahu|Police Station|042-36304635|042-99201300||
Lahore||Civil Lines Division|042-99200780|Old Anarkali Circle|Old Anarkali|Police Station|042-99211911|042-99211916||
Lahore||Civil Lines Division|042-99200780|Old Anarkali Circle|Lytton Road|Police Station|042-37310423|042-99211916||
Lahore||Civil Lines Division|042-99200780|Old Anarkali Circle|Mozang|Police Station|042-37320565|042-99211916||
Lahore||Civil Lines Division|042-99200780|Mughalpura Circle|Shalimar|Police Station|042-36813200|042-99250068||
Lahore||Civil Lines Division|042-99200780|Mughalpura Circle|Gujjar Pura|Police Station|042-36880300|042-99250068||
Lahore||Civil Lines Division|042-99200780|Mughalpura Circle|Mughalpura|Police Station|042-99250071|042-99250068||
Lahore||Civil Lines Division|042-99200780|Women Police Station Circle|Women Police Station Race Course|Police Station|042-99200278|042-99204171||
Lahore||Iqbal Town Division|042-99230659|Muslim Town Circle|Muslim Town|Police Station|042-99230278|042-37553171||
Lahore||Iqbal Town Division|042-99230659|Muslim Town Circle|Wahdat Colony|Police Station|042-37588906|042-37553171||
Lahore||Iqbal Town Division|042-99230659|Samanabad Circle|Samanabad|Police Station|042-37580607|042-37584866||
Lahore||Iqbal Town Division|042-99230659|Samanabad Circle|Millat Park|Police Station|042-37584310|042-37584866||
Lahore||Iqbal Town Division|042-99230659|Iqbal Town Circle|Iqbal Town|Police Station|042-37800512|042-37803905||
Lahore||Iqbal Town Division|042-99230659|Iqbal Town Circle|Gulshan Iqbal|Police Station|042-35422828|042-37803905||
Lahore||Iqbal Town Division|042-99230659|Gulshan-e-Ravi Circle|Gulshan-e-Ravi|Police Station|042-37411524|042-37401799||
Lahore||Iqbal Town Division|042-99230659|Gulshan-e-Ravi Circle|Sanda|Police Station|042-37411112|042-37401799||
Lahore||Iqbal Town Division|042-99230659|Nawankot Circle|Nawan Kot|Police Station|042-37416397|042-37402008||
Lahore||Iqbal Town Division|042-99230659|Nawankot Circle|Shera Kot|Police Station|042-37412111|042-37402008||
Lahore||Model Town Division|042-99263421|Model Town Circle|Model Town|Police Station|042-99230232|042-99230468||
Lahore||Model Town Division|042-99263421|Model Town Circle|Liaqat Abad|Police Station|042-99230306|042-99230468||
Lahore||Model Town Division|042-99263421|Model Town Circle|Naseerabad|Police Station|042-99238631|042-99230468||
Lahore||Model Town Division|042-99263421|Model Town Circle|Police Post Firdous Market|Police Post|042-99230205|042-99230468||
Lahore||Model Town Division|042-99263421|Garden Town Circle|Garden Town|Police Station|042-99230279|042-35912488||
Lahore||Model Town Division|042-99263421|Garden Town Circle|Police Post Raja Market|Police Post|042-35831880|042-35912488||
Lahore||Model Town Division|042-99263421|Garden Town Circle|Faisal Town|Police Station|042-35166331|042-35912488||
Lahore||Model Town Division|042-99263421|Ichhra Circle|Ichhra|Police Station|042-37581419|042-37575408||
Lahore||Model Town Division|042-99263421|Ichhra Circle|Shadman|Police Station|042-37589936|042-37575408||
Lahore||Model Town Division|042-99263421|Gulberg Circle|Gulberg|Police Station|042-99263149|042-99263150||
Lahore||Model Town Division|042-99263421|Gulberg Circle|Ghalib Market|Police Station|042-99263148|042-99263150||
Lahore||Model Town Division|042-99263421|Gulberg Circle|Police Post Main Market|Police Post|042-99263197|042-99263150||
Lahore||Model Town Division|042-99263421|Kahna Circle|Kahna|Police Station|042-99239930|042-35810505||
Lahore||Model Town Division|042-99263421|Kahna Circle|Police Post Sua Assal|Police Post|042-35935127|042-35810505||
Lahore||Model Town Division|042-99263421|Kahna Circle|Kot Lakhpat|Police Station|042-35800312|042-35810505||
Lahore||Model Town Division|042-99263421|Kahna Circle|Police Post Rakh Chandrai|Police Post|042-35803420|042-35810505||
Lahore||Model Town Division|042-99263421|Kahna Circle|Nishter Colony|Police Station|042-35959220|042-35810505||
Lahore||Saddar Division|042-99262023|Raiwind City Circle|Raiwind City|Police Station|042-99238025|042-37540111||
Lahore||Saddar Division|042-99262023|Raiwind City Circle|Police Post Jia Bagga|Police Post|042-99238445|042-37540111||
Lahore||Saddar Division|042-99262023|Raiwind City Circle|Manga Mandi|Police Station|042-35383029|042-37540111||
Lahore||Saddar Division|042-99262023|Raiwind City Circle|Sundar|Police Station|042-99238364|042-37540111||
Lahore||Saddar Division|042-99262023|Chung Circle|Chung|Police Station|042-37511165|042-37513946||
Lahore||Saddar Division|042-99262023|Chung Circle|Nawab Town|Police Station|042-99237041|042-37513946||
Lahore||Saddar Division|042-99262023|Chung Circle|Satto Katla|Police Station|042-35187706|042-37513946||
Lahore||Saddar Division|042-99262023|Sabzazar Circle|Sabzazar|Police Station|042-37832380|042-37821300||
Lahore||Saddar Division|042-99262023|Sabzazar Circle|Mustafa Town|Police Station|042-37079188|042-37821300||
Lahore||Saddar Division|042-99262023|Sabzazar Circle|Hanjarwal|Police Station|042-35410061|042-37821300||
Lahore||Saddar Division|042-99262023|Town Ship Circle|Town Ship|Police Station|042-35124478|042-35217797||
Lahore||Saddar Division|042-99262023|Town Ship Circle|Johar Town|Police Station|042-99231472|042-35217797||
Lahore||Saddar Division|042-99262023|Town Ship Circle|Green Town|Police Station|042-35118000|042-35217797||
Lahore||Saddar Division|042-99262023|Town Ship Circle|Quaid-e-Azam Industrial Estate|Police Station|042-35215747|042-35217797||
''';

const String _areaRows = r'''
Atthal|Phulgran PS|Rural Zone|
B-17|Tarnol PS|Saddar Zone|051-2295122
Bahria Enclave|Bani Gala PS|Rural Zone|051-9255339
Bahria Town|Lohi Bher PS|Soan Zone|051-5710906
Bani Gala|Bani Gala PS|Rural Zone|051-9255339
Bari Imam|Secretariat PS|City Zone|051-9209132
Barma Town|Khanna PS|Soan Zone|051-4473600
Bhara Kahu|Bhara Kahu PS|Rural Zone|051-2230029
Blue Area|Kohsar PS|City Zone|051-9102499
Bobri|Phulgran PS|Rural Zone|
Chattar|Phulgran PS|Rural Zone|
D-10|Shalimar PS|Saddar Zone|051-9266885
D-11|Shalimar PS|Saddar Zone|051-9266885
D-12|Golra Sharif PS|Saddar Zone|051-9267099
DHA Phases|Sihala PS|Soan Zone|051-4491334
DHA-2|Humak PS|Soan Zone|
Dhoke Kashmirian|Ramna PS|Saddar Zone|051-9330189
E-11|Shalimar PS|Saddar Zone|051-9266885
E-16|Tarnol PS|Saddar Zone|051-2295122
E-7|Kohsar PS|City Zone|051-9102499
E-8|Margalla PS|City Zone|051-9261510
E-9|Margalla PS|City Zone|051-9261510
F-10|Shalimar PS|Saddar Zone|051-9266885
F-11|Shalimar PS|Saddar Zone|051-9266885
F-12 to F-14|Sumbal PS|Saddar Zone|
F-5|Secretariat PS|City Zone|051-9209132
F-6|Kohsar PS|City Zone|051-9102499
F-7|Kohsar PS|City Zone|051-9102499
F-8|Margalla PS|City Zone|051-9261510
F-9|Margalla PS|City Zone|051-9261510
Faisal Mosque|Margalla PS|City Zone|051-9261510
Faizabad|Industrial Area I-9 PS|Industrial Area Zone|051-9258877
G-10|Ramna PS|Saddar Zone|051-9330189
G-11|Ramna PS|Saddar Zone|051-9330189
G-12|Ramna PS|Saddar Zone|051-9330189
G-12 to G-14|Sumbal PS|Saddar Zone|
G-13|Golra Sharif PS|Saddar Zone|051-9267099
G-14|Golra Sharif PS|Saddar Zone|051-9267099
G-15|Golra Sharif PS|Saddar Zone|051-9267099
G-16|Tarnol PS|Saddar Zone|051-2295122
G-5|Secretariat PS|City Zone|051-9209132
G-6|Aabpara PS|City Zone|051-9204830
G-7|Aabpara PS|City Zone|051-9204830
G-8|Karachi Company PS|City Zone|051-9334091
G-9|Karachi Company PS|City Zone|051-9334091
Ghauri Town|Koral PS|Soan Zone|051-9252517
Golra Village|Golra Sharif PS|Saddar Zone|051-9267099
Gulberg|Kirpa PS|Soan Zone|
H-10|Sabzi Mandi PS|Industrial Area Zone|051-9334840
H-11 to H-13|Shams Colony PS|Industrial Area Zone|051-9334499
H-8|Industrial Area I-9 PS|Industrial Area Zone|051-9258877
H-9|Industrial Area I-9 PS|Industrial Area Zone|051-9258877
Humak|Humak PS|Soan Zone|
I-10|Sabzi Mandi PS|Industrial Area Zone|051-9334840
I-11|Sabzi Mandi PS|Industrial Area Zone|051-9334840
I-14 to I-16|Noon PS|Industrial Area Zone|
I-8|Industrial Area I-9 PS|Industrial Area Zone|051-9258877
I-9|Industrial Area I-9 PS|Industrial Area Zone|051-9258877
IJP Road|Shams Colony PS|Industrial Area Zone|051-9334499
Khanna|Khanna PS|Soan Zone|051-4473600
Kirpa|Kirpa PS|Soan Zone|
Koral|Koral PS|Soan Zone|051-9252517
Kuri|Bani Gala PS|Rural Zone|051-9255339
Lake View|Secretariat PS|City Zone|051-9209132
Lohi Bher|Lohi Bher PS|Soan Zone|051-5710906
Mandla|Bhara Kahu PS|Rural Zone|051-2230029
Media Town|Lohi Bher PS|Soan Zone|051-5710906
Mera Begwal|Phulgran PS|Rural Zone|
Morgah|Sihala PS|Soan Zone|051-4491334
Niazian|Humak PS|Soan Zone|
Nilore|Nilore PS|Rural Zone|
Noon Village|Noon PS|Industrial Area Zone|
PTV Colony|Phulgran PS|Rural Zone|
Phulgran|Phulgran PS|Rural Zone|
Pind Daian|Koral PS|Soan Zone|051-9252517
Pindori|Kirpa PS|Soan Zone|
QAU|Secretariat PS|City Zone|051-9209132
Rawat|Shahzad Town PS|Rural Zone|051-9247444
Sabzi Mandi|Sabzi Mandi PS|Industrial Area Zone|051-9334840
Saidpur|Kohsar PS|City Zone|051-9102499
Sakreela|Phulgran PS|Rural Zone|
Sangjali|Bhara Kahu PS|Rural Zone|051-2230029
Sangjani|Sangjani PS|Saddar Zone|
Sectors C-15 to D-17|Sangjani PS|Saddar Zone|
Shahpur|Phulgran PS|Rural Zone|
Shahzad Town|Shahzad Town PS|Rural Zone|051-9247444
Shakar Parrian|Aabpara PS|City Zone|051-9204830
Shakrial|Khanna PS|Soan Zone|051-4473600
Shams Colony|Shams Colony PS|Industrial Area Zone|051-9334499
Sihala|Kirpa PS|Soan Zone|
Sihala|Sihala PS|Soan Zone|051-4491334
Sihali|Nilore PS|Rural Zone|
Sohan|Khanna PS|Soan Zone|051-4473600
Sports Complex|Aabpara PS|City Zone|051-9204830
Tarlai|Shahzad Town PS|Rural Zone|051-9247444
Tarnol|Sangjani PS|Saddar Zone|
Tarnol|Tarnol PS|Saddar Zone|051-2295122
Tumair|Nilore PS|Rural Zone|
Whole Islamabad (women's police station|Women PS PS|City Zone|051-9252517
Zaraj|Humak PS|Soan Zone|
''';

final List<PoliceDirectoryEntry> policeDirectoryEntries = _policeRows
    .trim()
    .split('\n')
    .map(PoliceDirectoryEntry.fromRow)
    .toList(growable: false);

final List<PoliceAreaCoverage> islamabadAreaCoverage = _areaRows
    .trim()
    .split('\n')
    .map(PoliceAreaCoverage.fromRow)
    .toList(growable: false);

const List<String> policeDirectoryCities = ['Islamabad', 'Lahore'];
