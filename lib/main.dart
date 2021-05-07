import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:spotify_lyric_finder/genius.dart';
import 'package:spotify_lyric_finder/screens/signIn_page.dart';
import 'package:spotify_lyric_finder/screens/signUp_page.dart';
import 'package:spotify_lyric_finder/screens/webpage.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

import 'authentication_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

final String SPOTIFY_CLIENT_ID = "02b37193307e4b93877c93e0ab495f14";
final String SPOTIFY_CLIENT_SECRET = "84648a0b18f54dbe83d7bca3e2d4299e";
final String SPOTIFY_REDIRECT_URL = "https://www.google.com/";

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
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
          WebScreen.routeName: (context) => WebScreen(),
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
  int _counter = 0;
  String currentSong = "";

  @override
  void initState() {
    super.initState();
    connectToSpotify();
  }

  void connectToSpotify() async {
    try {
      bool isConnected = await SpotifySdk.connectToSpotifyRemote(
          clientId: SPOTIFY_CLIENT_ID,
          redirectUrl: SPOTIFY_REDIRECT_URL,
          scope: 'user-read-currently-playing');
      if (isConnected) {
        Fluttertoast.showToast(msg: "Connected to Spotify");
        print("Connected to spotify");
      } else {
        Fluttertoast.showToast(msg: "Couldn't connect to spotify");
        print("Couldn't connect to spotify");
      }
    } catch (e) {
      print("Error connecting to Spotify $e");
    }
  }

  void _getCurrentSong() async {
    var state = await SpotifySdk.getPlayerState();
    var song = state!.track!.name;
    var artist = state.track!.artist.name;
    String query = song + " " + artist;
    setState(() {
      currentSong = song + " by " + artist;
    });
    try {
      print("query--> $query");
      var lyrics = await getLyrics(query, context);
      print("from home--> $lyrics");
      print(lyrics);
      setState(() {
        currentSong = lyrics;
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
              '$currentSong',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
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
