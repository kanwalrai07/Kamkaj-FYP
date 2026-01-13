import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  
  Future<User?> googleLogin() async {
    print("googleLogin method Called");
    GoogleSignIn _googleSignIn = GoogleSignIn();
    try {
      await _googleSignIn.signOut(); // Force account picker
      var result = await _googleSignIn.signIn();
      if (result == null) {
        return null;
      }
      
      final userData = await result.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: userData.accessToken, idToken: userData.idToken);
      var finalResult =
          await FirebaseAuth.instance.signInWithCredential(credential);
      
      print("Result $result");
      print(result.displayName);
      print(result.email);
      print(result.photoUrl);

      return finalResult.user;

    } catch (error) {
      print("Google Sign In Error: $error");
      print("Stack Trace: ${StackTrace.current}");
      rethrow;
    }

  }

  Future<void> logout() async {
    await GoogleSignIn().disconnect();
    await FirebaseAuth.instance.signOut();
  }
}
