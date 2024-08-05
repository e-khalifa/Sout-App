import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:sout_app/utlis/color_utility.dart';

import 'volume_slider.dart';

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
        widget.playlist,
      );
    } catch (e) {
      print('error in initPlayer $e');
    }
    assetsAudioPlayer.currentPosition.listen((event) {
      sliderValue = event.inSeconds;
    });
    assetsAudioPlayer.volume.listen((event) {
      print('Player<<<<<<<<<Volume event: $event');
    });

    assetsAudioPlayer.setVolume(volumeNotifier.value);
    print('Player<<<<<<<<<<<Volume level: ${volumeNotifier.value}');
    setState(() {});
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
    return StreamBuilder(
        stream: assetsAudioPlayer.realtimePlayingInfos,
        builder: (context, snapShots) {
          if (snapShots.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              color: ColorUtility.softGrey,
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
                      color: ColorUtility.softGrey,
                      fontSize: 14,
                    )),
                const SizedBox(height: 20),
                Slider(
                    inactiveColor: ColorUtility.softGrey,
                    activeColor: ColorUtility.main,
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
                            color: ColorUtility.softGrey,
                            fontSize: 12,
                          )),
                      Text(
                          formatDuration(
                              snapShots.data?.duration.inSeconds ?? 0),
                          style: TextStyle(
                            color: ColorUtility.softGrey,
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
                        disabledColor: ColorUtility.mediumGrey,
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
                        disabledColor: ColorUtility.mediumGrey,
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
                backgroundColor: ColorUtility.main,
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
