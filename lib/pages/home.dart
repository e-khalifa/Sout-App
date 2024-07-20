import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:sout_app/widgets/song_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final assetsAudioPlayer = AssetsAudioPlayer();

  var playlist = Playlist(audios: [
    Audio('assets/audios/1.mp3',
        metas: Metas(
          title: 'What He Wrote',
          artist: 'Laura Marling',
          image:
              const MetasImage.asset('assets/images/I Speak Because I Can.jpg'),
        )),
    Audio('assets/audios/2.mp3',
        metas: Metas(
          title: 'Put Your Head On My Shoulder',
          artist: 'Paul Anka',
          image: const MetasImage.asset('assets/images/Paul Anka.jpg'),
        )),
    Audio('assets/audios/3.mp3',
        metas: Metas(
          title: 'Le temps de l\'amour',
          artist: 'Francois Hardy',
          image: const MetasImage.asset('assets/images/Francois Hardy.jpg'),
        )),
    Audio('assets/audios/4.mp3',
        metas: Metas(
          title: 'Amore che vieni, amore che vai',
          artist: 'Fabrizio De Andre',
          image: const MetasImage.asset('assets/images/Fabrizio De Andre.jpg'),
        )),
    Audio('assets/audios/5.mp3',
        metas: Metas(
          title: 'My Baby Shot Me Down',
          artist: 'Nancy Sinatra',
          image: const MetasImage.asset(
              'assets/images/How Does That Grab You.jpg'),
        )),
    Audio('assets/audios/6.mp3',
        metas: Metas(
          title: 'Wasn\'t Me',
          artist: 'Shaggy',
          image: const MetasImage.asset('assets/images/Wasn\'t Me.jpg'),
        )),
  ]);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'SOUT',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(width: 10),
              Icon(Icons.graphic_eq),
            ],
          ),
        ),
        body: ListView(
          children: [for (var audio in playlist.audios) SongTile(audio: audio)],
        ));
  }
}
