import 'package:firebase_auth/firebase_auth.dart';

class PhoneAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? _verificationId;

  Future<void> sendOTP(String phoneNumber) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),

      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        print("Auto verification successful!");
      },

      verificationFailed: (FirebaseAuthException e) {
        print("Verification failed: ${e.message}");
      },

      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        print("OTP sent successfully!");
      },

      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  Future<UserCredential?> verifyOTP(String otp) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      print("OTP Verified Successfully!");
      return userCredential;
    } catch (e) {
      print("Invalid OTP: $e");
      return null;
    }
  }
}
