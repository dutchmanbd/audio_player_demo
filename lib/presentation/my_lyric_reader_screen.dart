import 'dart:async';
import 'dart:convert';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:audio_player_demo/data/models/lyric_dto.dart';
import 'package:audio_player_demo/domain/models/lyric.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';

class MyLyricReaderScreen extends StatefulWidget {
  final String assetPath;
  final String lyricPath;
  const MyLyricReaderScreen({
    super.key,
    required this.assetPath,
    required this.lyricPath,
  });

  @override
  State<MyLyricReaderScreen> createState() => _MyLyricReaderScreenState();
}

class _MyLyricReaderScreenState extends State<MyLyricReaderScreen> {
  List<List<Lyric>> lyrics = [];
  AudioPlayer? audioPlayer;
  double playProgress = 0.0;
  double maxValue = 211658;
  bool playing = false;
  ScrollController scrollController = ScrollController(
    initialScrollOffset: 100,
    keepScrollOffset: true,
  );
  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {});

    readJson();
  }

  @override
  void dispose() {
    scrollController.dispose();
    audioPlayer?.dispose();
    audioPlayer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: lyrics.length,
                itemBuilder: (_, index) {
                  return Wrap(
                    children: List.generate(
                      lyrics[index].length,
                      (innerIndex) {
                        // debugPrint(
                        //     "playProgress: $playProgress, s: ${lyrics[index].startTime}, e: ${lyrics[index].endTime}");
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 5),
                          child: Text(
                            lyrics[index][innerIndex].lyric,
                            style: TextStyle(
                              color: playProgress >
                                          lyrics[index][innerIndex].startTime &&
                                      playProgress <=
                                          lyrics[index][innerIndex].endTime
                                  ? Colors.amber
                                  : Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ...buildPlayControl(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> buildPlayControl() {
    return [
      Container(
        height: 20,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () async {
              if (audioPlayer == null) {
                audioPlayer = AudioPlayer();
                audioPlayer?.setAsset(widget.assetPath);
                audioPlayer?.play();
                setState(() {
                  playing = true;
                });
                audioPlayer?.durationStream.listen((event) {
                  setState(() {
                    maxValue = event?.inSeconds.toDouble() ?? maxValue;
                    // myDuration = event ?? myDuration;
                    // startTimer();
                  });
                });
                // audioPlayer?.onDurationChanged.listen((Duration event) {
                //   setState(() {
                //     maxValue = event.inMilliseconds.toDouble();
                //   });
                // });

                audioPlayer?.positionStream.listen((event) {
                  // if (isTap) return;
                  setState(() {
                    // sliderProgress = event.inMilliseconds.toDouble();
                    playProgress = event.inMilliseconds / 1000.0;
                    // debugPrint("playProgress mili: ${event.inMilliseconds}");
                    debugPrint(
                        "playProgress seconds: ${event.inMilliseconds / 1000.0}");
                  });
                });
                // audioPlayer?.onPositionChanged.listen((Duration event) {
                //   if (isTap) return;
                //   setState(() {
                //     sliderProgress = event.inMilliseconds.toDouble();
                //     playProgress = event.inMilliseconds;
                //   });
                // });

                audioPlayer?.playerStateStream.listen((state) {
                  setState(() {
                    playing = state.playing;
                  });
                });

                // audioPlayer?.onPlayerStateChanged.listen((PlayerState state) {
                //   setState(() {
                //     playing = state == PlayerState.playing;
                //   });
                // });
              } else {
                audioPlayer?.play();
              }
            },
            child: const Text("Play"),
          ),
          Container(
            width: 10,
          ),
          TextButton(
              onPressed: () async {
                audioPlayer?.pause();
              },
              child: const Text("Pause")),
          Container(
            width: 10,
          ),
          TextButton(
              onPressed: () async {
                audioPlayer?.stop();
                audioPlayer = null;
              },
              child: const Text("Stop")),
        ],
      ),
    ];
  }

  Future<void> readJson() async {
    final response = await rootBundle.loadString(widget.lyricPath);
    List<dynamic> lyricDtos = json.decode(response);
    List<List<Lyric>> mLyrics = [];
    for (var dtos in lyricDtos) {
      dtos as List<dynamic>;
      List<Lyric> line = [];

      for (var dto in dtos) {
        dto as Map<String, dynamic>;
        final lyric = LyricDto.fromJson(dto);
        line.add(lyric.toLyric());
      }
      mLyrics.add(line);
    }

    setState(() {
      lyrics = mLyrics;
    });
  }
}
