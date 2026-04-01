import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential> signUp({
    required String email,
    required String password,
    required String name,
    required String username,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user;
    if (user == null) throw Exception('Sign-up succeeded but user is null');

    final uid = user.uid;
    final words = name.trim().split(' ').where((w) => w.isNotEmpty).toList();
    final initials = words.map((w) => w[0]).take(2).join().toUpperCase();

    await _firestore.collection('users').doc(uid).set({
      'name': name,
      'username': '@$username',
      'avatarInitials': initials,
      'bio': '',
      'isVerified': false,
      'isPremium': false,
      'avatarUrl': null,
      'bannerUrl': null,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Grant premium if this email is in the premium list
    await _grantPremiumIfEligible(email, uid);

    return credential;
  }

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user;
    if (user == null) throw Exception('Sign-in succeeded but user is null');

    // Grant premium to designated accounts (don't block login if this fails)
    await _grantPremiumIfEligible(email, user.uid);

    return credential;
  }

  /// Call on app startup to grant premium to already-logged-in premium users.
  Future<void> ensurePremiumStatus() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;
      final email = user.email?.trim().toLowerCase() ?? '';
      await _grantPremiumIfEligible(email, user.uid);
    } catch (e) {
      debugPrint('Failed to ensure premium status: $e');
    }
  }

  /// Check if [email] is in the premium list and grant premium + verified.
  /// Premium emails are stored in the Firestore `config/premium` document.
  /// Falls back to a hardcoded list if the config document doesn't exist.
  Future<void> _grantPremiumIfEligible(String email, String uid) async {
    try {
      final normalizedEmail = email.trim().toLowerCase();

      // Try to read premium emails from Firestore config
      Set<String> premiumEmails;
      try {
        final configDoc = await _firestore.collection('config').doc('premium').get();
        if (configDoc.exists && configDoc.data()?['emails'] != null) {
          premiumEmails = Set<String>.from(
            (configDoc.data()!['emails'] as List).map((e) => e.toString().trim().toLowerCase()),
          );
        } else {
          premiumEmails = _fallbackPremiumEmails;
        }
      } catch (_) {
        premiumEmails = _fallbackPremiumEmails;
      }

      if (premiumEmails.contains(normalizedEmail)) {
        await _firestore.collection('users').doc(uid).set({
          'isPremium': true,
          'isVerified': true,
        }, SetOptions(merge: true));
      }
    } catch (e) {
      debugPrint('Failed to grant premium status: $e');
    }
  }

  /// Fallback premium emails when Firestore config is unavailable.
  static const _fallbackPremiumEmails = {'maiali66m@gmail.com'};

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
