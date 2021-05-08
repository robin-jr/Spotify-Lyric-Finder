import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;

Future<String> getLyrics(String query, BuildContext context) async {
  Uri q = Uri.parse('http://api.genius.com/search?q=$query');
  var res = await http.get(q, headers: {
    'Authorization':
        'Bearer Np2bVZn6hIKqkQV35waMG8xdhcpSSdihqjf8FPOMVrniFhoJc-rM9hPMnYNGN34K'
  });

  var parsedRes = jsonDecode(res.body);
  String lyricsUrl = parsedRes['response']['hits'][0]['result']['url'];

  final response = await http.get(Uri.parse(lyricsUrl));
  var document = parse(response.body);
  var lyricsElement = document.getElementsByClassName("lyrics");
  var songElement = document.getElementsByClassName("song_body-lyrics");
  String lyrics = '';
  lyricsElement.forEach((element) {
    lyrics += element.text;
  });
  String song = "";
  songElement.forEach((element) {
    song += element.text;
  });
  print("url --> $lyricsUrl");
  print("song --> $song");
  print("res--> $response");
  // log(response.body);
  print("doc--> $document");
  if (response.body.contains('class="lyrics"')) {
    print("contains the lyrics");
    print("body --> ${response.body}");
  }
  print("ele--> $lyricsElement");
  print("not --> $lyrics");
  return lyrics;
}
