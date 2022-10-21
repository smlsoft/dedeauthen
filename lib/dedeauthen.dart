library dedeauthen;

import 'package:dedeauthen/repositories/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserRepository _userRepository = new UserRepository();
  Future<bool> signInWithGoogle() async {
    // Trigger the authentication flow
    final googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final googleAuth = await googleUser?.authentication;

    if (googleAuth != null) {
      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      try {
        await _auth.signInWithCredential(credential);

        return true;
      } on FirebaseAuthException catch (e) {
        print(e);
        return false;
      }
    } else {
      return false;
    }
  }

  Future<bool> signInWithLine() async {
    try {
      final result =
          await LineSDK.instance.login(scopes: ["profile", "openid", "email"]);

      return true;
    } on PlatformException catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> signInWithApple() async {
    final appleProvider = AppleAuthProvider();
    appleProvider.addScope('email');

    await _auth.signInWithProvider(appleProvider);
    return true;
  }

  Future<bool> signInWithEmail(
      String serviceApi, String userName, String passWord) async {
    try {
      final _result =
          await _userRepository.authenUser(serviceApi, userName, passWord);
      if (_result.success) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
