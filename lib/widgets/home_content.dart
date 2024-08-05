import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:sout_app/utlis/color_utility.dart';
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
  final CarouselController controller = CarouselController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          carouselController: controller,
          items: widget.playlist.map((audio) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedAudioNotifier.value = audio;
                  showBottomAppBarNotifier.value = true;
                });
              },
              child: ImageSlider(audio: audio),
            );
          }).toList(),
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
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: () => controller.previousPage(),
                icon: const Icon(Icons.arrow_back),
                color: ColorUtility.softGrey),
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
              color: ColorUtility.softGrey,
            )
          ],
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView(
            children: widget.playlist.map((audio) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedAudioNotifier.value = audio;
                    showBottomAppBarNotifier.value = true;
                  });
                },
                child: SongTile(audio: audio),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
