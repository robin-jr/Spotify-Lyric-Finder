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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          children: [
            Spacer(),
            Text(
              "Welcome Back!",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500),
            ),
            Spacer(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                children: [
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Email',
                    ),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            Container(
              child: Column(
                children: [
                  InkWell(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadiusDirectional.circular(10),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Text(
                        "Sign In",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    onTap: () {
                      _authUser(emailController.text, passwordController.text);
                      emailController.text = passwordController.text = '';
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: TextStyle(color: Colors.grey),
                      ),
                      TextButton(
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            fontSize: 18,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w500),
                        ),
                        onPressed: () => Navigator.pushNamed(
                            context, SignUpScreen.routeName),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
