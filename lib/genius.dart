import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:path_provider/path_provider.dart';
import 'package:uni_links2/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;

final String GENIUS_CLIENT_ID =
    "oBLcEA_3qg0sRcx6EEz1HIfUeDBGqdl9YazXNSbZuh3vAeMxpHSGsH1QGLi0KWw5";
final String GENIUS_CLIENT_SECRET =
    "tEW0S5sSNZqbe4gzEX9z4WAU51aC_qfZMFuV6IZyq7ot6ZrJOBHm3EwM3hVYdfGQ5D0p9wjXfNB56LukoBdQHA";
final String GENIUS_REDIRECT_URL = "https://spotify-lyric-finder.com";
final authorizationEndpoint =
    Uri.parse('https://api.genius.com/oauth/authorize');
final tokenEndpoint = Uri.parse('https://api.genius.com/oauth/token');
final identifier = GENIUS_CLIENT_ID;
final secret = GENIUS_CLIENT_SECRET;
final redirectUrl = Uri.parse(GENIUS_REDIRECT_URL);
late File credentialsFile;
var responseUrl;

Future<oauth2.Client> createClient(BuildContext context) async {
  var exists = await credentialsFile.exists();
  if (exists) {
    var credentials =
        oauth2.Credentials.fromJson(await credentialsFile.readAsString());
    return oauth2.Client(credentials, identifier: identifier, secret: secret);
  }
  var grant = oauth2.AuthorizationCodeGrant(
      identifier, authorizationEndpoint, tokenEndpoint,
      secret: secret);
  var authorizationUrl = grant.getAuthorizationUrl(redirectUrl);

  await launch(authorizationUrl.toString());
  await initUniLinks(grant, context);

  return await grant.handleAuthorizationResponse(responseUrl.queryParameters);
}

Future<void> initUniLinks(
    oauth2.AuthorizationCodeGrant grant, BuildContext context) async {
  StreamSubscription _sub;
  _sub = linkStream.listen((String? link) {
    print("Link --> $link");
  }, onError: (err) {
    print("Error --> $err");
  });
  _sub.onData((data) async {
    print("Data --> $data");
    responseUrl = Uri.parse(data.toString());
    print("Data --> $responseUrl");

    var client =
        await grant.handleAuthorizationResponse(responseUrl.queryParameters);
    await credentialsFile.writeAsString(client.credentials.toJson());
    _sub.cancel();
  });
}

Future<String> getLyrics(String query, BuildContext context) async {
  var dir = await getApplicationDocumentsDirectory();
  var path = dir.path;

  credentialsFile = File('$path/credentials.json');
  var client = await createClient(context);
  String res =
      await client.read(Uri.parse('http://api.genius.com/search?q=$query'));

  var parsedRes = jsonDecode(res);
  String lyricsUrl = parsedRes['response']['hits'][0]['result']['url'];

  final response = await http.get(Uri.parse(lyricsUrl));
  var document = parse(response.body);
  var lyricsElement = document.getElementsByClassName("lyrics");
  String lyrics = '';
  lyricsElement.forEach((element) {
    lyrics += element.text;
  });

  await credentialsFile.writeAsString(client.credentials.toJson());
  return lyrics;
}
