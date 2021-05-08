import 'package:fluttertoast/fluttertoast.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

final String SPOTIFY_CLIENT_ID = "02b37193307e4b93877c93e0ab495f14";
final String SPOTIFY_CLIENT_SECRET = "84648a0b18f54dbe83d7bca3e2d4299e";
final String SPOTIFY_REDIRECT_URL = "https://www.google.com/";

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
