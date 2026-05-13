enum PlaceCategory {
  restaurant,
  cafe,
  patisserie,
  sandwich,
  streetFood,
  juiceBar,
}

extension PlaceCategoryX on PlaceCategory {
  String get label => switch (this) {
        PlaceCategory.restaurant => 'Restaurant',
        PlaceCategory.cafe => 'Café',
        PlaceCategory.patisserie => 'Patisserie',
        PlaceCategory.sandwich => 'Sandwich',
        PlaceCategory.streetFood => 'Street Food',
        PlaceCategory.juiceBar => 'Juice Bar',
      };
}

enum PriceRange { budget, mid, premium }

extension PriceRangeX on PriceRange {
  String get label => switch (this) {
        PriceRange.budget => '€',
        PriceRange.mid => '€€',
        PriceRange.premium => '€€€',
      };
}

class PlaceModel {
  const PlaceModel({
    required this.id,
    required this.name,
    required this.category,
    required this.wilaya,
    required this.neighborhood,
    required this.address,
    required this.score,
    required this.reviewCount,
    required this.coverUrl,
    this.photos = const [],
    required this.priceRange,
    required this.isOpen,
    this.openUntil,
    this.distance,
  });

  final String id;
  final String name;
  final PlaceCategory category;
  final String wilaya;
  final String neighborhood;
  final String address;
  final double score;
  final int reviewCount;
  final String coverUrl;
  final List<String> photos;
  final PriceRange priceRange;
  final bool isOpen;
  final String? openUntil;
  final String? distance;
}

class ReviewModel {
  const ReviewModel({
    required this.id,
    required this.authorName,
    required this.authorWilaya,
    required this.authorInitial,
    required this.score,
    required this.text,
    required this.timeAgo,
    this.photos = const [],
  });

  final String id;
  final String authorName;
  final String authorWilaya;
  final String authorInitial;
  final double score;
  final String text;
  final String timeAgo;
  final List<String> photos;
}

// Mock data used until Firebase is wired
abstract final class MockData {
  static const places = [
    PlaceModel(
      id: 'p1',
      name: 'Chez Fatima',
      category: PlaceCategory.restaurant,
      wilaya: 'Blida',
      neighborhood: 'Centre-ville',
      address: '12 Rue Ben M\'hidi, Blida',
      score: 8.5,
      reviewCount: 124,
      coverUrl: 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=800',
      photos: [
        'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=400',
        'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=400',
        'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?w=400',
      ],
      priceRange: PriceRange.mid,
      isOpen: true,
      openUntil: '23:00',
      distance: '1.2 km',
    ),
    PlaceModel(
      id: 'p2',
      name: 'Café Tanit',
      category: PlaceCategory.cafe,
      wilaya: 'Alger',
      neighborhood: 'Hydra',
      address: '5 Rue des Oliviers, Hydra, Alger',
      score: 9.1,
      reviewCount: 287,
      coverUrl: 'https://images.unsplash.com/photo-1554118811-1e0d58224f24?w=800',
      photos: [
        'https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?w=400',
        'https://images.unsplash.com/photo-1442512595331-e89e73853f31?w=400',
      ],
      priceRange: PriceRange.mid,
      isOpen: true,
      openUntil: '22:00',
      distance: '0.8 km',
    ),
    PlaceModel(
      id: 'p3',
      name: 'Le Pâtissier',
      category: PlaceCategory.patisserie,
      wilaya: 'Oran',
      neighborhood: 'Bir El Djir',
      address: '88 Boulevard Zabana, Oran',
      score: 7.8,
      reviewCount: 61,
      coverUrl: 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=800',
      photos: [],
      priceRange: PriceRange.budget,
      isOpen: false,
      openUntil: null,
      distance: '3.4 km',
    ),
    PlaceModel(
      id: 'p4',
      name: 'Snack El Baraka',
      category: PlaceCategory.streetFood,
      wilaya: 'Constantine',
      neighborhood: 'El Kantara',
      address: 'Place des Martyrs, Constantine',
      score: 8.2,
      reviewCount: 98,
      coverUrl: 'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=800',
      photos: [],
      priceRange: PriceRange.budget,
      isOpen: true,
      openUntil: '02:00',
      distance: '0.4 km',
    ),
    PlaceModel(
      id: 'p5',
      name: 'Fresh Corner',
      category: PlaceCategory.juiceBar,
      wilaya: 'Annaba',
      neighborhood: 'Sidi Achour',
      address: '3 Av. de l\'ALN, Annaba',
      score: 9.4,
      reviewCount: 203,
      coverUrl: 'https://images.unsplash.com/photo-1600271886742-f049cd451bba?w=800',
      photos: [],
      priceRange: PriceRange.budget,
      isOpen: true,
      openUntil: '21:00',
      distance: '2.1 km',
    ),
  ];

  static const reviews = [
    ReviewModel(
      id: 'r1',
      authorName: 'Amine K.',
      authorWilaya: 'Blida',
      authorInitial: 'A',
      score: 9.0,
      text: 'One of the best restaurants in Blida, hands down. The couscous is incredible — generous portions, amazing sauce. The staff is always welcoming and the place feels like a family home. Been coming here for 3 years and it never disappoints.',
      timeAgo: '2 days ago',
    ),
    ReviewModel(
      id: 'r2',
      authorName: 'Sara M.',
      authorWilaya: 'Alger',
      authorInitial: 'S',
      score: 8.0,
      text: 'Really good food, especially the grilled dishes. Can get crowded on weekends so come early. Prices are very fair for the quality.',
      timeAgo: '1 week ago',
    ),
    ReviewModel(
      id: 'r3',
      authorName: 'Yacine B.',
      authorWilaya: 'Blida',
      authorInitial: 'Y',
      score: 8.5,
      text: 'Solid place. The bourek is excellent, crispy and well-filled. Service could be a bit faster but overall a great experience.',
      timeAgo: '2 weeks ago',
    ),
    ReviewModel(
      id: 'r4',
      authorName: 'Nadia T.',
      authorWilaya: 'Médéa',
      authorInitial: 'N',
      score: 9.5,
      text: 'Best home-style cooking I\'ve found outside my own mother\'s kitchen. Highly recommend the daily special — they change it every day and it\'s always exceptional.',
      timeAgo: '3 weeks ago',
    ),
  ];
}
