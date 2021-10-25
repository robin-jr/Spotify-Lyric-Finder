import 'package:get/get.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

class PlaybackController extends GetxController {
  RxBool isPlaying = false.obs;

  @override
  onInit() {
    super.onInit();
    SpotifySdk.getPlayerState().then((value) {
      isPlaying.value = !value!.isPaused;
    });
  }

  togglePlayback() async {
    if (isPlaying.value) {
      await SpotifySdk.pause();
    } else {
      await SpotifySdk.resume();
    }
    isPlaying.value = !isPlaying.value;
  }

  switchNextSong() async {
    await SpotifySdk.skipNext();
  }

  switchPreviousSong() async {
    await SpotifySdk.skipPrevious();
  }
}
