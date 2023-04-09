import 'dart:ui';

import 'package:audio_player_demo/presentation/my_lyric_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lyric/lyrics_model_builder.dart';
import 'package:flutter_lyric/lyrics_reader_model.dart';
import 'package:flutter_lyric/lyrics_reader_widget.dart';
import 'package:just_audio/just_audio.dart';

class PlayerScreen extends StatefulWidget {
  final String normalLyric;
  final String assetPath;
  const PlayerScreen({
    super.key,
    required this.assetPath,
    required this.normalLyric,
  });

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  AudioPlayer? audioPlayer;
  double sliderProgress = 111658;
  int playProgress = 111658;
  double max_value = 211658;
  bool isTap = false;

  bool useEnhancedLrc = false;
  LyricsReaderModel get lyricModel => LyricsModelBuilder.create()
      .bindLyricToMain(widget.normalLyric)
      // .bindLyricToExt(transLyric)
      .getModel();

  var lyricUI = MyLyricUI();

  @override
  void dispose() {
    audioPlayer?.dispose();
    audioPlayer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Audio Player"),
      ),
      body: buildContainer(),
    );
  }

  Widget buildContainer() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildReaderWidget(),
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
    );
  }

  List<Widget> buildPlayControl() {
    return [
      Container(
        height: 20,
      ),
      Text(
        "Progress:$sliderProgress",
        style: const TextStyle(
          fontSize: 16,
          color: Colors.green,
        ),
      ),
      if (sliderProgress < max_value)
        Slider(
          min: 0,
          max: max_value,
          label: sliderProgress.toString(),
          value: sliderProgress,
          activeColor: Colors.blueGrey,
          inactiveColor: Colors.blue,
          onChanged: (double value) {
            setState(() {
              sliderProgress = value;
            });
          },
          onChangeStart: (double value) {
            isTap = true;
          },
          onChangeEnd: (double value) {
            isTap = false;
            setState(() {
              playProgress = value.toInt();
            });
            audioPlayer?.seek(Duration(milliseconds: value.toInt()));
          },
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
                    max_value = event?.inMilliseconds.toDouble() ?? max_value;
                  });
                });
                // audioPlayer?.onDurationChanged.listen((Duration event) {
                //   setState(() {
                //     max_value = event.inMilliseconds.toDouble();
                //   });
                // });
                audioPlayer?.positionStream.listen((event) {
                  if (isTap) return;
                  setState(() {
                    sliderProgress = event.inMilliseconds.toDouble();
                    playProgress = event.inMilliseconds;
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
                audioPlayer?.pause();
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
              child: Text("Stop")),
        ],
      ),
    ];
  }

  var lyricPadding = 40.0;
  var playing = false;
  Stack buildReaderWidget() {
    return Stack(
      children: [
        ...buildReaderBackground(),
        LyricsReader(
          padding: EdgeInsets.symmetric(horizontal: lyricPadding),
          model: lyricModel,
          position: playProgress,
          lyricUi: lyricUI,
          playing: playing,
          size: Size(double.infinity, MediaQuery.of(context).size.height / 2),
          emptyBuilder: () => Center(
            child: Text(
              "No lyrics",
              style: lyricUI.getOtherMainTextStyle(),
            ),
          ),
          selectLineBuilder: (progress, confirm) {
            return Row(
              children: [
                IconButton(
                  onPressed: () {
                    // LyricsLog.logD("点击事件");
                    confirm.call();
                    setState(() {
                      audioPlayer?.seek(
                        Duration(milliseconds: progress),
                      );
                    });
                  },
                  icon: const Icon(
                    Icons.play_arrow,
                    color: Colors.green,
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.green,
                    ),
                    height: 1,
                    width: double.infinity,
                  ),
                ),
                Text(
                  progress.toString(),
                  style: const TextStyle(
                    color: Colors.green,
                  ),
                )
              ],
            );
          },
        )
      ],
    );
  }

  List<Widget> buildReaderBackground() {
    return [
      Positioned.fill(
        child: Image.asset(
          "assets/images/bg.jpeg",
          fit: BoxFit.cover,
        ),
      ),
      Positioned.fill(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: Colors.black.withOpacity(0.3),
          ),
        ),
      )
    ];
  }
}
