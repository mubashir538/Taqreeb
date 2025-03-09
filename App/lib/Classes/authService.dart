import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<User?>   signInWithGoogle() async {
    try {
      // Trigger Google Sign-In
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) return null;

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

      return user;
    } catch (e) {
      print("Error signing in with Google: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>> getUserDetails() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      return {
        'Name': user.displayName,
        'Email': user.email,
        'Photo URL': user.photoURL
      };
    } else {
      return {};
    }
  }

  Future<void> getAdditionalUserInfo() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return;

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final response = await http.get(
      Uri.parse(
          "https://people.googleapis.com/v1/people/me?personFields=phoneNumbers,genders,birthdays"),
      headers: {
        "Authorization": "Bearer ${googleAuth.accessToken}",
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final mydata = {
        'Phone': data['phoneNumbers'][0]['value'],
        'Gender': data['genders'][0]['value'],
        'Age': data['birthdays'][0]['date']
      };
      } else {
      print("Error fetching additional details");
    }
  }


  Future<void> signOut() async {
    await googleSignIn.signOut();
    await _auth.signOut();
  }
}
