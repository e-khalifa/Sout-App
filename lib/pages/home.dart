import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final assetsAudioPlayer = AssetsAudioPlayer();

  @override
  void initState() {
    initPlayer();
    super.initState();
  }

  void initPlayer() async {
    try {
      assetsAudioPlayer.open(
          autoStart: false,
          Playlist(audios: [
            Audio('assets/audios/1.mp3',
                metas: Metas(
                  title: 'What He Wrote',
                  artist: 'Laura Marling',
                  image:
                      const MetasImage.asset('assets/images/What He Wrote.jpg'),
                )),
            Audio('assets/audios/2.mp3',
                metas: Metas(
                  title: 'Put Your Head On My Shoulder',
                  artist: 'Paul Anka',
                  image: const MetasImage.asset(
                      'assets/images/Put Your Head On My Shoulder.jpg'),
                )),
            Audio('assets/audios/3.mp3',
                metas: Metas(
                  title: 'Le temps de l\'amour',
                  artist: 'Francois Hardy',
                  image: MetasImage.asset(
                      'assets/images/Le temps de l\'amour.jpg'),
                )),
            Audio('assets/audios/4.mp3',
                metas: Metas(
                  title: 'Amore che vieni, amore che vai',
                  artist: 'Fabrizio De Andre',
                  image: const MetasImage.asset(
                      'assets/images/Amore che vieni, amore che vai.jpg'),
                )),
            Audio('assets/audios/5.mp3',
                metas: Metas(
                  title: 'My Baby Shot Me Down',
                  artist: 'Nancy Sinatra',
                  image: const MetasImage.asset(
                      'assets/images/My Baby Shot Me Down.jpg'),
                )),
            Audio('assets/audios/6.mp3',
                metas: Metas(
                  title: 'Wasn\'t Me',
                  artist: 'Shaggy',
                  image: const MetasImage.asset('assets/images/Wasn\'t Me.jpg'),
                )),
          ]));
    } catch (e) {
      print('error in initPlayer $e');
    }
    setState(() {});
  }

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
        body: StreamBuilder(
            stream: assetsAudioPlayer.realtimePlayingInfos,
            builder: (context, snapShots) {
              if (snapShots.connectionState == ConnectionState.waiting) {
                return Center(
                    child: CircularProgressIndicator(
                  color: Colors.grey.shade400,
                ));
              }
              return Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        assetsAudioPlayer.getCurrentAudioImage!.path,
                        fit: BoxFit.cover,
                        height: 400,
                        width: 400,
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Text(
                      assetsAudioPlayer.getCurrentAudioTitle == ''
                          ? 'No Songs Found'
                          : assetsAudioPlayer.getCurrentAudioTitle,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                        assetsAudioPlayer.getCurrentAudioArtist == ''
                            ? ''
                            : assetsAudioPlayer.getCurrentAudioArtist,
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 14,
                        )),
                    const SizedBox(height: 20),
                    Slider(
                        inactiveColor: Colors.grey.shade400,
                        activeColor: Theme.of(context).primaryColor,
                        value: snapShots.data?.currentPosition.inSeconds
                                .toDouble() ??
                            0.0,
                        min: 0.0,
                        max: snapShots.data?.duration.inSeconds.toDouble() ??
                            0.0,
                        onChanged: (value) {
                          assetsAudioPlayer.seek(Duration(
                              seconds:
                                  value.toInt())); //converting value to seconds
                        }),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              formatDuration(
                                  snapShots.data?.currentPosition.inSeconds ??
                                      0),
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 12,
                              )),
                          Text(
                              formatDuration(
                                  snapShots.data?.duration.inSeconds ?? 0),
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 12,
                              ))
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                            iconSize: 25,
                            color: Colors.white,
                            disabledColor: Colors.grey.shade600,
                            icon: const Icon(
                              Icons.skip_previous,
                            ),
                            onPressed: snapShots.data?.current?.index == 0
                                ? null
                                : () => assetsAudioPlayer.previous()),
                        playBtn,
                        IconButton(
                            iconSize: 25,
                            color: Colors.white,
                            disabledColor: Colors.grey.shade600,
                            icon: const Icon(
                              Icons.skip_next,
                            ),
                            onPressed: snapShots.data?.current?.index ==
                                    (assetsAudioPlayer
                                                .playlist?.audios.length ??
                                            0) -
                                        1
                                ? null
                                : () => assetsAudioPlayer.next()),
                      ],
                    ),
                  ],
                ),
              );
            }));
  }

  String formatDuration(int durationInSec) {
    String minutes = (durationInSec ~/ 60).toString();
    String seconds = (durationInSec % 60).toString();
    return '${minutes.padLeft(2, '0')}:${seconds.padLeft(2, '0')}';
  }

  Widget get playBtn => assetsAudioPlayer.builderIsPlaying(
      builder: (context, isPlaying) => SizedBox(
            width: 70,
            height: 70,
            child: FloatingActionButton(
                backgroundColor: Theme.of(context).primaryColor,
                shape: const CircleBorder(),
                child: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow_sharp,
                  size: 40,
                ),
                onPressed: () {
                  isPlaying
                      ? assetsAudioPlayer.pause()
                      : assetsAudioPlayer.play();
                  setState(() {});
                }),
          ));
}
