import 'package:get/get.dart';
import 'package:spotify_lyric_finder/models/lyric.dart';
import 'package:spotify_lyric_finder/utils/genius.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

class HomeController extends GetxController {
  RxString lyrics = "".obs;
  RxString currentSong = "Not searched yet".obs;
  RxString lyricsUrl = "".obs;

  void getCurrentSong() async {
    var state = await SpotifySdk.getPlayerState();
    var song = state!.track!.name;
    var artist = state.track!.artist.name;

    currentSong.value = song + " by " + artist;
    lyrics.value = "Loading...";
    lyricsUrl.value = "";

    try {
      Lyrics lyricsTemp = await getLyrics(artist, song);
      lyrics.value = lyricsTemp.lyrics;
      lyricsUrl.value = lyricsTemp.url;
    } catch (e) {
      print("Error happened fetching lyrics --> $e");

      lyrics.value = "Something unexpected happened";
      lyricsUrl.value = '';
      Get.snackbar(
        "Error",
        "Something unexpected happened",
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 1),
      );
      // Fluttertoast.showToast(msg: "Something unexpected happened");
    }
    print("Spotify Song is: $song");
  }
}
