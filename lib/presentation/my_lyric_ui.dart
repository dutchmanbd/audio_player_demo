import 'package:flutter/material.dart';
import 'package:flutter_lyric/lyric_ui/lyric_ui.dart';
import 'package:flutter_lyric/lyric_ui/ui_netease.dart';

class MyLyricUI extends UINetease {
  double mDefaultSize;
  double mDefaultExtSize;
  double mOtherMainSize;
  double mBias;
  double mLineGap;
  double mInlineGap;
  LyricAlign mLyricAlign;
  LyricBaseLine mLyricBaseLine;
  bool isHighlight;
  HighlightDirection mHighlightDirection;
  MyLyricUI({
    this.mDefaultSize = 18,
    this.mDefaultExtSize = 14,
    this.mOtherMainSize = 16,
    this.mBias = 0.5,
    this.mLineGap = 25,
    this.mInlineGap = 25,
    this.mLyricAlign = LyricAlign.CENTER,
    this.mLyricBaseLine = LyricBaseLine.CENTER,
    this.isHighlight = true,
    this.mHighlightDirection = HighlightDirection.LTR,
  }) : super(
            defaultSize: mDefaultSize,
            defaultExtSize: mDefaultExtSize,
            otherMainSize: mOtherMainSize,
            bias: mBias,
            lineGap: mLineGap,
            inlineGap: mInlineGap,
            lyricAlign: mLyricAlign,
            lyricBaseLine: mLyricBaseLine,
            highlight: isHighlight,
            highlightDirection: mHighlightDirection);
  @override
  TextStyle getOtherExtTextStyle() => TextStyle(
        color: Colors.grey[300],
        fontSize: defaultExtSize,
      );

  @override
  TextStyle getOtherMainTextStyle() =>
      TextStyle(color: Colors.grey[200], fontSize: otherMainSize);

  @override
  TextStyle getPlayingExtTextStyle() =>
      TextStyle(color: Colors.grey[300], fontSize: defaultExtSize);

  @override
  TextStyle getPlayingMainTextStyle() => TextStyle(
        color: Colors.white,
        fontSize: defaultSize,
      );
  @override
  Color getLyricHightlightColor() => const Color(0XFFFF612E);
}
