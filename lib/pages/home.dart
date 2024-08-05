import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sout_app/utlis/color_utility.dart';
import 'package:sout_app/widgets/app_logo.dart';
import 'package:sout_app/widgets/volume_slider.dart';

import '../bloc/songs_bloc.dart';
import '../widgets/home_content.dart';
import '../widgets/player_bottom_app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final assetsAudioPlayer = AssetsAudioPlayer();

  @override
  Widget build(BuildContext context) {
    context.read<SongsBloc>().add(LoadingSongsEvent());
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
              shadowColor: ColorUtility.mediumBlack,
              color: ColorUtility.black,
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
      body: BlocBuilder<SongsBloc, SongsState>(
        builder: (context, state) {
          if (state is LoadingSongsState) {
            return Center(
              child: CircularProgressIndicator(
                color: ColorUtility.softGrey,
              ),
            );
          } else if (state is LoadedSongsState) {
            return HomeContent(
              songs: state.songs,
              playlist: state.songs.map((song) {
                return Audio(
                  song.audio,
                  metas: Metas(
                    title: song.metas.title,
                    artist: song.metas.artist,
                    image: MetasImage.asset(song.metas.image),
                  ),
                );
              }).toList(),
            );
          } else if (state is ErrorState) {
            return Center(child: Text(state.error));
          }
          return Container();
        },
      ),
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: showBottomAppBarNotifier,
        builder: (context, value, _) {
          return value
              ? PlayerBottomAppBar(audio: selectedAudioNotifier.value as Audio)
              : const SizedBox.shrink();
        },
      ),
    );
  }
}
