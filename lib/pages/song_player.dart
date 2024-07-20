import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:sout_app/widgets/music_player.dart';

class SongPlayerPage extends StatefulWidget {
  final Playlist playlist;
  const SongPlayerPage({required this.playlist, super.key});

  @override
  State<SongPlayerPage> createState() => _SongPlayerPageState();
}

class _SongPlayerPageState extends State<SongPlayerPage> {
  final assetsAudioPlayer = AssetsAudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(), body: MusicPlayer(playlist: widget.playlist));
  }
}
