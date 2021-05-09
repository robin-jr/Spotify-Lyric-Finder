import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/home/home_page.dart';
import './screens/signIn_page.dart';
import './screens/signUp_page.dart';
import './authentication_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) =>
              context.read<AuthenticationService>().onAuthStateChanged,
          initialData: null,
        ),
      ],
      child: MaterialApp(
        title: 'Spotify Lyric Finder',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          primaryColor:Color(0xff3B485B),
          inputDecorationTheme: InputDecorationTheme(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xff3B485B),
                    width: 2,
              ),
            ),
          ),
        ),
        // home: MyHomePage(title: 'Flutter Demo Home Page'),
        home: AuthenticationWrapper(),
        routes: {
          LoginScreen.routeName: (context) => LoginScreen(),
          SignUpScreen.routeName: (context) => SignUpScreen(),
        },
      ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var firebaseUser = context.watch<User?>();
    if (firebaseUser != null) {
      return (HomePage());
    } else {
      return (LoginScreen());
    }
  }
}


