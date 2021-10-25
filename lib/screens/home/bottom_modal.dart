import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotify_lyric_finder/controllers/home_controller.dart';
import 'package:spotify_lyric_finder/controllers/playback_controller.dart';
import 'package:spotify_lyric_finder/utils/spotify.dart';

class BottomModal extends StatefulWidget {
  @override
  _BottomModalState createState() => _BottomModalState();
}

class _BottomModalState extends State<BottomModal> {
  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.find<HomeController>();
    PlaybackController playbackController = Get.find<PlaybackController>();
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Color.fromRGBO(50, 50, 50, 1),
          offset: Offset(0.0, 1.0), //(x,y)
          blurRadius: 5.0,
        ),
      ], borderRadius: BorderRadius.vertical(top: Radius.circular(2))),
      height: 150,
      child: Container(
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    padding: EdgeInsets.all(0),
                    onPressed: () async {
                      await playbackController.switchPreviousSong();
                      homeController.getCurrentSong();
                    },
                    icon: Icon(
                      Icons.arrow_left,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  Obx(
                    () => IconButton(
                      padding: EdgeInsets.all(0),
                      onPressed: () async {
                        await playbackController.togglePlayback();
                      },
                      icon: Icon(
                        playbackController.isPlaying.value
                            ? Icons.pause_circle
                            : Icons.play_arrow,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    padding: EdgeInsets.all(0),
                    onPressed: () async {
                      await playbackController.switchNextSong();
                      homeController.getCurrentSong();
                    },
                    icon: Icon(
                      Icons.arrow_right,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: IconButton(
                padding: EdgeInsets.all(0),
                onPressed: () {
                  homeController.getCurrentSong();
                },
                icon: Icon(
                  Icons.refresh,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
