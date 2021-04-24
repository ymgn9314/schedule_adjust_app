// https://firebase.flutter.dev/docs/auth/social/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:high_hat/util/user_data.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

Future<UserCredential?> signInWithGoogle() async {
  await EasyLoading.show();

  print('signInWithGoogle()');

  try {
    print('try in signInWithGoogle()');
    final googleLogin = GoogleSignIn(scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ]);
    // Trigger the authentication flow
    final googleUser = await googleLogin.signIn();
    if (googleUser == null) {
      return null;
    }
    // Obtain the auth details from the request
    final googleAuth = await googleUser.authentication;
    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    // Once signed in, return the UserCredential
    return FirebaseAuth.instance.signInWithCredential(credential);
  } catch (e) {
    print('catch error in signInWithGoogle()');
    return null;
  } finally {
    await EasyLoading.dismiss();
  }
}

Future<UserData?> signInWithApple() async {
  await EasyLoading.show();
  print('signInWithApple()');

  try {
    print('try in signInWithApple()');
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
    final user = FirebaseAuth.instance.currentUser;
    // 初回ログイン時
    if (appleCredential.givenName != null) {
      return UserData(
          uid: user!.uid,
          displayName:
              '${appleCredential.familyName} ${appleCredential.givenName}',
          photoUrl: '');
    }
    // firestoreからユーザー情報を取得する
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      final exists = doc.exists;
      print(
        'try in get apple signin user data(uid: ${user.uid}, exists: $exists)',
      );

      final disp = doc.get('displayName') as String;
      print(disp);

      return UserData(
        uid: doc.id,
        displayName: doc.get('displayName') as String,
        photoUrl: doc.get('photoUrl') as String,
      );
    } catch (e) {
      print('catch error in get apple signin user data.');
      final user = FirebaseAuth.instance.currentUser;
      return UserData(
        uid: user!.uid,
        displayName: '不明なユーザー',
        photoUrl: '',
      );
    }
  } catch (e) {
    print('catch error in signInWithApple()');
    return null;
  } finally {
    await EasyLoading.dismiss();
  }
}
