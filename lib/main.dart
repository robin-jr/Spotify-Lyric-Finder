import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_lyric_finder/utils/genius.dart';
import 'package:spotify_lyric_finder/screens/signIn_page.dart';
import 'package:spotify_lyric_finder/screens/signUp_page.dart';
import 'package:spotify_lyric_finder/utils/spotify.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

import 'authentication_service.dart';

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
        title: 'Spotify Lyric Finder Title',
        theme: ThemeData(
          primarySwatch: Colors.blue,
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
      return (MyHomePage(title: 'Spotify Lyric Finder'));
    } else {
      return (LoginScreen());
    }
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _currentSong = "Click search";
  String _lyrics = "";

  @override
  void initState() {
    super.initState();
    connectToSpotify();
  }

  void _getCurrentSong() async {
    var state = await SpotifySdk.getPlayerState();
    var song = state!.track!.name;
    var artist = state.track!.artist.name;
    String query = song + " " + artist;
    setState(() {
      _currentSong = song + " by " + artist;
      _lyrics = "Loading...";
    });
    try {
      print("query--> $query");
      var lyrics = await getLyrics(query, context);
      // print("from home--> $lyrics");
      print(lyrics);
      setState(() {
        _lyrics = lyrics;
      });
    } catch (e) {
      print("Error happened fetching lyrics --> $e");
    }
    print("Spotify Song is: $song");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '$_currentSong',
              style: Theme.of(context).textTheme.headline6,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  '$_lyrics',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () async => await Provider.of<AuthenticationService>(
                        context,
                        listen: false)
                    .signOut(),
                child: Text('Sign Out')),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            _getCurrentSong();
            print("pressed");
          } catch (e) {
            print("Exception --> $e");
          }
        },
        tooltip: 'Search Lyrics',
        child: Icon(Icons.search),
      ),
    );
  }
}
