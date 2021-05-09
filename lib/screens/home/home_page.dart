import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:spotify_lyric_finder/models/lyric.dart';
import 'package:spotify_lyric_finder/utils/genius.dart';
import 'package:spotify_lyric_finder/utils/spotify.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

import '../../authentication_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _currentSong = "Not yet Searched!";
  String _lyrics = "";
  String _lyricsUrl = "";

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
      _lyricsUrl = "";
    });
    try {
      print("query--> $query");
      Lyrics lyrics = await getLyrics(query);
      print("from home--> ${lyrics.lyrics}");
      setState(() {
        _lyrics = lyrics.lyrics;
        _lyricsUrl = lyrics.url;
      });
    } catch (e) {
      print("Error happened fetching lyrics --> $e");
      Fluttertoast.showToast(msg: "Something unexpected happened");
    }
    print("Spotify Song is: $song");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
            text: "Lyrics Finder ",
            children: [
              TextSpan(
                text: " Search by Spotify",
                style: TextStyle(fontSize: 8, fontWeight: FontWeight.w300),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            iconSize: 22,
            onPressed: () async =>
                await Provider.of<AuthenticationService>(context, listen: false)
                    .signOut(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      EdgeInsets.only(bottom: 10, top: 10, left: 5, right: 5),
                  child: Text(
                    "$_currentSong",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(bottom: 10, top: 1, left: 5, right: 1),
                  child: Text(
                    "$_lyricsUrl",
                    style: Theme.of(context).textTheme.bodyText2,
                    textAlign: TextAlign.right,
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: SingleChildScrollView(
                    child: Text(
                      '$_lyrics',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: InkWell(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 5, right: 2),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      SizedBox(width: 5),
                      Text(
                        "Search",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                onTap: () async {
                  try {
                    _getCurrentSong();
                    print("pressed");
                  } catch (e) {
                    print("Exception --> $e");
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
