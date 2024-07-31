import 'dart:convert';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sout_app/widgets/app_logo.dart';
import 'package:sout_app/widgets/song_tile.dart';
import 'package:sout_app/widgets/volume_slider.dart';

import '../models/song.dart';
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
  List<Song> songs = [];
  List<Audio> playlist = [];

  bool showBottomAppBar = false;
  bool isDataLoading = false;

  late Audio selectedAudio;

  void addToPlaylist(List<Song> songs) {
    for (var song in songs) {
      var audio = Audio(
        song.audio,
        metas: Metas(
          title: song.metas.title,
          artist: song.metas.artist,
          image: MetasImage.asset(song.metas.image),
        ),
      );
      playlist.add(audio);
    }
    print('Playlist length: ${playlist.length}');
  }

  late var playlistEx = Playlist(audios: playlist);

  @override
  void initState() {
    super.initState();
    initList();
  }

  void initList() async {
    setState(() {
      isDataLoading = true;
    });

    var result = await rootBundle.loadString('assets/data/data.json');
    var response = jsonDecode(result);
    songs =
        List<Song>.from(response['data'].map((e) => Song.fromJson(e)).toList());
    if (songs.isNotEmpty) {
      print('Songs are not null. Total songs: ${songs.length}');
      addToPlaylist(songs);
    } else {
      print('No songs found.');
    }

    setState(() {
      isDataLoading = false;
    });
  }

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
      body: isDataLoading
          ? Center(
              child: CircularProgressIndicator(
              color: Colors.grey.shade400,
            ))
          : Column(
              children: [
                CarouselSlider.builder(
                  itemCount: playlist.length,
                  itemBuilder: (context, index, realIndex) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedAudio = playlist[index];
                          showBottomAppBar = true; // Show the bottom app bar
                        });
                      },
                      child: ImageSlider(audio: playlist[index]),
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
                      dotsCount: playlist.length,
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
                    itemCount: playlist.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedAudio = playlist[index];
                            showBottomAppBar = true;
                          });
                        },
                        child: SongTile(audio: playlist[index]),
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
