import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;
  AuthenticationService(this._firebaseAuth);

  Stream<User?> get onAuthStateChanged => _firebaseAuth.authStateChanges();

  Future<UserCredential?> signIn(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      print("user signed in ${userCredential.user!.uid}");
      return userCredential;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<UserCredential?> signUp(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      print("user signed up ${userCredential.user!.uid}");
      return userCredential;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      Fluttertoast.showToast(msg: "Signed Out");
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "Failed");
    }
  }
}
