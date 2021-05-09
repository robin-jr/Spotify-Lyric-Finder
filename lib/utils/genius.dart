import 'dart:async';
import 'dart:convert';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'package:spotify_lyric_finder/models/lyric.dart';

Future<String> getLyricUrl(String query) async {
  Uri q = Uri.parse('http://api.genius.com/search?q=$query');
  var res = await http.get(q, headers: {
    'Authorization':
        'Bearer Np2bVZn6hIKqkQV35waMG8xdhcpSSdihqjf8FPOMVrniFhoJc-rM9hPMnYNGN34K'
  });

  var parsedRes = jsonDecode(res.body);
  String lyricsUrl = parsedRes['response']['hits'][0]['result']['url'];
  print("url --> $lyricsUrl");
  return lyricsUrl;
}

Future<String> extractLyrics(String url) async {
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
    lyrics = "Could not get Lyrics (Check your internet Connection)";
  }
  return lyrics;
}

Future<Lyrics> getLyrics(String query) async {
  String lyricsUrl = await getLyricUrl(query);
  String lyrics = await extractLyrics(lyricsUrl);

  return Lyrics(lyricsUrl, lyrics);
}
