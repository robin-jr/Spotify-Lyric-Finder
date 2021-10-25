import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotify_lyric_finder/controllers/home_controller.dart';
import 'package:spotify_lyric_finder/controllers/playback_controller.dart';

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
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          // color: Color.fromRGBO(50, 50, 50, 1),
          color: Colors.deepPurple[700] ?? Colors.deepPurple,
          blurRadius: 2.0,
        ),
      ], borderRadius: BorderRadius.all(Radius.circular(25))),
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
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
    );
  }
}
