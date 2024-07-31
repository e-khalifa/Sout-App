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
  void dispose() {
    assetsAudioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(widget.audio.metas.image!.path),
      ),
      title: Text(
        widget.audio.metas.title ?? 'No Songs Found',
        style: const TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(widget.audio.metas.artist ?? '',
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
          Center(
            child: CircularProgressIndicator(
              color: Colors.grey.shade400,
            ),
          );
        }

        return Text(
          formatDuration(snapshots.data?.duration.inSeconds ?? 0),
          style: const TextStyle(color: Colors.white),
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
