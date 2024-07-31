import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:route_transitions/route_transitions.dart';
import 'package:sout_app/widgets/volume_slider.dart';

import '../pages/song_player.dart';

class PlayerBottomAppBar extends StatefulWidget {
  final Audio audio;
  const PlayerBottomAppBar({required this.audio, super.key});

  @override
  State<PlayerBottomAppBar> createState() => _PlayerBottomAppBarState();
}

class _PlayerBottomAppBarState extends State<PlayerBottomAppBar> {
  final assetsAudioPlayer = AssetsAudioPlayer();

  @override
  void initState() {
    initPlayer();
    super.initState();
  }

  void initPlayer() async {
    assetsAudioPlayer.open(widget.audio, autoStart: true);
    assetsAudioPlayer.volume.listen((event) {
      print('Bottom Player<<<< volume event: $event');
    });
    assetsAudioPlayer.setVolume(volumeNotifier.value);
  }

  @override
  void dispose() {
    try {
      if (assetsAudioPlayer.isPlaying.value) assetsAudioPlayer.stopped;
      assetsAudioPlayer.dispose();
    } catch (e) {
      print('Error in dispoing asseteAudioPlayer $e');
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        slideUpWidget(
            newPage: SongPlayerPage(playlist: Playlist(audios: [widget.audio])),
            context: context);
      },
      child: Container(
        height: 70,
        decoration: const BoxDecoration(
          color: Colors.black38,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(25),
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
          trailing: playBtn,
        ),
      ),
    );
  }

  Widget get playBtn => assetsAudioPlayer.builderIsPlaying(
      builder: (context, isPlaying) => IconButton(
          color: Colors.white,
          icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow_sharp),
          iconSize: 35,
          onPressed: () {
            isPlaying ? assetsAudioPlayer.pause() : assetsAudioPlayer.play();
            setState(() {});
          }));
}
