import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:sout_app/widgets/image_slider.dart';
import 'package:sout_app/widgets/song_tile.dart';

import '../models/song.dart';

var showBottomAppBarNotifier = ValueNotifier(false);
var selectedAudioNotifier = ValueNotifier<Audio?>(null);

class HomeContent extends StatefulWidget {
  final List<Song> songs;
  final List<Audio> playlist;

  const HomeContent({super.key, required this.songs, required this.playlist});

  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final assetsAudioPlayer = AssetsAudioPlayer();
  final CarouselController controller = CarouselController();
  int currentIndex = 0;

  /*@override
  void initState() {
    initPlayer();
    super.initState();
  }

  void initPlayer() async {
    assetsAudioPlayer.open(widget.playlist as Playable);
  }

  @override
  void dispose() {
    assetsAudioPlayer.dispose();
    super.dispose();
  }*/

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: widget.playlist.length,
          itemBuilder: (context, index, realIndex) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedAudioNotifier.value = widget.playlist[index];
                  showBottomAppBarNotifier.value = true;
                });
              },
              child: ImageSlider(audio: widget.playlist[index]),
            );
          },
          options: CarouselOptions(
            enlargeCenterPage: true,
            height: 230,
            autoPlay: true,
            onPageChanged: (index, reason) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
          carouselController: controller,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () => controller.previousPage(),
              icon: const Icon(Icons.arrow_back),
              color: Colors.grey.shade400,
            ),
            DotsIndicator(
              dotsCount: widget.playlist.length,
              position: currentIndex.toDouble(),
              decorator: const DotsDecorator(
                activeColor: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () => controller.nextPage(),
              icon: const Icon(Icons.arrow_forward),
              color: Colors.grey.shade400,
            )
          ],
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: widget.playlist.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedAudioNotifier.value = widget.playlist[index];
                    showBottomAppBarNotifier.value = true;
                  });
                },
                child: SongTile(audio: widget.playlist[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}
