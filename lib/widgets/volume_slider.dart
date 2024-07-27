import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

class VolumeSlider extends StatefulWidget {
  const VolumeSlider({super.key});

  @override
  State<VolumeSlider> createState() => _VolumeSliderState();
}

//To Search: it doesn't work throughout the app, it only works on this instance
// TRY : - Get it one instance || - Pass the value || - Notifier

class _VolumeSliderState extends State<VolumeSlider> {
  final assetsAudioPlayer = AssetsAudioPlayer();
  double sliderValue = 1;

  @override
  void initState() {
    initPlayer();
    super.initState();
  }

  void initPlayer() async {
    assetsAudioPlayer.volume.listen((event) {
      sliderValue = event;
      print('$event');
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
        data: const SliderThemeData(
          trackHeight: 10,
        ),
        child: RotatedBox(
          quarterTurns: 3,
          child: Slider(
            value: sliderValue,
            onChanged: (newVolume) {
              setState(() {
                sliderValue = newVolume;
              });
              assetsAudioPlayer.setVolume(sliderValue);
            },
            min: 0,
            max: 1,
            divisions: 2,
            activeColor: Theme.of(context).primaryColor,
            inactiveColor: Colors.grey.shade400,
          ),
        ));
  }
}
