import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:spotify_lyric_finder/controllers/home_controller.dart';
import 'package:spotify_lyric_finder/screens/home/bottom_modal.dart';
import 'package:spotify_lyric_finder/utils/spotify.dart';

import '../../authentication_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    connectToSpotify();
  }

  Widget getLine(String line) {
    line = line.trim();
    if (line.isEmpty) {
      return Container(
        height: 40,
      );
    }
    return Container(
      height: 50,
      // color: const Color(0xffeeee00),
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        '$line',
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: line.characters.first == '['
                ? FontWeight.bold
                : FontWeight.normal),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.find<HomeController>();
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
            text: "Lyrics Finder ",
            children: [
              TextSpan(
                text: " Search by Spotify",
                style: TextStyle(fontSize: 8, fontWeight: FontWeight.w300),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                homeController.getCurrentSong();
              },
              icon: Icon(Icons.refresh)),
          IconButton(
            icon: Icon(Icons.logout),
            iconSize: 22,
            onPressed: () async =>
                await Provider.of<AuthenticationService>(context, listen: false)
                    .signOut(),
          ),
        ],
      ),
      body: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Expanded(
                      flex: 1,
                      child: SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: MediaQuery.of(context).size.height,
                          ),
                          child: Obx(
                            () => Column(
                              mainAxisSize: MainAxisSize.min,
                              // mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      bottom: 10, top: 10, left: 5, right: 5),
                                  child: Text(
                                    homeController.currentSong.toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 100),
                                  child:
                                      Divider(color: Colors.white, height: 20),
                                ),
                                ...homeController.lyrics
                                    .trim()
                                    .split('\n')
                                    .map((line) => getLine(line))
                                    .toList()
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: InkWell(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 5, right: 10),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 10,
                          color: Color.fromRGBO(200, 200, 200, 0.25),
                        )
                      ],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.expand_more,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  onTap: () async {
                    showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.black12,
                        builder: (_) => BottomModal());
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
