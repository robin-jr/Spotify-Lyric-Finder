import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:spotify_lyric_finder/screens/signUp_page.dart';

import '../authentication_service.dart';

class LoginScreen extends StatelessWidget {
  static String routeName = '/LoginScreen';
  late AuthenticationService _authenticationService;
  Future<void> _authUser(String email, String password) async {
    print('Email: $email, Password: $password');
    UserCredential? userCredential =
        await _authenticationService.signIn(email: email, password: password);
    if (userCredential != null) {
      Fluttertoast.showToast(msg: "Logged In");
    } else {
      Fluttertoast.showToast(msg: "Failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    _authenticationService =
        Provider.of<AuthenticationService>(context, listen: false);
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Email',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: ElevatedButton(
                  onPressed: () {
                    _authUser(emailController.text, passwordController.text);
                    emailController.text = passwordController.text = '';
                  },
                  child: Text("Submit")),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, SignUpScreen.routeName);
                  },
                  child: Text("Sign UP")),
            ),
          ],
        ),
      ),
    );
  }
}
