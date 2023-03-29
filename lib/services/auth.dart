import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:today/screens/homepage.dart';

class Auth {
  // function to implement the google signin

  // creating firebase instance
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<UserCredential> signInWithGoogle(BuildContext context) async {
    GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );

    GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleAuth?.idToken,
      accessToken: googleAuth?.accessToken,
    );

    //OPTIONAL: Getting users credential
    UserCredential result = await auth.signInWithCredential(credential);
    User? user = result.user;
    print(user);

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
