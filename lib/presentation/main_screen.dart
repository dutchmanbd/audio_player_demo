import 'package:audio_player_demo/presentation/my_lyric_reader_screen.dart';
import 'package:audio_player_demo/presentation/player_screen.dart';
import 'package:audio_player_demo/util/const.dart';
import 'package:flutter/material.dart';

import '../domain/models/song.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Song> songs = [
    Song(
      name: "If I Didn't Love You",
      assetPath: "assets/music/music1.mp3",
      subTitle: normalLyric,
      jsonPath: "",
    ),
    Song(
      name: "Small black but black criminal",
      assetPath: "assets/music/music2.mp3",
      subTitle: normalLyric2,
      jsonPath: "assets/json/lyrics.json",
    ),
    Song(
      name: "Yesterday",
      assetPath: "assets/music/music3.mp3",
      subTitle: normalLyric3,
      jsonPath: "assets/json/lyrics_1.json",
    )
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: ListView.builder(
            itemCount: songs.length,
            itemBuilder: (_, index) {
              return InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (builder) => Scaffold(
                      body: SafeArea(
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (songs[index].jsonPath.isNotEmpty)
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => MyLyricReaderScreen(
                                          assetPath: songs[index].assetPath,
                                          lyricPath: songs[index].jsonPath,
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text("JSON"),
                                ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => PlayerScreen(
                                        assetPath: songs[index].assetPath,
                                        normalLyric: songs[index].subTitle,
                                      ),
                                    ),
                                  );
                                },
                                child: const Text("Regular"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(songs[index].name),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
