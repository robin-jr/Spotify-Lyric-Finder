import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../authentication_service.dart';

class SignUpScreen extends StatelessWidget {
  static String routeName = '/SignupScreen';
  late AuthenticationService _authenticationService;

  Future<void> _registerUser(String email, String password) async {
    print('Email: $email, Password: $password');
    UserCredential? userCredential =
        await _authenticationService.signUp(email: email, password: password);
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
    TextEditingController nameController = TextEditingController();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Signup"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          children: [
            Spacer(),
            Text(
              "Create Account!",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500),
            ),
            Spacer(),
            Container(
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                    ),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                    ),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                    ),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    //controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
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
                        "Sign Up",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    onTap: () {
                      _registerUser(
                          emailController.text, passwordController.text).then((value) => Navigator.pop(context));
                      emailController.text = passwordController.text = '';
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Have an Account?",
                        style: TextStyle(color: Colors.grey),
                      ),
                      TextButton(
                        child: Text(
                          "Sign In",
                          style: TextStyle(
                            fontSize: 18,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w500),
                        ),
                        onPressed: () => Navigator.pop(context),
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
