import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Email login
  Future<User?> signInWithEmail(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
    return credential.user;
  }

  /// Email registration with username
  Future<User?> signUpWithEmail(String email, String password, String username) async {
    final credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    final user = credential.user;

    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'email': user.email,
        'username': username,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    return user;
  }

  Future<void> saveUserToFirestore(String uid, String username, String email) async {
  await _firestore.collection('users').doc(uid).set({
    'username': username,
    'email': email,
    'createdAt': FieldValue.serverTimestamp(),
  });
}

  /// Reset password
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  /// Google Sign-In
  Future<User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return null; // user canceled

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _auth.signInWithCredential(credential);
    final user = userCredential.user;

    if (user != null) {
      final docRef = _firestore.collection('users').doc(user.uid);
      final docSnapshot = await docRef.get();

      // Only write data if user doc doesn't exist
      if (!docSnapshot.exists) {
        await docRef.set({
          'uid': user.uid,
          'email': user.email,
          'username': user.displayName ?? 'No Name',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    }

    return user;
  }

  /// Sign out
  Future<void> signOut() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
  }

  /// Current user
  User? get currentUser => _auth.currentUser;
}
