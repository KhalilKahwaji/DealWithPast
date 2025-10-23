// lib/Backend/auth.dart
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);

Future<User?> signInWithGoogle() async {
  debugPrint('[AUTH] signInWithGoogle: start');
  try {
    final acct = await googleSignIn.signIn();
    if (acct == null) {
      debugPrint('[AUTH] user cancelled Google picker');
      return null;
    }
    debugPrint('[AUTH] account: ${acct.email}');

    final tokens = await acct.authentication;
    debugPrint('[AUTH] tokens: idToken? ${tokens.idToken != null}, accessToken? ${tokens.accessToken != null}');

    final credential = GoogleAuthProvider.credential(
      idToken: tokens.idToken,
      accessToken: tokens.accessToken,
    );

    final result = await _auth.signInWithCredential(credential);
    final user = result.user;
    debugPrint('[AUTH] Firebase signed in: uid=${user?.uid}, email=${user?.email}');
    return user;
  } on FirebaseAuthException catch (e) {
    debugPrint('[AUTH][FirebaseAuthException] code=${e.code} msg=${e.message}');
    rethrow;
  } catch (e) {
    debugPrint('[AUTH][Exception] $e');
    rethrow;
  }
}

Future<void> signOut() async {
  try { await googleSignIn.signOut(); } catch (_) {}
  await _auth.signOut();
  debugPrint('[AUTH] signOut done');
}
