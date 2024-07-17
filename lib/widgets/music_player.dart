import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

class MusicPlayer extends StatefulWidget {
  final Playlist playlist;
  const MusicPlayer({required this.playlist, super.key});

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  final assetsAudioPlayer = AssetsAudioPlayer();
  int sliderValue = 0;

  @override
  void initState() {
    initPlayer();
    super.initState();
  }

  void initPlayer() async {
    try {
      assetsAudioPlayer.open(
        autoStart: false,
        widget.playlist,
      );
    } catch (e) {
      print('error in initPlayer $e');
    }
    assetsAudioPlayer.currentPosition.listen((event) {
      sliderValue = event.inSeconds;
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
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
                    value: sliderValue.toDouble(),
                    min: 0.0,
                    max: snapShots.data?.duration.inSeconds.toDouble() ?? 0.0,

                    //To smooth the slide process (action wise):
                    //because the seek doesn't "slide", it's more like moving point by point
                    onChanged: (value) {
                      setState(() {
                        sliderValue = value.toInt();
                      });
                    },
                    onChangeEnd: (value) {
                      assetsAudioPlayer.seek(Duration(seconds: value.toInt()));
                    }),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          formatDuration(
                              snapShots.data?.currentPosition.inSeconds ?? 0),
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
                                (assetsAudioPlayer.playlist?.audios.length ??
                                        0) -
                                    1
                            ? null
                            : () => assetsAudioPlayer.next()),
                  ],
                ),
              ],
            ),
          );
        });
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
