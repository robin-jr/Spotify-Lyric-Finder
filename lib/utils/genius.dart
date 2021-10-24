import 'dart:async';
import 'dart:convert';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'package:spotify_lyric_finder/models/lyric.dart';
import 'package:spotify_lyric_finder/utils/database.dart';

Future<String?> getLyricUrl(
    String query, String artistName, String song) async {
  Uri q = Uri.parse('http://api.genius.com/search?q=$query');
  var res = await http.get(q, headers: {
    'Authorization':
        'Bearer Np2bVZn6hIKqkQV35waMG8xdhcpSSdihqjf8FPOMVrniFhoJc-rM9hPMnYNGN34K'
  });

  var parsedRes = jsonDecode(res.body);
  String? lyricsUrl;
  for (var hit in parsedRes['response']['hits']) {
    print("check --> ${hit['result']['title']}, $query");
    if (hit['result']['primary_artist']['name']
            .toLowerCase()
            .contains(artistName.toLowerCase()) &&
        hit['result']['title'].toLowerCase().contains(song.toLowerCase())) {
      lyricsUrl = hit['result']['url'];
      break;
    }
  }
  print("url --> $lyricsUrl");
  return lyricsUrl;
}

Future<String?> extractLyrics(String url) async {
  int i = 0;
  var lyricsElement = [];
  String lyrics = '';
  while (i < 5) {
    i++;
    var response = await http.get(Uri.parse(url));
    lyricsElement = parse(response.body).getElementsByClassName("lyrics");
    if (lyricsElement.isNotEmpty) {
      print("Got lyrics");
      break;
    }
    print("contains sh** $i");
  }
  if (lyricsElement.isNotEmpty) {
    lyricsElement.forEach((element) {
      lyrics += element.text;
    });
  } else {
    return null;
  }
  return lyrics;
}

Future<Lyrics> getLyrics(String artist, String song) async {
  String query = song + " " + artist;
  Lyrics? cacheLyrics = await getLyricsFromDatabase(query);
  if (cacheLyrics != null) {
    return cacheLyrics;
  }
  String? lyrics;
  String? lyricsUrl = await getLyricUrl(query, artist, song);

  if (lyricsUrl == null) {
    lyrics = "Lyrics not found";
    return Lyrics(query, '', lyrics);
  }
  lyrics = await extractLyrics(lyricsUrl);
  if (lyrics == null) {
    lyrics = "Could not get Lyrics (Check your internet Connection)";
  } else {
    await insertLyrics(Lyrics(query, lyricsUrl, lyrics));
  }
  return Lyrics(query, lyricsUrl, lyrics);
}
