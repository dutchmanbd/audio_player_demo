import 'package:audio_player_demo/domain/models/lyric.dart';

class LyricDto {
  final String lyric;
  final double startTime;
  final double endTime;

  LyricDto(this.lyric, this.startTime, this.endTime);

  factory LyricDto.fromJson(Map<String, dynamic> json) => LyricDto(
        json["lyric"],
        double.parse(json["start_time"]),
        double.parse(json["end_time"]),
      );

  Map<String, dynamic> toJson() => {
        "lyric": lyric,
        "start_time": startTime,
        "end_time": endTime,
      };

  Lyric toLyric() => Lyric(
        lyric: lyric,
        startTime: startTime,
        endTime: endTime,
      );
}
