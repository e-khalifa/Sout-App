import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:sout_app/widgets/app_logo.dart';
import 'package:sout_app/widgets/song_tile.dart';
import 'package:sout_app/widgets/volume_slider.dart';

import '../widgets/image_slider.dart';
import '../widgets/player_bottom_app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final assetsAudioPlayer = AssetsAudioPlayer();
  final CarouselController controller = CarouselController();
  int currentIndex = 0;

  bool showBottomAppBar = false;
  late Audio selectedAudio;

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
          children: [
            Text(
              'SOUT',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(width: 10),
            AppLogo(),
          ],
        ),
        actions: [
          PopupMenuButton<int>(
              shadowColor: Colors.black38,
              color: Colors.black54,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Padding(
                padding: EdgeInsets.only(right: 15),
                child: Icon(Icons.volume_up),
              ),
              itemBuilder: (context) {
                return [
                  const PopupMenuItem<int>(
                    value: 1,
                    child: VolumeSlider(),
                  )
                ];
              })
        ],
      ),
      body: Column(
        children: [
          CarouselSlider.builder(
            itemCount: playlist.audios.length,
            itemBuilder: (context, index, realIndex) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedAudio = playlist.audios[index];
                    showBottomAppBar = true; // Show the bottom app bar
                  });
                },
                child: ImageSlider(audio: playlist.audios[index]),
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
                dotsCount: playlist.audios.length,
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
              itemCount: playlist.audios.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedAudio = playlist.audios[index];
                      showBottomAppBar = true;
                    });
                  },
                  child: SongTile(audio: playlist.audios[index]),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar:
          showBottomAppBar ? PlayerBottomAppBar(audio: selectedAudio) : null,
    );
  }
}
