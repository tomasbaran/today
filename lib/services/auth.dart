import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:today/homepage.dart';

class Auth {
  // function to implement the google signin

// creating firebase instance
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> signup(BuildContext context) async {
    log('step0');
    // final GoogleSignIn googleSignIn = GoogleSignIn(
    //   scopes: [
    //     'email',
    //     'https://www.googleapis.com/auth/contacts.readonly',
    //   ],
    // );
    log('step1');

    try {
      log('step1.1');
      GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: [
          'email',
          'https://www.googleapis.com/auth/contacts.readonly',
        ],
      );
      log('step1.2');
      GoogleSignInAccount? account = await googleSignIn.signIn();
      log('step1.3');
      if (account != null) {
        log('result!=null', time: DateTime.now());

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
      } else {
        log('result==null', time: DateTime.now());
      }
    } catch (error) {
      print(error);
    }

    log('step1.1');

    // final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

    log('step2');
    // if (googleSignInAccount != null) {
    //   log('step3');
    //   final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
    //   final AuthCredential authCredential =
    //       GoogleAuthProvider.credential(idToken: googleSignInAuthentication.idToken, accessToken: googleSignInAuthentication.accessToken);
    //   log('step4');
    //   // Getting users credential
    //   UserCredential result = await auth.signInWithCredential(authCredential);
    //   User? user = result.user;
    //   log('step5');
    //   if (result != null) {
    //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    //   } // if result not null we simply call the MaterialpageRoute,
    //   // for go to the HomePage screen
    // }
  }
}
