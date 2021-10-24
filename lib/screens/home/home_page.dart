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
    setState(() {
      _currentSong = song + " by " + artist;
      _lyrics = "Loading...";
      _lyricsUrl = "";
    });
    try {
      print("query--> $artist $song");
      Lyrics lyrics = await getLyrics(artist, song);
      print("from home--> ${lyrics.lyrics}");
      setState(() {
        _lyrics = lyrics.lyrics;
        _lyricsUrl = lyrics.url;
      });
    } catch (e) {
      print("Error happened fetching lyrics --> $e");
      setState(() {
        _lyrics = "Something unexpected happened";
        _lyricsUrl = '';
      });
      Fluttertoast.showToast(msg: "Something unexpected happened");
    }
    print("Spotify Song is: $song");
  }

  Widget getLine(String line) {
    line = line.trim();
    if (line.isEmpty) {
      return Container(
        height: 60,
      );
    }
    return Container(
      height: 60,
      // color: const Color(0xffeeee00),
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        '$line',
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: line.characters.first == '['
                ? FontWeight.bold
                : FontWeight.normal),
      ),
    );
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
      body: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Expanded(
                      flex: 1,
                      child: SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: MediaQuery.of(context).size.height,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            // mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    bottom: 10, top: 10, left: 5, right: 5),
                                child: Text(
                                  "$_currentSong",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 26),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 100),
                                child: Divider(color: Colors.white, height: 20),
                              ),
                              ..._lyrics
                                  .trim()
                                  .split('\n')
                                  .map((line) => getLine(line))
                                  .toList()
                            ],
                          ),
                        ),
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
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
      ),
    );
  }
}
