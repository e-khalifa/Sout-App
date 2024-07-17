import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

class SongTile extends StatefulWidget {
  final Audio audio;
  const SongTile({required this.audio, super.key});

  @override
  State<SongTile> createState() => _SongTileState();
}

class _SongTileState extends State<SongTile> {
  final assetsAudioPlayer = AssetsAudioPlayer();

  @override
  void initState() {
    assetsAudioPlayer.open(widget.audio, autoStart: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        child: Image.asset(assetsAudioPlayer.getCurrentAudioImage!.path),
      ),
      title: Text(
        assetsAudioPlayer.getCurrentAudioTitle == ''
            ? 'No Songs Found'
            : assetsAudioPlayer.getCurrentAudioTitle,
        style: const TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
          assetsAudioPlayer.getCurrentAudioArtist == ''
              ? ''
              : assetsAudioPlayer.getCurrentAudioArtist,
          style: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 14,
          )),
      trailing: getSongDuration(),
    );
  }

  StreamBuilder<RealtimePlayingInfos> getSongDuration() {
    return StreamBuilder(
      stream: assetsAudioPlayer.realtimePlayingInfos,
      builder: (context, snapshots) {
        if (snapshots.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.grey.shade400,
            ),
          );
        }

        return Text(
          formatDuration(snapshots.data?.duration.inSeconds ?? 0),
        );
      },
    );
  }

  String formatDuration(int durationInSec) {
    String minutes = (durationInSec ~/ 60).toString();
    String seconds = (durationInSec % 60).toString();
    return '${minutes.padLeft(2, '0')}:${seconds.padLeft(2, '0')}';
  }
}
