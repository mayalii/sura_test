import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/trip_model.dart';

final tripFilterProvider = StateProvider<TripFilter>((ref) => TripFilter.all);

final _db = FirebaseFirestore.instance;

/// Stream of all trips from Firestore, ordered by date.
final tripsStreamProvider = StreamProvider<List<StargazingTrip>>((ref) {
  final currentUser = ref.watch(currentUserProvider).valueOrNull;
  final uid = currentUser?.id;

  return _db
      .collection('trips')
      .orderBy('date', descending: false)
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) {
      return StargazingTrip.fromMap(doc.id, doc.data(), currentUserId: uid);
    }).toList();
  });
});

/// Adds a new trip to Firestore.
Future<void> addTripToFirestore(StargazingTrip trip) async {
  await _db.collection('trips').add(trip.toMap());
}

/// Books a trip for the current user in Firestore.
Future<void> bookTripInFirestore(String tripId, String userId) async {
  final ref = _db.collection('trips').doc(tripId);
  await _db.runTransaction((txn) async {
    final doc = await txn.get(ref);
    if (!doc.exists) return;

    final data = doc.data()!;
    final bookedBy = List<String>.from(data['bookedBy'] ?? []);
    final spotsLeft = data['spotsLeft'] as int? ?? 0;

    if (bookedBy.contains(userId) || spotsLeft <= 0) return;

    bookedBy.add(userId);
    txn.update(ref, {
      'bookedBy': bookedBy,
      'spotsLeft': spotsLeft - 1,
    });
  });
}

/// Seeds Firestore with mock trips if the 'trips' collection is empty.
Future<void> seedTripsIfNeeded() async {
  final snapshot = await _db.collection('trips').limit(1).get();
  if (snapshot.docs.isNotEmpty) return;

  for (final trip in _mockTrips) {
    await _db.collection('trips').add(trip.toMap());
  }
}

// ── Keep for backward compatibility with existing code ──

class ReserveNotifier extends StateNotifier<List<StargazingTrip>> {
  ReserveNotifier() : super([]);

  void bookTrip(String id) {
    state = [
      for (final trip in state)
        if (trip.id == id && !trip.isBooked)
          trip.copyWith(isBooked: true, spotsLeft: trip.spotsLeft - 1)
        else
          trip,
    ];
  }

  void addTrip(StargazingTrip trip) {
    state = [trip, ...state];
  }
}

final reserveProvider =
    StateNotifierProvider<ReserveNotifier, List<StargazingTrip>>((ref) {
  return ReserveNotifier();
});

final _mockTrips = <StargazingTrip>[
  StargazingTrip(
    id: '1',
    title: 'Milky Way Photography Night',
    location: 'AlUla, Saudi Arabia',
    date: DateTime(2026, 3, 15),
    durationHours: 5,
    guideName: 'Ahmed Al-Harbi',
    guideRating: 4.9,
    bortleClass: 1,
    price: 350,
    maxGroupSize: 12,
    spotsLeft: 4,
    description:
        'Experience the stunning Milky Way core rising over the ancient Nabataean tombs of AlUla. This guided session includes astrophotography tips, constellation identification, and telescope observation of deep-sky objects in one of the darkest skies in the Middle East.',
    included: [
      'Professional telescope access',
      'Star map & red flashlight',
      'Hot beverages & snacks',
      'Astrophotography guidance',
      'Transport from AlUla center',
    ],
    gradientColors: [Color(0xFF000814), Color(0xFF001d3d), Color(0xFF1a0a00)],
  ),
  StargazingTrip(
    id: '2',
    title: 'Desert Constellation Tour',
    location: 'Tabuk, Saudi Arabia',
    date: DateTime(2026, 3, 22),
    durationHours: 4,
    guideName: 'Fatima Al-Otaibi',
    guideRating: 4.8,
    bortleClass: 2,
    price: 280,
    maxGroupSize: 15,
    spotsLeft: 7,
    description:
        'Journey into the Tabuk desert for a magical night under pristine dark skies. Learn to navigate using the stars as ancient Arabian travelers did, and observe planets, nebulae, and star clusters through professional-grade telescopes.',
    included: [
      'Telescope & binocular access',
      'Traditional Arabian coffee',
      'Desert camp setup',
      'Constellation guide booklet',
    ],
    gradientColors: [Color(0xFF0a0a2e), Color(0xFF1a1a4e), Color(0xFF0d0d1a)],
  ),
  StargazingTrip(
    id: '3',
    title: 'New Moon Deep Sky Session',
    location: 'Hail, Saudi Arabia',
    date: DateTime(2026, 4, 5),
    durationHours: 6,
    guideName: 'Omar Al-Rashid',
    guideRating: 4.7,
    bortleClass: 2,
    price: 420,
    maxGroupSize: 8,
    spotsLeft: 2,
    description:
        'A premium deep-sky observation during the new moon phase in the dark skies of Hail. Ideal for experienced stargazers looking to observe galaxies, planetary nebulae, and globular clusters with exceptional clarity.',
    included: [
      '12-inch Dobsonian telescope',
      'Advanced star charts',
      'Warm blankets & seating',
      'Dinner & hot drinks',
      'Camera adapter for phone',
      'Certificate of completion',
    ],
    gradientColors: [Color(0xFF0a0020), Color(0xFF2d1b69), Color(0xFF0a0a2e)],
  ),
  StargazingTrip(
    id: '4',
    title: 'Family Stargazing Adventure',
    location: 'Al Baha, Saudi Arabia',
    date: DateTime(2026, 4, 12),
    durationHours: 3,
    guideName: 'Noura Al-Zahrani',
    guideRating: 4.9,
    bortleClass: 3,
    price: 180,
    maxGroupSize: 20,
    spotsLeft: 11,
    description:
        'A fun and educational stargazing experience designed for families. Kids and adults will learn about the solar system, spot satellites, and enjoy storytelling about Arabian star mythology under the beautiful Al Baha skies.',
    included: [
      'Kids activity booklet',
      'Telescope viewing',
      'Snacks & juice',
      'Glow-in-the-dark star map',
    ],
    gradientColors: [Color(0xFF0f0f2e), Color(0xFF1e1e4e), Color(0xFF15152e)],
  ),
  StargazingTrip(
    id: '5',
    title: 'Meteor Shower Watch Party',
    location: 'Asir, Saudi Arabia',
    date: DateTime(2026, 4, 22),
    durationHours: 5,
    guideName: 'Khalid Al-Malki',
    guideRating: 4.6,
    bortleClass: 2,
    price: 300,
    maxGroupSize: 25,
    spotsLeft: 15,
    description:
        'Watch the Lyrid meteor shower from the stunning highlands of Asir. With minimal light pollution and high altitude, this is the perfect spot to catch shooting stars streaking across the sky.',
    included: [
      'Reclining chairs',
      'Blankets & pillows',
      'Hot chocolate & dates',
      'Meteor counting sheet',
      'Group photo under the stars',
    ],
    gradientColors: [Color(0xFF000000), Color(0xFF0d1b2a), Color(0xFF0a0a0a)],
  ),
  StargazingTrip(
    id: '6',
    title: 'Astrophotography Masterclass',
    location: 'NEOM, Saudi Arabia',
    date: DateTime(2026, 5, 1),
    durationHours: 7,
    guideName: 'Sara Al-Dosari',
    guideRating: 5.0,
    bortleClass: 1,
    price: 550,
    maxGroupSize: 6,
    spotsLeft: 1,
    description:
        'An intensive astrophotography workshop at one of the darkest sites in Saudi Arabia. Learn long-exposure techniques, star tracking, and post-processing under the guidance of an award-winning astrophotographer.',
    included: [
      'Star tracker mount rental',
      'Camera settings workshop',
      'Post-processing tutorial',
      'Dinner & refreshments',
      'USB with raw photos',
      'One-on-one mentoring',
    ],
    gradientColors: [Color(0xFF000814), Color(0xFF003566), Color(0xFF001d3d)],
  ),
];
