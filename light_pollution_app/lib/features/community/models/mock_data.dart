import 'package:cloud_firestore/cloud_firestore.dart';
import 'community_models.dart';

class MockData {
  static const suraOfficial = MockUser(
    id: '1',
    name: 'Sura KSA',
    username: '@sura_ksa',
    avatarInitials: 'SK',
    bio: 'Official Sura account. Exploring the skies of Saudi Arabia.',
    isVerified: true,
  );

  static const norahStars = MockUser(
    id: '2',
    name: 'Norah Al-Stars',
    username: '@norah_stars',
    avatarInitials: 'NA',
    bio: 'Astrophotographer from Riyadh. Chasing dark skies.',
  );

  static const khaledAstro = MockUser(
    id: '3',
    name: 'Khaled Astronomy',
    username: '@khaled_astro',
    avatarInitials: 'KA',
    bio: 'Amateur astronomer. Telescope addict.',
  );

  static const sarahMoon = MockUser(
    id: '4',
    name: 'Sarah Moon',
    username: '@sarah_moon',
    avatarInitials: 'SM',
    bio: 'Night sky lover. Bortle 2 hunter.',
  );

  static const ahmedSky = MockUser(
    id: '5',
    name: 'Ahmed Sky',
    username: '@ahmed_sky',
    avatarInitials: 'AS',
    bio: 'Desert stargazer. Light pollution awareness advocate.',
  );

  static const lailaGalaxy = MockUser(
    id: '6',
    name: 'Laila Galaxy',
    username: '@laila_galaxy',
    avatarInitials: 'LG',
    bio: 'Milky Way photographer. Jeddah based.',
  );

  static const faisalNebula = MockUser(
    id: '7',
    name: 'Faisal Nebula',
    username: '@faisal_nebula',
    avatarInitials: 'FN',
    bio: 'Deep sky objects are my passion. AlUla dark sky reserve regular.',
  );

  static const ranaComet = MockUser(
    id: '8',
    name: 'Rana Comet',
    username: '@rana_comet',
    avatarInitials: 'RC',
    bio: 'Physics student. Part-time stargazer.',
  );

  static const maiPremium = MockUser(
    id: '9',
    name: 'Mai',
    username: '@mai',
    avatarInitials: 'MA',
    bio: 'Astrophotographer & trip organizer. Exploring the darkest skies of Saudi Arabia.',
    isVerified: true,
    isPremium: true,
  );

  static List<MockUser> get allUsers => [
    suraOfficial, norahStars, khaledAstro, sarahMoon,
    ahmedSky, lailaGalaxy, faisalNebula, ranaComet, maiPremium,
  ];

  /// Seeds Firestore with mock users and posts if the 'posts' collection is empty.
  static Future<void> seedFirestore() async {
    final db = FirebaseFirestore.instance;

    // Check if data already exists
    final postsSnapshot = await db.collection('posts').limit(1).get();
    if (postsSnapshot.docs.isNotEmpty) return; // Already seeded

    // Create mock user documents (using fixed IDs like 'mock_1', 'mock_2', etc.)
    final userIdMap = <String, String>{}; // old id -> firestore doc id
    for (final user in allUsers) {
      final docId = 'mock_${user.id}';
      userIdMap[user.id] = docId;
      await db.collection('users').doc(docId).set(user.toMap());
    }

    // Create mock posts
    final postsData = [
      {
        'userId': userIdMap['1']!,
        'caption': 'The sky today was incredibly clear! Try the light pollution detection feature and let us know your results',
        'imageAssets': ['milky_way'],
        'imageUrls': <String>[],
        'likedBy': [userIdMap['2']!, userIdMap['3']!, userIdMap['4']!],
        'bookmarkedBy': <String>[],
        'reposts': 182,
        'location': 'AlUla, Saudi Arabia',
        'bortleClass': 2,
        'createdAt': Timestamp.fromDate(DateTime.now().subtract(const Duration(hours: 9))),
      },
      {
        'userId': userIdMap['2']!,
        'caption': 'Milky Way shot from the Empty Quarter desert. Light pollution was only 3%! The cleanest sky I\'ve ever seen',
        'imageAssets': ['desert_stars'],
        'imageUrls': <String>[],
        'likedBy': [userIdMap['1']!, userIdMap['5']!],
        'bookmarkedBy': <String>[],
        'reposts': 95,
        'location': 'Empty Quarter, Saudi Arabia',
        'bortleClass': 1,
        'createdAt': Timestamp.fromDate(DateTime.now().subtract(const Duration(hours: 12))),
      },
      {
        'userId': userIdMap['3']!,
        'caption': 'Orion Nebula through an 8-inch telescope. 45 minutes exposure. The night was perfect for stargazing',
        'imageAssets': ['orion_nebula'],
        'imageUrls': <String>[],
        'likedBy': [userIdMap['7']!],
        'bookmarkedBy': <String>[],
        'reposts': 44,
        'location': 'Hail, Saudi Arabia',
        'bortleClass': 3,
        'createdAt': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 1))),
      },
      {
        'userId': userIdMap['4']!,
        'caption': 'The moon tonight from my apartment in Riyadh. Even with light pollution, the moon never fails to amaze me',
        'imageAssets': ['moon_city'],
        'imageUrls': <String>[],
        'likedBy': <String>[],
        'bookmarkedBy': <String>[],
        'reposts': 8,
        'location': 'Riyadh, Saudi Arabia',
        'bortleClass': 7,
        'createdAt': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 1, hours: 6))),
      },
      {
        'userId': userIdMap['5']!,
        'caption': 'City sky vs desert sky comparison. The difference is clear! Light pollution is a real problem that needs solutions',
        'imageAssets': ['comparison', 'desert_stars'],
        'imageUrls': <String>[],
        'likedBy': [userIdMap['1']!, userIdMap['6']!, userIdMap['8']!],
        'bookmarkedBy': <String>[],
        'reposts': 312,
        'location': null,
        'bortleClass': null,
        'createdAt': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 2))),
      },
      {
        'userId': userIdMap['6']!,
        'caption': 'Milky Way over the Red Sea. An unforgettable night trip with friends',
        'imageAssets': ['milky_sea', 'alula_sky'],
        'imageUrls': <String>[],
        'likedBy': [userIdMap['4']!],
        'bookmarkedBy': <String>[],
        'reposts': 31,
        'location': 'Yanbu, Saudi Arabia',
        'bortleClass': 3,
        'createdAt': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 2, hours: 4))),
      },
      {
        'userId': userIdMap['7']!,
        'caption': 'First visit to AlUla Dark Sky Reserve. Only 5% light pollution! The place is magical',
        'imageAssets': ['alula_sky'],
        'imageUrls': <String>[],
        'likedBy': [userIdMap['5']!, userIdMap['1']!],
        'bookmarkedBy': <String>[],
        'reposts': 22,
        'location': 'AlUla Dark Sky Reserve',
        'bortleClass': 2,
        'createdAt': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 3))),
      },
      {
        'userId': userIdMap['8']!,
        'caption': 'My first attempt at astrophotography! Not perfect but the excitement is real. Any tips for beginners?',
        'imageAssets': ['beginner_sky'],
        'imageUrls': <String>[],
        'likedBy': <String>[],
        'bookmarkedBy': <String>[],
        'reposts': 12,
        'location': 'Abha, Saudi Arabia',
        'bortleClass': 4,
        'createdAt': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 3, hours: 8))),
      },
    ];

    // Seed posts and their comments
    final commentsData = <int, List<Map<String, dynamic>>>{
      0: [
        {'userId': userIdMap['2']!, 'text': 'Amazing shot!', 'hoursAgo': 8},
        {'userId': userIdMap['3']!, 'text': 'AlUla always has clear skies', 'hoursAgo': 7},
        {'userId': userIdMap['4']!, 'text': 'I need to visit soon', 'hoursAgo': 6},
      ],
      1: [
        {'userId': userIdMap['5']!, 'text': 'The Empty Quarter is an astronomical treasure', 'hoursAgo': 11},
        {'userId': userIdMap['6']!, 'text': 'Professional photography', 'hoursAgo': 10},
      ],
      2: [
        {'userId': userIdMap['7']!, 'text': 'What type of telescope?', 'hoursAgo': 23},
        {'userId': userIdMap['3']!, 'text': 'Celestron NexStar 8SE', 'hoursAgo': 22},
        {'userId': userIdMap['8']!, 'text': 'I dream of taking shots like this', 'hoursAgo': 20},
      ],
      3: [
        {'userId': userIdMap['2']!, 'text': 'The moon doesn\'t need clear skies to be beautiful', 'hoursAgo': 24},
      ],
      4: [
        {'userId': userIdMap['1']!, 'text': 'Important awareness content! Thanks Ahmed', 'hoursAgo': 48},
        {'userId': userIdMap['6']!, 'text': 'We need to spread more awareness', 'hoursAgo': 48},
        {'userId': userIdMap['8']!, 'text': 'The difference is truly shocking', 'hoursAgo': 24},
        {'userId': userIdMap['3']!, 'text': 'Great job!', 'hoursAgo': 24},
      ],
      5: [
        {'userId': userIdMap['4']!, 'text': 'Lucky you! Where exactly in Yanbu?', 'hoursAgo': 48},
        {'userId': userIdMap['6']!, 'text': 'Sharm Yanbu beach, far from city lights', 'hoursAgo': 48},
      ],
      6: [
        {'userId': userIdMap['5']!, 'text': 'One of the best spots in the kingdom for stargazing', 'hoursAgo': 72},
        {'userId': userIdMap['1']!, 'text': 'AlUla is a world-class astronomy destination', 'hoursAgo': 72},
      ],
      7: [
        {'userId': userIdMap['2']!, 'text': 'Great start! Try increasing your exposure time', 'hoursAgo': 72},
        {'userId': userIdMap['3']!, 'text': 'Use a sturdy tripod and try 15-20 second exposure', 'hoursAgo': 72},
        {'userId': userIdMap['7']!, 'text': 'The PhotoPills app helps you locate the Milky Way', 'hoursAgo': 48},
        {'userId': userIdMap['4']!, 'text': 'Well done! Keep going', 'hoursAgo': 48},
      ],
    };

    for (int i = 0; i < postsData.length; i++) {
      final postRef = await db.collection('posts').add(postsData[i]);

      // Add comments for this post
      if (commentsData.containsKey(i)) {
        for (final comment in commentsData[i]!) {
          await postRef.collection('comments').add({
            'userId': comment['userId'],
            'text': comment['text'],
            'createdAt': Timestamp.fromDate(
              DateTime.now().subtract(Duration(hours: comment['hoursAgo'] as int)),
            ),
          });
        }
      }
    }
  }
}
