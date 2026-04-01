import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

class MockUser {
  const MockUser({
    required this.id,
    required this.name,
    required this.username,
    required this.avatarInitials,
    required this.bio,
    this.isVerified = false,
    this.isPremium = false,
    this.avatarUrl,
    this.bannerUrl,
    this.isPrivate = false,
    this.pushNotifications = true,
    this.emailNotifications = false,
    this.showOnlineStatus = true,
    this.allowMessages = true,
  });

  final String id;
  final String name;
  final String username;
  final String avatarInitials;
  final String bio;
  final bool isVerified;
  final bool isPremium;
  final String? avatarUrl;
  final String? bannerUrl;
  final bool isPrivate;
  final bool pushNotifications;
  final bool emailNotifications;
  final bool showOnlineStatus;
  final bool allowMessages;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'username': username,
      'avatarInitials': avatarInitials,
      'bio': bio,
      'isVerified': isVerified,
      'isPremium': isPremium,
      'avatarUrl': avatarUrl,
      'bannerUrl': bannerUrl,
      'isPrivate': isPrivate,
      'pushNotifications': pushNotifications,
      'emailNotifications': emailNotifications,
      'showOnlineStatus': showOnlineStatus,
      'allowMessages': allowMessages,
    };
  }

  factory MockUser.fromMap(String id, Map<String, dynamic> map) {
    return MockUser(
      id: id,
      name: map['name'] ?? '',
      username: map['username'] ?? '',
      avatarInitials: map['avatarInitials'] ?? '',
      bio: map['bio'] ?? '',
      isVerified: map['isVerified'] ?? false,
      isPremium: map['isPremium'] ?? false,
      avatarUrl: map['avatarUrl'],
      bannerUrl: map['bannerUrl'],
      isPrivate: map['isPrivate'] ?? false,
      pushNotifications: map['pushNotifications'] ?? true,
      emailNotifications: map['emailNotifications'] ?? false,
      showOnlineStatus: map['showOnlineStatus'] ?? true,
      allowMessages: map['allowMessages'] ?? true,
    );
  }

  MockUser copyWith({
    String? id,
    String? name,
    String? username,
    String? avatarInitials,
    String? bio,
    bool? isVerified,
    bool? isPremium,
    String? avatarUrl,
    String? bannerUrl,
    bool? isPrivate,
    bool? pushNotifications,
    bool? emailNotifications,
    bool? showOnlineStatus,
    bool? allowMessages,
  }) {
    return MockUser(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      avatarInitials: avatarInitials ?? this.avatarInitials,
      bio: bio ?? this.bio,
      isVerified: isVerified ?? this.isVerified,
      isPremium: isPremium ?? this.isPremium,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bannerUrl: bannerUrl ?? this.bannerUrl,
      isPrivate: isPrivate ?? this.isPrivate,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      showOnlineStatus: showOnlineStatus ?? this.showOnlineStatus,
      allowMessages: allowMessages ?? this.allowMessages,
    );
  }
}

class SkyPost {
  SkyPost({
    required this.id,
    required this.user,
    required this.caption,
    required this.imageAssets,
    required this.timeAgo,
    required this.likes,
    required this.comments,
    this.reposts = 0,
    this.isLiked = false,
    this.isBookmarked = false,
    this.location,
    this.bortleClass,
    this.imageFiles = const [],
    this.imageUrls = const [],
    this.likedBy = const [],
    this.bookmarkedBy = const [],
    this.userId = '',
    this.createdAt,
  });

  final String id;
  final MockUser user;
  final String caption;
  final List<String> imageAssets;
  final List<dynamic> imageFiles;
  final List<String> imageUrls;
  final String timeAgo;
  int likes;
  final int reposts;
  final List<PostComment> comments;
  bool isLiked;
  bool isBookmarked;
  final String? location;
  final int? bortleClass;
  final List<String> likedBy;
  final List<String> bookmarkedBy;
  final String userId;
  final DateTime? createdAt;

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'caption': caption,
      'imageAssets': imageAssets,
      'imageUrls': imageUrls,
      'likes': likes,
      'reposts': reposts,
      'location': location,
      'bortleClass': bortleClass,
      'likedBy': likedBy,
      'bookmarkedBy': bookmarkedBy,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  factory SkyPost.fromMap(String id, Map<String, dynamic> map, MockUser user, List<PostComment> comments) {
    final createdAt = map['createdAt'];
    DateTime? dateTime;
    if (createdAt is Timestamp) {
      dateTime = createdAt.toDate();
    }

    final likedBy = List<String>.from(map['likedBy'] ?? []);
    final bookmarkedBy = List<String>.from(map['bookmarkedBy'] ?? []);

    // Use network URLs if available, otherwise fall back to local image paths
    final imageUrls = List<String>.from(map['imageUrls'] ?? []);
    final localPaths = List<String>.from(map['localImagePaths'] ?? []);

    return SkyPost(
      id: id,
      user: user,
      caption: map['caption'] ?? '',
      imageAssets: List<String>.from(map['imageAssets'] ?? []),
      imageUrls: imageUrls,
      imageFiles: imageUrls.isEmpty
          ? localPaths.map((p) => File(p)).where((f) => f.existsSync()).toList()
          : const [],
      timeAgo: _timeAgoFromDate(dateTime),
      likes: likedBy.length,
      reposts: map['reposts'] ?? 0,
      comments: comments,
      location: map['location'],
      bortleClass: map['bortleClass'],
      likedBy: likedBy,
      bookmarkedBy: bookmarkedBy,
      userId: map['userId'] ?? '',
      createdAt: dateTime,
    );
  }

  static String _timeAgoFromDate(DateTime? date) {
    if (date == null) return 'now';
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 365) return '${diff.inDays ~/ 365}y';
    if (diff.inDays > 30) return '${diff.inDays ~/ 30}mo';
    if (diff.inDays > 0) return '${diff.inDays}d';
    if (diff.inHours > 0) return '${diff.inHours}h';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m';
    return 'now';
  }
}

class PostComment {
  const PostComment({
    required this.user,
    required this.text,
    required this.timeAgo,
    this.id = '',
    this.userId = '',
    this.createdAt,
  });

  final String id;
  final MockUser user;
  final String text;
  final String timeAgo;
  final String userId;
  final DateTime? createdAt;

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'text': text,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  factory PostComment.fromMap(String id, Map<String, dynamic> map, MockUser user) {
    final createdAt = map['createdAt'];
    DateTime? dateTime;
    if (createdAt is Timestamp) {
      dateTime = createdAt.toDate();
    }

    return PostComment(
      id: id,
      user: user,
      text: map['text'] ?? '',
      timeAgo: SkyPost._timeAgoFromDate(dateTime),
      userId: map['userId'] ?? '',
      createdAt: dateTime,
    );
  }
}

String formatCount(int count) {
  if (count >= 1000000) {
    final value = count / 1000000;
    return value == value.truncateToDouble()
        ? '${value.toInt()}M'
        : '${value.toStringAsFixed(1)}M';
  } else if (count >= 1000) {
    final value = count / 1000;
    return value == value.truncateToDouble()
        ? '${value.toInt()}k'
        : '${value.toStringAsFixed(1)}k';
  }
  return '$count';
}
