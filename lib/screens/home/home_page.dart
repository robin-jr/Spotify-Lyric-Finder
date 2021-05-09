import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
            onPressed: () async => await Provider.of<AuthenticationService>(
                context,
                listen: false)
                .signOut(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                Spacer(),
                Text(
                  "$_currentSong",
                  style: Theme.of(context).textTheme.headline6,
                ),
                Spacer(),
                Expanded(
                  flex:8,
                  child: SingleChildScrollView(
                    child: Text(
                      '$_lyrics',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment:Alignment.bottomRight,
                 child: InkWell(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 5,right: 2),
                      padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.search,color: Colors.white,),
                          SizedBox(width: 5),
                          Text("Search",style: TextStyle(color: Colors.white,fontSize: 16),),
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
