import 'dart:convert';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:taqreeb/firebase_options.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<Map<String, dynamic>> signInWithGoogle() async {
    try {
      // Trigger Google Sign-In
      await googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) return {};

      // Obtain authentication details from Google
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create credential for Firebase
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;
      print('done');
      final response = await http.get(
        Uri.parse(
            "https://people.googleapis.com/v1/people/me?personFields=phoneNumbers,genders,birthdays,emailAddresses"),
        headers: {
          "Authorization": "Bearer ${googleAuth.accessToken}",
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final phone, gender, age;
        if (data.containsKey('phoneNumbers')) {
          final phoneNumber = data['phoneNumbers'][0]['value'];
          phone = phoneNumber;
        } else {
          phone = null;
        }
        if (data.containsKey('genders')) {
          gender = data['genders'][0]['value'];
        } else {
          gender = null;
        }
        if (data.containsKey('birthdays')) {
          DateTime birthDate = DateTime(
              data['birthdays'][0]['date']['year'],
              data['birthdays'][0]['date']['month'],
              data['birthdays'][0]['date']['day']);
          DateTime today = DateTime.now();

          int tempage = today.year - birthDate.year;

          if (today.month < birthDate.month ||
              (today.month == birthDate.month && today.day < birthDate.day)) {
            tempage--;
          }
          age = tempage;
        } else {
          age = null;
        }
        final mydata = {
          'age': age,
          'gender': gender,
          'phone': phone,
          'user': user
        };
        return mydata;
      } else {
        print("Error fetching additional details ${response.statusCode}");
        return {};
      }
    } catch (e) {
      print("Error signing in with Google: $e");
      return {};
    }
  }

  Future<UserCredential?> signInWithFacebook() async {
    try {
      signOutFB();
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: [
          'email',
          'public_profile',
          'user_birthday',
          'user_location'
        ],
      );

      if (result.status == LoginStatus.success) {
        final OAuthCredential credential =
            FacebookAuthProvider.credential(DefaultFirebaseOptions.accessToken);
        final userCredential = await _auth.signInWithCredential(credential);
        final userData = await FacebookAuth.instance.getUserData(
          fields:
              "name,email,picture.width(200).height(200),birthday,gender,location",
        );
        print('User data: $userData');
        print('User credential: $userCredential');
        return userCredential;
      }
    } catch (e) {
      print("Facebook login error: $e");
    }
    return null;
  }

  Future<void> signOutFB() async {
    try {
      await FacebookAuth.instance.logOut();
      await FirebaseAuth.instance.signOut();
      print("Logged out successfully");
    } catch (e) {
      print("Error logging out: $e");
    }
  }

  Future<void> signOut() async {
    await googleSignIn.signOut();
    await _auth.signOut();
  }
}
