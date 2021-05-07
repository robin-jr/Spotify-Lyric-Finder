import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:spotify_lyric_finder/screens/webpage.dart';
import 'package:uni_links2/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

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
late File credentialsFile; //TODO
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
  void funFunction(args) {
    print("hello");
  }

  print("responseUrl is --> $responseUrl");
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
    String query = "Hello Adelle";
    String res =
        await client.read(Uri.parse('http://api.genius.com/search?q=$query'));
    // print("Result is --> $res");
    print("below is the result");
    log(res);
    _sub.cancel();
  });
  print("outside uni");
  print("sub:  ${_sub}");

  // NOTE: Don't forget to call _sub.cancel() in dispose()
}

Future<String> getLyrics(String query, BuildContext context) async {
  var dir = await getApplicationDocumentsDirectory();
  var path = dir.path;
  credentialsFile = File('$path/credentials.json');
  var client = await createClient(context);
  String res =
      await client.read(Uri.parse('http://api.genius.com/search?q=$query'));

  print("The really long lyrics");
  log(res);
  await credentialsFile.writeAsString(client.credentials.toJson());
  return res;
}
