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

    final uid = credential.user!.uid;
    final initials = name.trim().split(' ').map((w) => w[0]).take(2).join().toUpperCase();
    final isMai = name.trim().toLowerCase() == 'mai';

    await _firestore.collection('users').doc(uid).set({
      'name': name,
      'username': '@$username',
      'avatarInitials': initials,
      'bio': isMai ? 'Astrophotographer & trip organizer. Exploring the darkest skies of Saudi Arabia.' : '',
      'isVerified': isMai,
      'isPremium': isMai,
      'avatarUrl': null,
      'bannerUrl': null,
      'createdAt': FieldValue.serverTimestamp(),
    });

    return credential;
  }

  /// Premium user emails — these accounts get isPremium + isVerified on login.
  static const _premiumEmails = {'maiali66m@gmail.com'};

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Grant premium to designated accounts (don't block login if this fails)
    try {
      if (_premiumEmails.contains(email.trim().toLowerCase())) {
        final uid = credential.user!.uid;
        await _firestore.collection('users').doc(uid).set({
          'isPremium': true,
          'isVerified': true,
        }, SetOptions(merge: true));
      }
    } catch (_) {}

    return credential;
  }

  /// Call on app startup to grant premium to already-logged-in premium users.
  Future<void> ensurePremiumStatus() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;
      final email = user.email?.trim().toLowerCase() ?? '';
      if (_premiumEmails.contains(email)) {
        await _firestore.collection('users').doc(user.uid).set({
          'isPremium': true,
          'isVerified': true,
        }, SetOptions(merge: true));
      }
    } catch (_) {}
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
