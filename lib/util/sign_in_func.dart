// https://firebase.flutter.dev/docs/auth/social/

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

Future<UserCredential?> signInWithGoogle() async {
  await EasyLoading.show();

  try {
    // Trigger the authentication flow
    final googleUser = await GoogleSignIn().signIn();
    // Obtain the auth details from the request
    final googleAuth = await googleUser!.authentication;
    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    // Once signed in, return the UserCredential
    return FirebaseAuth.instance.signInWithCredential(credential);
  } on Exception {
    return null;
  } finally {
    await EasyLoading.dismiss();
  }
}

Future<User?> signInWithApple() async {
  await EasyLoading.show();

  try {
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    print(appleCredential);
    final oAuthProvider = OAuthProvider('apple.com');
    final credential = oAuthProvider.credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
    );
    final authResult =
        await FirebaseAuth.instance.signInWithCredential(credential);
    return authResult.user;
  } on Exception {
    return null;
  } finally {
    await EasyLoading.dismiss();
  }
}
